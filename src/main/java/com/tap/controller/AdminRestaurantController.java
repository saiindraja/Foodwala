
package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.daoimpl.RestaurentDAOImpl;
import com.tap.model.Restaurent;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/restaurants")
public class AdminRestaurantController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean isAdmin(HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        if (session == null) {
            return false;
        }

        User user = (User) session.getAttribute("user");

        return user != null
                && user.getRole() != null
                && "admin".equalsIgnoreCase(user.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        RestaurentDAOImpl dao = new RestaurentDAOImpl();

        List<Restaurent> restaurents = dao.getAllRestaurents();

        request.setAttribute("restaurents", restaurents);

        request.getRequestDispatcher(
                "/admin/restaurants.jsp").forward(request, response);
    }



@Override
protected void doPost(HttpServletRequest request,
                      HttpServletResponse response)
        throws ServletException, IOException {

    if (!isAdmin(request)) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Admin access required");
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String action = request.getParameter("action");
    RestaurentDAOImpl dao = new RestaurentDAOImpl();

    if ("add".equals(action)) {

        String name = request.getParameter("name");
        String cuisineType = request.getParameter("cuisineType");
        String deliveryTime = request.getParameter("deliveryTime");
        String address = request.getParameter("address");
        String adminUserIdValue = request.getParameter("adminUserId");
        String ratingValue = request.getParameter("rating");
        String imagePath = request.getParameter("imagePath");

        if (name == null || name.trim().isEmpty()
                || cuisineType == null || cuisineType.trim().isEmpty()
                || deliveryTime == null || deliveryTime.trim().isEmpty()
                || address == null || address.trim().isEmpty()
                || adminUserIdValue == null || ratingValue == null) {

            response.sendRedirect(request.getContextPath()
                    + "/admin/restaurants?error=missingFields");
            return;
        }

        try {
            int adminUserId = Integer.parseInt(adminUserIdValue);
            double rating = Double.parseDouble(ratingValue);

            if (adminUserId <= 0 || rating < 0 || rating > 5) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/restaurants?error=invalidFields");
                return;
            }

            Restaurent restaurant = new Restaurent();
            restaurant.setName(name.trim());
            restaurant.setCuisineType(cuisineType.trim());
            restaurant.setDeliveryTime(deliveryTime.trim());
            restaurant.setAddress(address.trim());
            restaurant.setAdminUserId(adminUserId);
            restaurant.setRating(rating);
            restaurant.setActive(true);
            restaurant.setImagePath(
                    imagePath == null || imagePath.trim().isEmpty()
                            ? null : imagePath.trim());

            dao.addRestaurent(restaurant);

            response.sendRedirect(request.getContextPath()
                    + "/admin/restaurants?added=success");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/restaurants?error=invalidFields");
        }

    } else if ("update".equals(action)) {

        String idValue = request.getParameter("restaurantId");
        String deliveryTime = request.getParameter("deliveryTime");
        String activeValue = request.getParameter("isActive");

        try {
            int restaurantId = Integer.parseInt(idValue);

            if (deliveryTime == null || deliveryTime.trim().isEmpty()
                    || deliveryTime.trim().length() > 50) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/restaurants?error=deliveryTime");
                return;
            }

            Restaurent restaurant = dao.getRestaurent(restaurantId);

            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Restaurant not found");
                return;
            }

            restaurant.setDeliveryTime(deliveryTime.trim());
            restaurant.setActive("true".equals(activeValue));

            dao.updateRestaurent(restaurant);

            response.sendRedirect(request.getContextPath()
                    + "/admin/restaurants?updated=success");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid restaurant ID");
        }

    } else if ("delete".equals(action)) {

        try {
            int restaurantId = Integer.parseInt(
                    request.getParameter("restaurantId"));

            Restaurent restaurant = dao.getRestaurent(restaurantId);

            if (restaurant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Restaurant not found");
                return;
            }

            dao.deleteRestaurent(restaurantId);

            response.sendRedirect(request.getContextPath()
                    + "/admin/restaurants?deleted=success");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid restaurant ID");
        }

    } else {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                "Invalid restaurant action");
    }
    }
}
