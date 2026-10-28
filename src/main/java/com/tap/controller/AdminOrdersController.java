
package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.daoimpl.OrderDAOImpl;
import com.tap.model.Order;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/orders")
public class AdminOrdersController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDAOImpl orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAOImpl();
    }

    private boolean isAdmin(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return false;
        }

        User user = (User) session.getAttribute("user");

        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return false;
        }

        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        List<Order> orders = orderDAO.getAllOrders();

        request.setAttribute("orders", orders);

        request.getRequestDispatcher("/admin/orders.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        try {
            int orderId = Integer.parseInt(
                request.getParameter("orderId"));

            String status = request.getParameter("status");

            if (status == null ||
                !(status.equals("Pending") ||
                  status.equals("Confirmed") ||
                  status.equals("Preparing") ||
                  status.equals("Out for Delivery") ||
                  status.equals("Delivered") ||
                  status.equals("Cancelled"))) {

                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid order status");
                return;
            }

            Order order = orderDAO.getOrder(orderId);

            if (order == null) {
                response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Order not found");
                return;
            }

            order.setStatus(status);
            orderDAO.updateOrder(order);

            response.sendRedirect(
                request.getContextPath()
                + "/admin/orders?updated=success");

        } catch (NumberFormatException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid order ID");
        }
    }
}
