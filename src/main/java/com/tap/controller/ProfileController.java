package com.tap.controller;

import java.io.IOException;

import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Check whether user is logged in
        if (session == null || session.getAttribute("user") == null) {

            resp.sendRedirect(
                req.getContextPath() + "/login.jsp"
            );

            return;
        }

        // Get logged-in user from session
        User sessionUser = (User) session.getAttribute("user");

        // Get latest user details from database
        UserDAOImpl userDAO = new UserDAOImpl();

        User user = userDAO.getUser(sessionUser.getUserId());

        // Update session with latest database details
        session.setAttribute("user", user);

        // Send user to profile.jsp
        req.setAttribute("user", user);

        req.getRequestDispatcher("/profile.jsp")
           .forward(req, resp);
    }


    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Check whether user is logged in
        if (session == null || session.getAttribute("user") == null) {

            resp.sendRedirect(
                req.getContextPath() + "/login.jsp"
            );

            return;
        }

        // Get current logged-in user
        User currentUser = (User) session.getAttribute("user");

        // Get updated values from profile.jsp
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        // Keep existing role
        String role = currentUser.getRole();

        // Check required fields
        if (username == null || username.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || address == null || address.trim().isEmpty()) {

            resp.sendRedirect(
                req.getContextPath()
                + "/profile?error=required"
            );

            return;
        }

        // Create updated User object
        User updatedUser = new User();

        updatedUser.setUserId(currentUser.getUserId());
        updatedUser.setUsername(username);
        updatedUser.setPassword(password);
        updatedUser.setEmail(email);
        updatedUser.setPhone(phone);
        updatedUser.setAddress(address);
        updatedUser.setRole(role);

        // Update database
        UserDAOImpl userDAO = new UserDAOImpl();

        userDAO.updateUser(updatedUser);

        // Update session with new details
        session.setAttribute("user", updatedUser);

        // Go back to profile page
        resp.sendRedirect(
            req.getContextPath()
            + "/profile?updated=success"
        );
    }
}