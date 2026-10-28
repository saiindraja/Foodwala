
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.User" %>

<%
    Integer displayOrderNumber =
            (Integer) session.getAttribute("lastOrderDisplayNumber");

    Cart cart = (Cart) session.getAttribute("cart");

    int cartCount = 0;

    if (cart != null) {
        cartCount = cart.getTotalQuantity();
    }

    User loggedInUser =
            (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Foodwala | Order Confirmed</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/orderSuccess.css">
</head>

<body>

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

            <% if (loggedInUser == null) { %>

                <a href="<%= request.getContextPath() %>/login.jsp">
                    Login
                </a>

            <% } else { %>

                <a href="<%= request.getContextPath() %>/profile"
                   class="user-link">
                    👤 <%= loggedInUser.getUsername() %>
                </a>

                <a href="<%= request.getContextPath() %>/logout"
                   class="logout-link">
                    Logout
                </a>

            <% } %>
        </div>

        <a href="<%= request.getContextPath() %>/cart"
           class="cart-link">
            🛒 Cart
            <span class="cart-count"><%= cartCount %></span>
        </a>
    </nav>

    <section class="success-section">
        <div class="success-glow"></div>

        <div class="success-box">

            <div class="success-icon">✓</div>

            <div class="success-badge">
                ✦ ORDER CONFIRMED
            </div>

            <h1>
                Order Placed <span>Successfully!</span>
            </h1>

            <div class="message">
                Thank you for ordering with Foodwala.
                Your delicious food is being prepared
                and will be on its way soon.
            </div>

            <% if (displayOrderNumber != null) { %>

                <div class="order-card">
                    <span class="order-card-label">
                        YOUR ORDER NUMBER
                    </span>

                    <span class="order-card-id">
                        #<%= displayOrderNumber %>
                    </span>
                </div>

            <% } %>

            <div class="button-row">

                <a href="<%= request.getContextPath() %>/restaurent"
                   class="button primary-button">
                    Continue Shopping →
                </a>

                <a href="<%= request.getContextPath() %>/cart"
                   class="button secondary-button">
                    View Cart
                </a>

            </div>

        </div>
    </section>

</body>
</html>
