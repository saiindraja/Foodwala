<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || user.getRole() == null ||
        !"admin".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Foodwala | Admin Dashboard</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/admin.css">
</head>

<body>

    <nav class="admin-navbar">
        <a class="admin-logo"
           href="<%= request.getContextPath() %>/admin/dashboard.jsp">
            Foodwala Admin
        </a>

        <a class="logout-btn"
           href="<%= request.getContextPath() %>/logout">
            Logout
        </a>
    </nav>

    <main class="admin-container">

        <section class="admin-welcome">
            <h1>Welcome, <%= user.getUsername() %>!</h1>
            <p>Manage your restaurants, menus, orders and customers
               from one place.</p>
        </section>

        <section class="admin-cards">

            <div class="admin-card">
                <h3>Restaurants</h3>
                <p>View and manage restaurant information.</p>
                <a class="admin-btn"
                   href="<%= request.getContextPath() %>/admin/restaurants">
                    Manage Restaurants
                </a>
            </div>

            <div class="admin-card">
                <h3>Menu Items</h3>
                <p>Manage food names, prices, descriptions and images.</p>
                <a class="admin-btn"
                   href="<%= request.getContextPath() %>/admin/menus">
                    Manage Menu
                </a>
            </div>

            <div class="admin-card">
                <h3>Orders</h3>
                <p>View customer orders and manage order status.</p>
                <a class="admin-btn"
                   href="<%= request.getContextPath() %>/admin/orders">
                    Manage Orders
                </a>
            </div>

            <div class="admin-card">
                <h3>Customers</h3>
                <p>View registered customers.</p>
                <a class="admin-btn"
                   href="<%= request.getContextPath() %>/admin/customers">
                    View Customers
                </a>
            </div>

        </section>

    </main>

    <footer class="admin-footer">
        Foodwala Admin Panel
    </footer>

</body>
</html>
