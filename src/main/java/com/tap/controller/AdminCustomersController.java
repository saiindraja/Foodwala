
package com.tap.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/customers")
public class AdminCustomersController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAOImpl userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        User loggedInUser = (session == null)
                ? null
                : (User) session.getAttribute("user");

        // Only admins can view registered customers
        if (loggedInUser == null
                || loggedInUser.getRole() == null
                || !"admin".equalsIgnoreCase(loggedInUser.getRole())) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        // Fetch all users and keep only customer accounts
        List<User> allUsers = userDAO.getAllUsers();
        List<User> customers = new ArrayList<>();

        for (User user : allUsers) {
            if (user.getRole() != null
                    && "customer".equalsIgnoreCase(user.getRole())) {
                customers.add(user);
            }
        }

        request.setAttribute("customers", customers);

        request.getRequestDispatcher("/admin/customers.jsp")
               .forward(request, response);
    }
}
