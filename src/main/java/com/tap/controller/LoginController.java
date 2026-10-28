
package com.tap.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.Cart;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // Validate login details
        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp?error=required");

            return;
        }

        // Get user from database
        UserDAOImpl userDAO = new UserDAOImpl();

        User user = userDAO.getUser(email);

        // Verify the entered password against the BCrypt hash
        if (user != null
                && user.getPassword() != null
                && BCrypt.checkpw(password, user.getPassword())) {

            HttpSession session = req.getSession();

            // Store logged-in user
            session.setAttribute("user", user);
            
            if ("admin".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
                return;
            }

            // Check whether user came for checkout
            Boolean returnToCheckout =
                    (Boolean) session.getAttribute("returnToCheckout");

            if (Boolean.TRUE.equals(returnToCheckout)) {

                session.removeAttribute("returnToCheckout");

                resp.sendRedirect(
                        req.getContextPath() + "/checkout");

                return;
            }

            // Normal login flow
            Cart cart = (Cart) session.getAttribute("cart");

            if (cart != null && !cart.isEmpty()) {

                resp.sendRedirect(
                        req.getContextPath() + "/cart");

            } else {

                resp.sendRedirect(
                        req.getContextPath() + "/restaurent");
            }

        } else {

            // Invalid login
            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp?error=invalid");
        }
    }
}
