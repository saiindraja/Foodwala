
package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.daoimpl.MenuDAOImpl;
import com.tap.model.Menu;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/menus")
public class AdminMenuController extends HttpServlet {

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

        MenuDAOImpl dao = new MenuDAOImpl();

        List<Menu> menus = dao.getAllMenus();

        request.setAttribute("menus", menus);

        request.getRequestDispatcher(
                "/admin/menus.jsp").forward(request, response);
    }


@Override
protected void doPost(HttpServletRequest request,
                      HttpServletResponse response)
        throws ServletException, IOException {

    if (!isAdmin(request)) {
        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Admin access required");
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String action = request.getParameter("action");

    MenuDAOImpl dao = new MenuDAOImpl();

    try {
        if ("add".equals(action)) {

            String restaurantValue =
                    request.getParameter("restaurantId");
            String itemName = request.getParameter("itemName");
            String description =
                    request.getParameter("description");
            String priceValue = request.getParameter("price");
            String imagePath = request.getParameter("imagePath");
            String availableValue =
                    request.getParameter("isAvailable");

            if (restaurantValue == null
                    || restaurantValue.trim().isEmpty()
                    || itemName == null
                    || itemName.trim().isEmpty()
                    || description == null
                    || description.trim().isEmpty()
                    || priceValue == null
                    || priceValue.trim().isEmpty()
                    || availableValue == null
                    || (!"true".equals(availableValue)
                        && !"false".equals(availableValue))) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/menus?error=invalid");
                return;
            }

            int restaurantId =
                    Integer.parseInt(restaurantValue);
            double price = Double.parseDouble(priceValue);

            if (restaurantId <= 0 || price < 0
                    || Double.isNaN(price)
                    || Double.isInfinite(price)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/menus?error=invalid");
                return;
            }

            // Verify that the restaurant exists.
            com.tap.daoimpl.RestaurentDAOImpl restaurantDAO =
                    new com.tap.daoimpl.RestaurentDAOImpl();

            if (restaurantDAO.getRestaurent(restaurantId) == null) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/menus?error=restaurant");
                return;
            }

            Menu menu = new Menu();
            menu.setRestaurantId(restaurantId);
            menu.setItemName(itemName.trim());
            menu.setDescription(description.trim());
            menu.setPrice(price);
            menu.setImagePath(
                    imagePath == null ? "" : imagePath.trim());
            menu.setAvailable("true".equals(availableValue));

            dao.addMenu(menu);

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/menus?added=success");
            return;
        }

        if ("delete".equals(action)) {

            String menuIdValue =
                    request.getParameter("menuId");

            if (menuIdValue == null
                    || menuIdValue.trim().isEmpty()) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/menus?error=invalid");
                return;
            }

            int menuId = Integer.parseInt(menuIdValue);

            if (menuId <= 0 || dao.getMenu(menuId) == null) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/menus?error=invalid");
                return;
            }

            dao.deleteMenu(menuId);

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/menus?deleted=success");
            return;
        }

        if ("update".equals(action)) {

            int menuId = Integer.parseInt(
                    request.getParameter("menuId"));

            String itemName = request.getParameter("itemName");
            String description =
                    request.getParameter("description");
            String priceValue = request.getParameter("price");
            String availableValue =
                    request.getParameter("isAvailable");

            if (itemName == null || itemName.trim().isEmpty()
                    || description == null
                    || priceValue == null
                    || priceValue.trim().isEmpty()
                    || availableValue == null
                    || (!"true".equals(availableValue)
                        && !"false".equals(availableValue))) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/menus?error=invalid");
                return;
            }

            double price = Double.parseDouble(priceValue);

            if (price < 0 || Double.isNaN(price)
                    || Double.isInfinite(price)) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/menus?error=price");
                return;
            }

            Menu menu = dao.getMenu(menuId);

            if (menu == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Menu item not found");
                return;
            }

            menu.setItemName(itemName.trim());
            menu.setDescription(description.trim());
            menu.setPrice(price);
            menu.setAvailable("true".equals(availableValue));

            dao.updateMenu(menu);

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/menus?updated=success");
            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/admin/menus?error=invalid");

    } catch (NumberFormatException e) {
        response.sendRedirect(
                request.getContextPath()
                + "/admin/menus?error=invalid");
    }
}

}
