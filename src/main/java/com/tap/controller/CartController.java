package com.tap.controller;

import java.io.IOException;

import com.tap.daoimpl.MenuDAOImpl;
import com.tap.model.Cart;
import com.tap.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        MenuDAOImpl menuDao = new MenuDAOImpl();

        // ==========================================
        // ADD TO CART
        // ==========================================

        if ("add".equals(action)) {

            int menuId = Integer.parseInt(
                req.getParameter("menuId")
            );

            Menu menu = menuDao.getMenu(menuId);

            if (menu == null) {

                resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant.jsp?error=menuNotFound"
                );

                return;
            }

            if (!menu.isAvailable()) {

                resp.sendRedirect(
                    req.getContextPath()
                    + "/menu?restaurantId="
                    + menu.getRestaurantId()
                    + "&error=itemNotAvailable"
                );

                return;
            }

            HttpSession session = req.getSession();

            Cart cart =
                (Cart) session.getAttribute("cart");

            if (cart == null) {

                cart = new Cart();

                session.setAttribute("cart", cart);
            }

            boolean added = cart.addItem(menu);

            if (added) {

                session.setAttribute("cart", cart);

                // Remember restaurant
                session.setAttribute(
                    "lastRestaurantId",
                    menu.getRestaurantId()
                );

                // AJAX request
                if ("true".equals(
                        req.getParameter("ajax"))) {

                    resp.setContentType(
                        "text/plain;charset=UTF-8"
                    );

                    resp.getWriter().write(
                        cart.getItemQuantity(menuId)
                        + "|"
                        + cart.getTotalQuantity()
                    );

                    return;
                }

                resp.sendRedirect(
                    req.getContextPath()
                    + "/menu?restaurantId="
                    + menu.getRestaurantId()
                );

            } else {

                // ==========================================
                // DIFFERENT RESTAURANT
                // ==========================================

                if ("true".equals(
                        req.getParameter("ajax"))) {

                    resp.setContentType(
                        "text/plain;charset=UTF-8"
                    );

                    /*
                     * Tell menu.jsp that the selected
                     * item belongs to another restaurant.
                     */
                    resp.getWriter().write(
                        "DIFFERENT_RESTAURANT"
                        + "|"
                        + menu.getMenuId()
                    );

                    return;
                }

                resp.sendRedirect(
                    req.getContextPath()
                    + "/menu?restaurantId="
                    + menu.getRestaurantId()
                    + "&cartError=differentRestaurant"
                    + "&menuId="
                    + menu.getMenuId()
                );
            }
        }

        // ==========================================
        // CLEAR OLD CART AND ADD NEW ITEM
        // ==========================================

        else if ("clearAndAdd".equals(action)) {

            int menuId = Integer.parseInt(
                req.getParameter("menuId")
            );

            Menu menu = menuDao.getMenu(menuId);

            if (menu == null) {

                resp.sendRedirect(
                    req.getContextPath()
                    + "/restaurant.jsp?error=menuNotFound"
                );

                return;
            }

            if (!menu.isAvailable()) {

                resp.sendRedirect(
                    req.getContextPath()
                    + "/menu?restaurantId="
                    + menu.getRestaurantId()
                    + "&error=itemNotAvailable"
                );

                return;
            }

            HttpSession session = req.getSession();

            Cart cart =
                (Cart) session.getAttribute("cart");

            if (cart == null) {

                cart = new Cart();

            } else {

                cart.clear();
            }

            cart.addItem(menu);

            session.setAttribute("cart", cart);

            // Remember restaurant
            session.setAttribute(
                "lastRestaurantId",
                menu.getRestaurantId()
            );

            // AJAX request
            if ("true".equals(
                    req.getParameter("ajax"))) {

                resp.setContentType(
                    "text/plain;charset=UTF-8"
                );

                resp.getWriter().write(
                    cart.getItemQuantity(menuId)
                    + "|"
                    + cart.getTotalQuantity()
                );

                return;
            }

            resp.sendRedirect(
                req.getContextPath()
                + "/menu?restaurantId="
                + menu.getRestaurantId()
            );
        }

        // ==========================================
        // UPDATE QUANTITY
        // ==========================================

        else if ("update".equals(action)) {

            int menuId = Integer.parseInt(
                req.getParameter("menuId")
            );

            int quantity = Integer.parseInt(
                req.getParameter("quantity")
            );

            HttpSession session = req.getSession();

            Cart cart =
                (Cart) session.getAttribute("cart");

            if (cart != null) {

                /*
                 * quantity = 2
                 * becomes 1
                 *
                 * quantity = 1
                 * becomes 0
                 *
                 * quantity = 0
                 * removes item
                 */

                cart.updateQuantity(
                    menuId,
                    quantity
                );

                session.setAttribute(
                    "cart",
                    cart
                );
            }

            // ======================================
            // AJAX UPDATE
            // ======================================

            if ("true".equals(
                    req.getParameter("ajax"))) {

                resp.setContentType(
                    "text/plain;charset=UTF-8"
                );

                int currentQuantity = 0;
                int totalQuantity = 0;
                double totalAmount = 0;

                if (cart != null) {

                    currentQuantity =
                        cart.getItemQuantity(menuId);

                    totalQuantity =
                        cart.getTotalQuantity();

                    totalAmount =
                        cart.getTotalAmount();
                }

                /*
                 * Response format:
                 *
                 * currentQuantity|totalQuantity|totalAmount
                 */

                resp.getWriter().write(
                    currentQuantity
                    + "|"
                    + totalQuantity
                    + "|"
                    + totalAmount
                );

                return;
            }

            // Normal request
            resp.sendRedirect(
                req.getContextPath()
                + "/cart"
            );
        }

        // ==========================================
        // REMOVE ITEM
        // ==========================================

        else if ("remove".equals(action)) {

            int menuId = Integer.parseInt(
                req.getParameter("menuId")
            );

            HttpSession session = req.getSession();

            Cart cart =
                (Cart) session.getAttribute("cart");

            if (cart != null) {

                cart.removeItem(menuId);

                session.setAttribute(
                    "cart",
                    cart
                );
            }

            if ("true".equals(
                    req.getParameter("ajax"))) {

                resp.setContentType(
                    "text/plain;charset=UTF-8"
                );

                int totalQuantity = 0;
                double totalAmount = 0;

                if (cart != null) {

                    totalQuantity =
                        cart.getTotalQuantity();

                    totalAmount =
                        cart.getTotalAmount();
                }

                resp.getWriter().write(
                    "0"
                    + "|"
                    + totalQuantity
                    + "|"
                    + totalAmount
                );

                return;
            }

            resp.sendRedirect(
                req.getContextPath()
                + "/cart"
            );
        }

        // ==========================================
        // CLEAR CART
        // ==========================================

        else if ("clear".equals(action)) {

            HttpSession session = req.getSession();

            Cart cart =
                (Cart) session.getAttribute("cart");

            if (cart != null) {

                /*
                 * IMPORTANT:
                 *
                 * Cart.clear() clears the
                 * current cart items.
                 */

                int restaurantId =
                    cart.getRestaurantId();

                cart.clear();

                session.setAttribute(
                    "cart",
                    cart
                );

                // Remember restaurant separately
                if (restaurantId > 0) {

                    session.setAttribute(
                        "lastRestaurantId",
                        restaurantId
                    );
                }
            }

            resp.sendRedirect(
                req.getContextPath()
                + "/cart"
            );
        }
    }

    // ==========================================
    // OPEN CART PAGE
    // ==========================================

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        resp.setCharacterEncoding("UTF-8");

        resp.setContentType(
            "text/html;charset=UTF-8"
        );

        req.getRequestDispatcher(
            "/cart.jsp"
        ).forward(req, resp);
    }
}