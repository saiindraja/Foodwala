
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.Order"%>
<%@ page import="com.tap.model.User"%>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || user.getRole() == null ||
        !"admin".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String updated = request.getParameter("updated");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Foodwala | Manage Orders</title>

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/admin.css">

<style>
/* Page-specific styles only; keep the existing admin.css */
.orders-container {
    width: min(1400px, 92%);
    margin: 0 auto;
    padding: 40px 0 60px;
}

.orders-heading {
    margin-bottom: 25px;
}

.orders-heading h1 {
    color: #24150e;
    font-size: 32px;
    margin-bottom: 8px;
}

.orders-heading p {
    color: #765e51;
    line-height: 1.6;
}

.orders-actions {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
    margin-bottom: 22px;
}

.orders-summary {
    display: flex;
    align-items: center;
    gap: 12px;
    background: #fff0e5;
    color: #d83d10;
    padding: 13px 18px;
    border-radius: 13px;
    font-weight: 800;
}

.orders-summary strong {
    font-size: 22px;
}

.orders-table {
    width: 100%;
    min-width: 1150px;
    border-collapse: collapse;
}

.orders-table th {
    background: #fff0e5;
    color: #5c3b2b;
    padding: 15px;
    text-align: left;
    font-size: 12px;
    font-weight: 900;
    white-space: nowrap;
}

.orders-table td {
    padding: 15px;
    border-top: 1px solid #f1e5dc;
    color: #5f4b40;
    font-size: 13px;
    vertical-align: middle;
}

.orders-table tbody tr:hover td {
    background: #fffaf6;
}

.orders-table .order-number {
    color: #d83d10;
    font-weight: 900;
}

.order-status {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 30px;
    background: #fff0e5;
    color: #e44816;
    font-size: 11px;
    font-weight: 800;
    white-space: nowrap;
}

.status-delivered {
    background: #edf9ef;
    color: #28733b;
}

.status-cancelled {
    background: #fff0ed;
    color: #b93622;
}

.status-form {
    display: flex;
    align-items: center;
    gap: 8px;
}

.status-form select {
    min-width: 145px;
    padding: 10px;
    border: 1px solid #ead9cd;
    border-radius: 10px;
    background: #fff;
    color: #24150e;
}

.status-form button {
    border: none;
    border-radius: 11px;
    padding: 11px 14px;
    background: linear-gradient(135deg, #ff8c00, #ee4218);
    color: white;
    font-size: 12px;
    font-weight: 800;
    white-space: nowrap;
}

.orders-table-wrapper {
    width: 100%;
    overflow-x: auto;
    background: #fff;
    border: 1px solid rgba(110, 57, 25, 0.10);
    border-radius: 16px;
    box-shadow: 0 5px 25px rgba(80, 37, 12, 0.06);
}

.orders-empty {
    padding: 50px 20px;
    text-align: center;
}

.orders-empty .empty-icon {
    font-size: 40px;
    margin-bottom: 12px;
}

.orders-empty h3 {
    color: #24150e;
    margin-bottom: 8px;
}

.orders-empty p {
    color: #765e51;
    font-size: 13px;
}

.orders-footer {
    margin-top: 40px;
    padding: 25px 15px;
    background: #241b17;
    color: #c8bbb3;
    text-align: center;
    font-size: 12px;
}

@media (max-width: 650px) {
    .orders-container {
        width: 94%;
        padding-top: 28px;
    }

    .orders-heading h1 {
        font-size: 26px;
    }

    .orders-actions {
        align-items: stretch;
        flex-direction: column;
    }
}
</style>
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

<main class="orders-container">

    <section class="orders-heading">
        <h1>Manage Orders</h1>
        <p>
            View customer orders and manage their order status
            from one place.
        </p>
    </section>

    <div class="orders-actions">
        <div class="orders-summary">
            <span>Total Orders</span>
            <strong><%= orders == null ? 0 : orders.size() %></strong>
        </div>

        <a class="admin-btn"
           href="<%= request.getContextPath() %>/admin/dashboard.jsp">
            &larr; Back to Dashboard
        </a>
    </div>

    <% if ("success".equals(updated)) { %>
        <div class="fw-message fw-success" style="margin-bottom:20px;">
            Order status update submitted. Check the displayed status
            to confirm the change was saved.
        </div>
    <% } %>

    <div class="orders-table-wrapper">
        <table class="orders-table">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer ID</th>
                    <th>Restaurant ID</th>
                    <th>Order Date</th>
                    <th>Total</th>
                    <th>Payment</th>
                    <th>Delivery Address</th>
                    <th>Status</th>
                    <th>Update Status</th>
                </tr>
            </thead>

            <tbody>
            <% if (orders != null && !orders.isEmpty()) {
                   for (Order order : orders) {
                       String currentStatus = order.getStatus();
            %>
                <tr>
                    <td class="order-number">
                        #<%= order.getOrderId() %>
                    </td>

                    <td><%= order.getUserId() %></td>
                    <td><%= order.getRestaurantId() %></td>

                    <td>
                        <%= order.getOrderDate() == null
                            ? "N/A" : order.getOrderDate() %>
                    </td>

                    <td>
                        ₹<%= String.format("%.2f",
                            order.getTotalAmount()) %>
                    </td>

                    <td>
                        <%= order.getPaymentMethod() == null
                            ? "N/A" : order.getPaymentMethod() %>
                    </td>

                    <td>
                        <%= order.getAddress() == null
                            ? "N/A" : order.getAddress() %>
                    </td>

                    <td>
                        <span class="order-status <%= 
                            "Delivered".equals(currentStatus)
                                ? "status-delivered"
                                : "Cancelled".equals(currentStatus)
                                    ? "status-cancelled" : "" %>">
                            <%= currentStatus == null
                                ? "N/A" : currentStatus %>
                        </span>
                    </td>

                    <td>
                        <form class="status-form"
                              action="<%= request.getContextPath() %>/admin/orders"
                              method="post">

                            <input type="hidden" name="orderId"
                                   value="<%= order.getOrderId() %>">

                            <select name="status" required>
                                <option value="Pending"
                                    <%= "Pending".equals(currentStatus)
                                        ? "selected" : "" %>>
                                    Pending
                                </option>

                                <option value="Confirmed"
                                    <%= "Confirmed".equals(currentStatus)
                                        ? "selected" : "" %>>
                                    Confirmed
                                </option>

                                <option value="Preparing"
                                    <%= "Preparing".equals(currentStatus)
                                        ? "selected" : "" %>>
                                    Preparing
                                </option>

                                <option value="Out for Delivery"
                                    <%= "Out for Delivery".equals(currentStatus)
                                        ? "selected" : "" %>>
                                    Out for Delivery
                                </option>

                                <option value="Delivered"
                                    <%= "Delivered".equals(currentStatus)
                                        ? "selected" : "" %>>
                                    Delivered
                                </option>

                                <option value="Cancelled"
                                    <%= "Cancelled".equals(currentStatus)
                                        ? "selected" : "" %>>
                                    Cancelled
                                </option>
                            </select>

                            <button type="submit">Update</button>
                        </form>
                    </td>
                </tr>
            <%     }
               } else { %>
                <tr>
                    <td colspan="9">
                        <div class="orders-empty">
                            <div class="empty-icon">🍽️</div>
                            <h3>No Orders Yet</h3>
                            <p>
                                Customer orders will appear here
                                when they are saved in the database.
                            </p>
                        </div>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>

</main>

<footer class="orders-footer">
    Foodwala Admin Panel
</footer>

</body>
</html>
