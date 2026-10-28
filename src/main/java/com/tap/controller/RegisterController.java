
package com.tap.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String role = req.getParameter("role");

        // Check required fields
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || address == null || address.trim().isEmpty()
                || role == null || role.trim().isEmpty()) {

            resp.sendRedirect(
                req.getContextPath() + "/register.jsp?error=required"
            );
            return;
        }

        // Hash the password using BCrypt
        String hashedPassword =
                BCrypt.hashpw(password, BCrypt.gensalt());

        // Create User object with the hashed password
        User user = new User(
            username,
            hashedPassword,
            email,
            phone,
            address,
            role
        );

        // Save user into database
        UserDAOImpl userDAO = new UserDAOImpl();
        userDAO.addUser(user);

        // Registration successful
        resp.sendRedirect(
            req.getContextPath() + "/login.jsp?registered=success"
        );
    }
}
