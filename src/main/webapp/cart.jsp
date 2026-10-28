<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="java.util.Collection" %>

<%
    response.setContentType("text/html; charset=UTF-8");

    Cart cart = (Cart) session.getAttribute("cart");

    if (cart == null) {
        cart = new Cart();
        session.setAttribute("cart", cart);
    }

    Integer lastRestaurantId =
            (Integer) session.getAttribute("lastRestaurantId");

    int restaurantId = 0;

    if (lastRestaurantId != null) {
        restaurantId = lastRestaurantId;
    } else if (cart.getRestaurantId() > 0) {
        restaurantId = cart.getRestaurantId();
    }
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Foodwala - Cart</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/common.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/cart.css">

</head>

<body>

<!-- =====================================================
     NAVBAR
===================================================== -->

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

    <a class="cart-link active-cart"
       href="<%= request.getContextPath() %>/cart">

        🛒 Cart

        <span class="cart-count">
            <%= cart.getTotalQuantity() %>
        </span>

    </a>

</nav>


<!-- =====================================================
     CART PAGE
===================================================== -->

<main class="cart-page">

    <div class="cart-container">

        <!-- PAGE HEADING -->

        <div class="cart-heading">

            <span class="cart-eyebrow">
                🛒 FOODWALA CART
            </span>

            <h1>
                Your Cart
            </h1>

            <p>
                Review your selected dishes before placing your order.
            </p>

        </div>


        <%
            if (restaurantId > 0) {
        %>

            <div class="return-area">

                <a
                    class="return-btn"
                    href="<%= request.getContextPath() %>/menu?restaurantId=<%= restaurantId %>">

                    ← Continue Ordering

                </a>

            </div>

        <%
            } else {
        %>

            <div class="return-area">

                <a
                    class="return-btn"
                    href="<%= request.getContextPath() %>/restaurent">

                    ← Browse Restaurants

                </a>

            </div>

        <%
            }
        %>


        <!-- =================================================
             EMPTY CART
        ================================================= -->

        <%
            if (cart.isEmpty()) {
        %>

            <section class="cart-box empty-cart">

                <div class="empty-cart-icon">
                    🛒
                </div>

                <h2>
                    Your Cart is Empty
                </h2>

                <p>
                    Looks like you haven't added anything to your cart yet.
                    <br>
                    Explore our restaurants and discover delicious food.
                </p>

                <a
                    href="<%= request.getContextPath() %>/restaurent"
                    class="explore-btn">

                    Explore Restaurants →

                </a>

            </section>

        <%
            } else {
        %>


        <!-- =================================================
             CART WITH ITEMS
        ================================================= -->

        <section class="cart-box">

            <div class="cart-box-header">

                <div>

                    <h2>
                        Selected Items
                    </h2>

                    <span class="cart-item-count">
                        <%= cart.getTotalQuantity() %> item(s)
                    </span>

                </div>

            </div>


            <div class="cart-items">

                <%
                    Collection<CartItem> items = cart.getItems();

                    for (CartItem item : items) {
                %>

                    <!-- ONE CART ITEM -->

                    <div class="cart-item">

                        <!-- IMAGE + NAME -->

                        <div class="item-left">

                            <div class="item-image-wrap">

                                <img
                                    class="item-image"
                                    src="<%= item.getMenu().getImagePath() %>"
                                    alt="<%= item.getMenu().getItemName() %>">

                            </div>

                            <div class="item-details">

                                <div class="item-name">
                                    <%= item.getMenu().getItemName() %>
                                </div>

                                <div class="item-price">
                                    ₹<%= item.getMenu().getPrice() %>
                                    <span>per item</span>
                                </div>

                            </div>

                        </div>


                        <!-- QUANTITY -->

                        <div class="quantity-area">

                            <div class="quantity-title">
                                Quantity
                            </div>

                            <div class="quantity-controls">

                                <!-- MINUS -->

                                <form
                                    class="quantity-form"
                                    action="<%= request.getContextPath() %>/cart"
                                    method="post">

                                    <input
                                        type="hidden"
                                        name="action"
                                        value="update">

                                    <input
                                        type="hidden"
                                        name="menuId"
                                        value="<%= item.getMenu().getMenuId() %>">

                                    <input
                                        type="hidden"
                                        name="quantity"
                                        value="<%= item.getQuantity() - 1 %>">

                                    <button
                                        type="submit"
                                        class="quantity-btn">

                                        −

                                    </button>

                                </form>


                                <!-- CURRENT QUANTITY -->

                                <span class="quantity-number">
                                    <%= item.getQuantity() %>
                                </span>


                                <!-- PLUS -->

                                <form
                                    class="quantity-form"
                                    action="<%= request.getContextPath() %>/cart"
                                    method="post">

                                    <input
                                        type="hidden"
                                        name="action"
                                        value="update">

                                    <input
                                        type="hidden"
                                        name="menuId"
                                        value="<%= item.getMenu().getMenuId() %>">

                                    <input
                                        type="hidden"
                                        name="quantity"
                                        value="<%= item.getQuantity() + 1 %>">

                                    <button
                                        type="submit"
                                        class="quantity-btn">

                                        +

                                    </button>

                                </form>

                            </div>


                            <!-- REMOVE ITEM -->

                            <form
                                action="<%= request.getContextPath() %>/cart"
                                method="post">

                                <input
                                    type="hidden"
                                    name="action"
                                    value="remove">

                                <input
                                    type="hidden"
                                    name="menuId"
                                    value="<%= item.getMenu().getMenuId() %>">

                                <button
                                    type="submit"
                                    class="remove-btn">

                                    Remove Item

                                </button>

                            </form>

                        </div>


                        <!-- ITEM TOTAL -->

                        <div class="item-total">

                            <span>
                                Item Total
                            </span>

                            <strong>
                                ₹<%= item.getTotalPrice() %>
                            </strong>

                        </div>

                    </div>

                <%
                    }
                %>

            </div>


            <!-- =================================================
                 CART SUMMARY
            ================================================= -->

            <div class="cart-bottom">

                <!-- CLEAR CART -->

                <form
                    action="<%= request.getContextPath() %>/cart"
                    method="post">

                    <input
                        type="hidden"
                        name="action"
                        value="clear">

                    <button
                        type="submit"
                        class="clear-btn">

                        Clear Cart

                    </button>

                </form>


                <div class="cart-summary">

                    <div class="total-label">
                        Total Amount
                    </div>

                    <div class="total">
                        ₹<%= cart.getTotalAmount() %>
                    </div>

                </div>


                <!-- CHECKOUT -->

                <form
                    action="<%= request.getContextPath() %>/checkout"
                    method="get">

                    <button
                        class="checkout-btn"
                        type="submit">

                        Proceed to Checkout →

                    </button>

                </form>

            </div>

        </section>

        <%
            }
        %>

    </div>

</main>

</body>
</html>
