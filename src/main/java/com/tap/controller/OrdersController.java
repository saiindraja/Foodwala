package com.tap.controller;

import java.io.IOException;
import java.util.List;
import com.tap.dao.OrderDAO;
import com.tap.daoimpl.OrderDAOImpl;
import com.tap.model.Order;
import com.tap.model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrdersController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Order> orders = orderDAO.getOrdersByUser(user.getUserId());

        // Sort this user's orders oldest first so the JSP can show #1, #2, #3...
        // These are display numbers, not database primary keys.
        if (orders != null) {
            orders.sort((a, b) -> {
                String dateA = a.getOrderDate() == null ? "" : a.getOrderDate().toString();
                String dateB = b.getOrderDate() == null ? "" : b.getOrderDate().toString();
                int dateCompare = dateA.compareTo(dateB);
                return dateCompare != 0 ? dateCompare
                        : Integer.compare(a.getOrderId(), b.getOrderId());
            });
        }

        request.setAttribute("orders", orders);
        RequestDispatcher rd = request.getRequestDispatcher("/orders.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
