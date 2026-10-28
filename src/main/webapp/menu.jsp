
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<Menu> menus =
            (List<Menu>) request.getAttribute("menus");

    Integer restaurantIdObject =
            (Integer) request.getAttribute("restaurantId");

    int restaurantId = 0;

    if (restaurantIdObject != null) {
        restaurantId = restaurantIdObject;
    }

    // NEW: Get restaurant active status from MenuController
    Boolean activeStatus =
            (Boolean) request.getAttribute("restaurantActive");

    boolean restaurantActive =
            activeStatus != null && activeStatus;

    String restaurantName =
            (String) request.getAttribute("restaurantName");

    Cart cart = (Cart) session.getAttribute("cart");

    if (cart == null) {
        cart = new Cart();
        session.setAttribute("cart", cart);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Foodwala - Menu</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/common.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/menu.css">

    <style>
        .add-btn:disabled,
        .quantity-btn:disabled {
            background: #bdbdbd !important;
            color: #666 !important;
            cursor: not-allowed !important;
            opacity: 0.7;
        }

        .restaurant-unavailable {
            color: #b42318;
            background: #fff0ee;
            border: 1px solid #ffd0c9;
            border-radius: 8px;
            padding: 12px 16px;
            margin-bottom: 20px;
            font-weight: 600;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar">

    <a href="<%= request.getContextPath() %>/restaurent"
       class="logo">
        Foodwala
    </a>

    <div class="nav-links">

        <a href="<%= request.getContextPath() %>/restaurent">
            Restaurants
        </a>

        <a href="<%= request.getContextPath() %>/orders">
            Orders
        </a>

        <%
            Object loggedUser = session.getAttribute("loggedInUser");

            if (loggedUser != null) {
        %>

            <a href="<%= request.getContextPath() %>/profile"
               class="user-link">
                Profile
            </a>

            <a href="<%= request.getContextPath() %>/logout"
               class="logout-link">
                Logout
            </a>

        <%
            } else {
        %>

            <a href="<%= request.getContextPath() %>/login">
                Login
            </a>

        <%
            }
        %>

    </div>

    <a class="cart-link"
       href="<%= request.getContextPath() %>/cart">

        🛒 Cart

        <span class="cart-count" id="cartCount">
            <%= cart.getTotalQuantity() %>
        </span>

    </a>

</nav>


<!-- MENU PAGE -->
<main class="menu-page">

    <div class="menu-container">

        <div class="menu-top">

            <div>

                <span class="menu-eyebrow">
                    🍽️ FOODWALA MENU
                </span>

                <h1 class="menu-title">
                    <%= restaurantName != null
                            ? restaurantName
                            : "Restaurant Menu" %>
                </h1>

                <p class="menu-subtitle">
                    Fresh, delicious food made for your cravings.
                </p>

            </div>

            <button
                type="button"
                class="all-restaurants-btn"
                onclick="window.location.href='<%= request.getContextPath() %>/restaurent'">

                🍽️ All Restaurants

            </button>

        </div>

        <% if (!restaurantActive) { %>

            <div class="restaurant-unavailable">
                This restaurant is currently unavailable.
                You can view its menu, but ordering is disabled.
            </div>

        <% } %>


        <!-- MENU ITEMS -->
        <%
            if (menus == null || menus.isEmpty()) {
        %>

            <div class="empty-menu">

                <div class="empty-menu-icon">
                    🍽️
                </div>

                <h2>No menu items available</h2>

                <p>
                    This restaurant has no menu items available right now.
                </p>

                <button
                    type="button"
                    class="all-restaurants-btn"
                    onclick="window.location.href='<%= request.getContextPath() %>/restaurent'">

                    Explore Restaurants

                </button>

            </div>

        <%
            } else {
        %>

            <div class="menu-grid">

                <%
                    for (Menu menu : menus) {

                        int menuQuantity = 0;

                        for (CartItem cartItem : cart.getItems()) {

                            if (cartItem.getMenu().getMenuId()
                                    == menu.getMenuId()) {

                                menuQuantity = cartItem.getQuantity();
                                break;
                            }
                        }

                        boolean canOrder =
                                restaurantActive && menu.isAvailable();
                %>

                    <div class="menu-card">

                        <div class="menu-image-container">

                            <img
                                class="menu-image"
                                src="<%= menu.getImagePath() %>"
                                alt="<%= menu.getItemName() %>"
                                onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">

                            <div class="image-fallback">
                                🍽️
                            </div>

                        <% if (canOrder) { %>

    <span class="availability-badge">
        Available
    </span>

<% } else { %>

    <span class="availability-badge unavailable">
Unavailable
    </span>

<% } %>

                        </div>


                        <div class="menu-content">

                            <div class="menu-name">
                                <%= menu.getItemName() %>
                            </div>

                            <div class="menu-description">
                                <%= menu.getDescription() %>
                            </div>

                            <div class="bottom-row">

                                <div class="price">
                                    ₹<%= menu.getPrice() %>
                                </div>

                                <%
                                    if (!canOrder) {
                                %>

                                    <div class="not-available">
                                        <%= !restaurantActive
                                                ? "Restaurant Unavailable"
                                                : "Not Available" %>
                                    </div>

                                <%
                                    } else if (menuQuantity == 0) {
                                %>

                                    <!-- ADD TO CART -->
                                    <form
                                        action="<%= request.getContextPath() %>/cart"
                                        method="post">

                                        <input
                                            type="hidden"
                                            name="action"
                                            value="add">

                                        <input
                                            type="hidden"
                                            name="menuId"
                                            value="<%= menu.getMenuId() %>">

                                        <input
                                            type="hidden"
                                            name="ajax"
                                            value="true">

                                        <button
                                            type="button"
                                            class="add-btn"
                                            onclick="addItem(<%= menu.getMenuId() %>, this)">

                                            + Add

                                        </button>

                                    </form>

                                <%
                                    } else {
                                %>

                                    <!-- QUANTITY -->
                                    <div
                                        class="quantity-box"
                                        id="quantityBox_<%= menu.getMenuId() %>">

                                        <button
                                            type="button"
                                            class="quantity-btn"
                                            onclick="changeQuantity(<%= menu.getMenuId() %>, <%= menuQuantity - 1 %>)">

                                            −

                                        </button>

                                        <span
                                            class="quantity-number"
                                            id="quantity_<%= menu.getMenuId() %>">

                                            <%= menuQuantity %>

                                        </span>

                                        <button
                                            type="button"
                                            class="quantity-btn"
                                            onclick="changeQuantity(<%= menu.getMenuId() %>, <%= menuQuantity + 1 %>)">

                                            +

                                        </button>

                                    </div>

                                <%
                                    }
                                %>

                            </div>

                        </div>

                    </div>

                <%
                    }
                %>

            </div>

        <%
            }
        %>

    </div>

</main>


<!-- DIFFERENT RESTAURANT POPUP -->
<div
    id="restaurantModal"
    class="restaurant-modal">

    <div class="restaurant-modal-box">

        <div class="modal-icon">
            🛒
        </div>

        <h2>Items already in cart</h2>

        <p>
            Your cart contains items from another restaurant.
            Would you like to reset your cart and add items
            from this restaurant?
        </p>

        <div class="restaurant-modal-buttons">

            <button
                type="button"
                class="modal-no-btn"
                onclick="closeRestaurantModal()">

                No

            </button>

            <button
                type="button"
                class="modal-yes-btn"
                onclick="startFresh()">

                Yes, start afresh

            </button>

        </div>

    </div>

</div>


<script>

    var differentRestaurantMenuId = null;

    // ADD ITEM
    function addItem(menuId, button) {

        // Prevent adding if the restaurant is inactive.
        if (<%= !restaurantActive %>) {
            alert("This restaurant is currently unavailable.");
            return;
        }

        var xhr = new XMLHttpRequest();

        xhr.open(
            "POST",
            "<%= request.getContextPath() %>/cart",
            true
        );

        xhr.setRequestHeader(
            "Content-Type",
            "application/x-www-form-urlencoded"
        );

        xhr.onreadystatechange = function() {

            if (xhr.readyState === 4 && xhr.status === 200) {

                var response = xhr.responseText.trim();

                if (response.indexOf("DIFFERENT_RESTAURANT") === 0) {

                    var parts = response.split("|");

                    differentRestaurantMenuId = parts[1];

                    document.getElementById(
                        "restaurantModal"
                    ).style.display = "flex";

                    return;
                }

                var parts = response.split("|");
                var total = parts[1];

                document.getElementById("cartCount").innerText = total;

                window.location.reload();
            }
        };

        xhr.send(
            "action=add"
            + "&menuId=" + menuId
            + "&ajax=true"
        );
    }


    // CLOSE POPUP
    function closeRestaurantModal() {

        document.getElementById(
            "restaurantModal"
        ).style.display = "none";

        differentRestaurantMenuId = null;
    }


    // START FRESH
    function startFresh() {

        if (differentRestaurantMenuId === null) {
            return;
        }

        if (<%= !restaurantActive %>) {
            alert("This restaurant is currently unavailable.");
            closeRestaurantModal();
            return;
        }

        var xhr = new XMLHttpRequest();

        xhr.open(
            "POST",
            "<%= request.getContextPath() %>/cart",
            true
        );

        xhr.setRequestHeader(
            "Content-Type",
            "application/x-www-form-urlencoded"
        );

        xhr.onreadystatechange = function() {

            if (xhr.readyState === 4 && xhr.status === 200) {

                var response = xhr.responseText.trim();
                var parts = response.split("|");
                var total = parts[1];

                document.getElementById("cartCount").innerText = total;

                closeRestaurantModal();

                window.location.reload();
            }
        };

        xhr.send(
            "action=clearAndAdd"
            + "&menuId=" + differentRestaurantMenuId
            + "&ajax=true"
        );
    }


    // CHANGE QUANTITY
    function changeQuantity(menuId, quantity) {

        if (<%= !restaurantActive %>) {
            alert("This restaurant is currently unavailable.");
            return;
        }

        var xhr = new XMLHttpRequest();

        xhr.open(
            "POST",
            "<%= request.getContextPath() %>/cart",
            true
        );

        xhr.setRequestHeader(
            "Content-Type",
            "application/x-www-form-urlencoded"
        );

        xhr.onreadystatechange = function() {

            if (xhr.readyState === 4 && xhr.status === 200) {

                var parts = xhr.responseText.split("|");
                var total = parts[1];

                document.getElementById("cartCount").innerText = total;

                window.location.reload();
            }
        };

        xhr.send(
            "action=update"
            + "&menuId=" + menuId
            + "&quantity=" + quantity
            + "&ajax=true"
        );
    }


    // CLOSE POPUP WHEN CLICKING OUTSIDE
    window.onclick = function(event) {

        var modal = document.getElementById("restaurantModal");

        if (event.target === modal) {
            closeRestaurantModal();
        }
    };

</script>

</body>
</html>
