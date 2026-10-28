
package com.tap.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

import com.tap.daoimpl.OrderDAOImpl;
import com.tap.daoimpl.OrderItemDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // Check cart
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Check login
        User user = (User) session.getAttribute("user");

        if (user == null) {
            session.setAttribute("returnToCheckout", true);

            resp.sendRedirect(
                    req.getContextPath() + "/login.jsp");
            return;
        }

        // Send cart and user to checkout.jsp
        req.setAttribute("cart", cart);
        req.setAttribute("user", user);

        RequestDispatcher rd =
                req.getRequestDispatcher("/checkout.jsp");

        rd.forward(req, resp);
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // ==========================================
        // CHECK LOGIN
        // ==========================================

        User user = (User) session.getAttribute("user");

        if (user == null) {
            session.setAttribute("returnToCheckout", true);

            resp.sendRedirect(
                    req.getContextPath() + "/login.jsp");
            return;
        }

        // ==========================================
        // CHECK CART
        // ==========================================

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(
                    req.getContextPath() + "/cart");
            return;
        }

        // ==========================================
        // GET DELIVERY DETAILS
        // ==========================================

        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String pincode = req.getParameter("pincode");
        String instructions = req.getParameter("instructions");

        // ==========================================
        // GET PAYMENT METHOD
        // ==========================================

        String paymentMethod =
                req.getParameter("paymentMethod");

        // ==========================================
        // GET PAYMENT DETAILS
        // ==========================================

        String upiId = req.getParameter("upiId");
        String cardNumber = req.getParameter("cardNumber");
        String expiry = req.getParameter("expiry");
        String cvv = req.getParameter("cvv");

        // ==========================================
        // VALIDATE DELIVERY DETAILS
        // ==========================================

        if (name == null || name.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || address == null || address.trim().isEmpty()
                || city == null || city.trim().isEmpty()
                || pincode == null || pincode.trim().isEmpty()) {

            req.setAttribute(
                    "error",
                    "Please fill all delivery details.");

            req.setAttribute("cart", cart);
            req.setAttribute("user", user);

            RequestDispatcher rd =
                    req.getRequestDispatcher("/checkout.jsp");

            rd.forward(req, resp);
            return;
        }

        // ==========================================
        // VALIDATE PAYMENT METHOD
        // ==========================================

        if (paymentMethod == null
                || paymentMethod.trim().isEmpty()) {

            req.setAttribute(
                    "error",
                    "Please select a payment method.");

            req.setAttribute("cart", cart);
            req.setAttribute("user", user);

            RequestDispatcher rd =
                    req.getRequestDispatcher("/checkout.jsp");

            rd.forward(req, resp);
            return;
        }

        // ==========================================
        // VALIDATE UPI
        // ==========================================

        if ("UPI".equals(paymentMethod)) {

            if (upiId == null || upiId.trim().isEmpty()) {

                req.setAttribute(
                        "error",
                        "Please enter your UPI ID.");

                req.setAttribute("cart", cart);
                req.setAttribute("user", user);

                RequestDispatcher rd =
                        req.getRequestDispatcher("/checkout.jsp");

                rd.forward(req, resp);
                return;
            }
        }

        // ==========================================
        // VALIDATE CARD
        // ==========================================

        if ("CARD".equals(paymentMethod)) {

            if (cardNumber == null
                    || cardNumber.trim().isEmpty()
                    || expiry == null
                    || expiry.trim().isEmpty()
                    || cvv == null
                    || cvv.trim().isEmpty()) {

                req.setAttribute(
                        "error",
                        "Please enter all card details.");

                req.setAttribute("cart", cart);
                req.setAttribute("user", user);

                RequestDispatcher rd =
                        req.getRequestDispatcher("/checkout.jsp");

                rd.forward(req, resp);
                return;
            }
        }

        // ==========================================
        // CREATE COMPLETE DELIVERY ADDRESS
        // ==========================================

        String fullAddress =
                address + ", " + city + " - " + pincode;

        if (instructions != null
                && !instructions.trim().isEmpty()) {

            fullAddress =
                    fullAddress
                    + ", Instructions: "
                    + instructions;
        }

        // ==========================================
        // CREATE ORDER
        // ==========================================

        Order order = new Order();

        order.setUserId(user.getUserId());

        order.setRestaurantId(
                cart.getRestaurantId());

        order.setOrderDate(
                new Timestamp(System.currentTimeMillis()));

        order.setTotalAmount(
                cart.getTotalAmount());

        order.setStatus("PLACED");

        order.setPaymentMethod(paymentMethod);

        order.setAddress(fullAddress);

        // ==========================================
        // INSERT ORDER
        // ==========================================

        OrderDAOImpl orderDAO =
                new OrderDAOImpl();

        int orderId = orderDAO.addOrder(order);

        // ==========================================
        // CHECK ORDER INSERT
        // ==========================================

        if (orderId <= 0) {

            req.setAttribute(
                    "error",
                    "Unable to place order. Please try again.");

            req.setAttribute("cart", cart);
            req.setAttribute("user", user);

            RequestDispatcher rd =
                    req.getRequestDispatcher("/checkout.jsp");

            rd.forward(req, resp);
            return;
        }

        // ==========================================
        // INSERT ORDER ITEMS
        // ==========================================

        OrderItemDAOImpl orderItemDAO =
                new OrderItemDAOImpl();

        for (CartItem cartItem : cart.getItems()) {

            OrderItem orderItem =
                    new OrderItem();

            orderItem.setOrderId(orderId);

            orderItem.setMenuId(
                    cartItem.getMenu().getMenuId());

            orderItem.setQuantity(
                    cartItem.getQuantity());

            orderItem.setPrice(
                    cartItem.getMenu().getPrice());

            orderItemDAO.addOrderItem(orderItem);
        }

        // ==========================================
        // CALCULATE USER-SPECIFIC ORDER NUMBER
        // ==========================================

        List<Order> userOrders =
                orderDAO.getOrdersByUser(user.getUserId());

        int displayOrderNumber = 1;

        if (userOrders != null) {

            userOrders.sort((a, b) -> {

                String dateA = a.getOrderDate() == null
                        ? "" : a.getOrderDate().toString();

                String dateB = b.getOrderDate() == null
                        ? "" : b.getOrderDate().toString();

                int dateCompare = dateA.compareTo(dateB);

                if (dateCompare != 0) {
                    return dateCompare;
                }

                return Integer.compare(
                        a.getOrderId(),
                        b.getOrderId());
            });

            for (int i = 0; i < userOrders.size(); i++) {

                if (userOrders.get(i).getOrderId() == orderId) {
                    displayOrderNumber = i + 1;
                    break;
                }
            }
        }

        // ==========================================
        // CLEAR CART AFTER SUCCESSFUL ORDER
        // ==========================================

        int restaurantId = cart.getRestaurantId();

        cart.clear();

        session.setAttribute("cart", cart);

        session.setAttribute(
                "lastRestaurantId",
                restaurantId);

        // ==========================================
        // STORE BOTH ORDER NUMBERS
        // ==========================================

        // Actual database ID: keep for database references
        session.setAttribute(
                "lastOrderId",
                orderId);

        // User-specific display number: show on success page
        session.setAttribute(
                "lastOrderDisplayNumber",
                displayOrderNumber);

        // ==========================================
        // ORDER SUCCESS
        // ==========================================

        resp.sendRedirect(
                req.getContextPath()
                + "/orderSuccess.jsp");
    }
}