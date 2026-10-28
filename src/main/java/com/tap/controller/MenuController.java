
package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.dao.MenuDAO;
import com.tap.dao.RestaurentDAO;
import com.tap.daoimpl.MenuDAOImpl;
import com.tap.daoimpl.RestaurentDAOImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurent;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/menu")
public class MenuController extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String restaurantIdParameter =
                req.getParameter("restaurantId");

        if (restaurantIdParameter == null ||
                restaurantIdParameter.trim().isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath() + "/restaurant.jsp"
            );
            return;
        }

        int restaurantId;

        try {
            restaurantId = Integer.parseInt(
                    restaurantIdParameter
            );
        } catch (NumberFormatException e) {
            resp.sendRedirect(
                    req.getContextPath() + "/restaurant.jsp"
            );
            return;
        }

        // Never use restaurantId 0
        if (restaurantId <= 0) {
            resp.sendRedirect(
                    req.getContextPath() + "/restaurant.jsp"
            );
            return;
        }

        // Get restaurant details
        RestaurentDAO restaurentDAO =
                new RestaurentDAOImpl();

        Restaurent restaurent =
                restaurentDAO.getRestaurent(restaurantId);

        // If restaurant does not exist, return to restaurants
        if (restaurent == null) {
            resp.sendRedirect(
                    req.getContextPath() + "/restaurent"
            );
            return;
        }

        // Pass restaurant status and name to menu.jsp
        req.setAttribute(
                "restaurantActive",
                restaurent.isActive()
        );

        req.setAttribute(
                "restaurantName",
                restaurent.getName()
        );

        // Fetch menu items even if the restaurant is inactive
        MenuDAO menuDAO =
                new MenuDAOImpl();

        List<Menu> menus =
                menuDAO.getAllMenuByRestaurantId(
                        restaurantId
                );

        req.setAttribute("menus", menus);

        req.setAttribute(
                "restaurantId",
                restaurantId
        );

        // Remember current restaurant
        HttpSession session = req.getSession();

        session.setAttribute(
                "lastRestaurantId",
                restaurantId
        );

        // Open menu page
        RequestDispatcher rd =
                req.getRequestDispatcher("/menu.jsp");

        rd.forward(req, resp);
    }
}
