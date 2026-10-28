<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.OrderItem" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Restaurent" %>
<%@ page import="com.tap.daoimpl.OrderItemDAOImpl" %>
<%@ page import="com.tap.daoimpl.MenuDAOImpl" %>
<%@ page import="com.tap.daoimpl.RestaurentDAOImpl" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | Foodwala</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/common.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/orders.css?v=3">
</head>
<body>
<nav class="navbar">
    <div class="nav-container">
        <a href="<%= request.getContextPath() %>/restaurent" class="logo">Foodwala</a>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/restaurent">Restaurants</a>
            <a href="<%= request.getContextPath() %>/orders" class="active">Orders</a>
            <a href="<%= request.getContextPath() %>/cart" class="nav-cart">🛒 Cart</a>
        </div>
    </div>
</nav>

<main class="orders-page">
    <header class="orders-header">
        <div>
            <span class="eyebrow">FOODWALA · YOUR FOOD JOURNEY</span>
            <h1>My Orders</h1>
            <p>Your favourite meals, all in one place.</p>
        </div>
        <a href="<%= request.getContextPath() %>/restaurent" class="browse-btn">🍽 Browse Restaurants</a>
    </header>

    <div class="orders-container">
    <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        if (orders != null && !orders.isEmpty()) {
            OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
            MenuDAOImpl menuDAO = new MenuDAOImpl();
            RestaurentDAOImpl restaurentDAO = new RestaurentDAOImpl();
            int userOrderNumber = 0;

            for (Order order : orders) {
                userOrderNumber++;
                List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrder(order.getOrderId());
                Restaurent restaurant = restaurentDAO.getRestaurent(order.getRestaurantId());
    %>
        <article class="order-card">
            <div class="order-card-header">
                <div class="order-heading">
                    <div class="order-icon" aria-hidden="true">🧾</div>
                    <div>
                        <span class="small-label">YOUR ORDER</span>
                        <h2>Order #<%= userOrderNumber %></h2>
                        <p class="order-date">📅 <%= order.getOrderDate() %></p>
                    </div>
                </div>
                <span class="status"><%= order.getStatus() == null ? "Status unavailable" : order.getStatus() %></span>
            </div>

            <% if (restaurant != null) { %>
            <div class="restaurant-row">
                <span class="restaurant-icon" aria-hidden="true">🏪</span>
                <div>
                    <span class="muted-label">Ordered from</span>
                    <strong><%= restaurant.getName() %></strong>
                </div>
            </div>
            <% } %>

            <section class="ordered-items">
                <div class="section-heading">
                    <h3>Items in your order</h3>
                    <span><%= orderItems == null ? 0 : orderItems.size() %>
                    <%= orderItems != null && orderItems.size() == 1 ? "item" : "items" %></span>
                </div>

                <div class="items-list">
                <%
                    if (orderItems != null && !orderItems.isEmpty()) {
                        for (OrderItem orderItem : orderItems) {
                            Menu menu = menuDAO.getMenu(orderItem.getMenuId());
                            double itemTotal = orderItem.getPrice() * orderItem.getQuantity();
                %>
                    <div class="order-item">
                        <div class="item-image">
                        <% if (menu != null && menu.getImagePath() != null
                                && !menu.getImagePath().trim().isEmpty()) { %>
                            <img
                                src="<%= menu.getImagePath() %>"
                                alt="<%= menu.getItemName() %>"
                                loading="lazy"
                                style="display:block !important; width:88px !important; min-width:88px !important; max-width:88px !important; height:76px !important; min-height:76px !important; max-height:76px !important; object-fit:cover !important; margin:0 !important;">
                        <% } else { %>
                            <div class="image-unavailable">Image unavailable</div>
                        <% } %>
                        </div>

                        <div class="item-description">
                            <h4 class="item-name"><%= menu != null ? menu.getItemName() : "Item unavailable" %></h4>
                            <p class="item-quantity">
                                Quantity: <strong><%= orderItem.getQuantity() %></strong>
                                <span class="multiply-sign">×</span>
                                ₹<%= String.format("%.2f", orderItem.getPrice()) %> each
                            </p>
                        </div>

                        <div class="item-price">
                            <span>Item total</span>
                            <strong>₹<%= String.format("%.2f", itemTotal) %></strong>
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                    <p class="no-items">No items were found for this order.</p>
                <% } %>
                </div>
            </section>

            <footer class="order-card-footer">
                <div class="order-meta">
                    <div class="meta-block">
                        <span class="muted-label">Payment method</span>
                        <strong><%= order.getPaymentMethod() == null ? "Not available" : order.getPaymentMethod() %></strong>
                    </div>
                    <% if (order.getAddress() != null && !order.getAddress().trim().isEmpty()) { %>
                    <div class="meta-block address-block">
                        <span class="muted-label">Delivery address</span>
                        <strong><%= order.getAddress() %></strong>
                    </div>
                    <% } %>
                </div>
                <div class="order-total">
                    <span>Order total</span>
                    <strong>₹<%= String.format("%.2f", order.getTotalAmount()) %></strong>
                </div>
            </footer>
        </article>
    <%
            }
        } else {
    %>
        <section class="empty-orders">
            <div class="empty-icon" aria-hidden="true">🛍️</div>
            <span class="eyebrow">FOODWALA</span>
            <h2>No orders yet</h2>
            <p>Your next favourite meal is waiting. Explore restaurants and place your first order.</p>
            <a href="<%= request.getContextPath() %>/restaurent" class="browse-btn">Explore Restaurants →</a>
        </section>
    <% } %>
    </div>
</main>
</body>
</html>
