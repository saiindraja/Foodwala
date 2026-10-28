<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurent" %>
<%@ page import="com.tap.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() == null
            || !"admin".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Restaurent> restaurents =
            (List<Restaurent>) request.getAttribute("restaurents");
    if (restaurents == null) {
        response.sendRedirect(request.getContextPath() + "/admin/restaurants");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Foodwala | Manage Restaurants</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <style>
        .restaurant-section {
            background: #fff; padding: 25px; margin: 25px 0;
            border: 1px solid #ffe2d6; border-radius: 16px;
            box-shadow: 0 5px 18px rgba(255, 77, 45, .08);
        }
        .restaurant-section h2 { color: #ff4d2d; margin-bottom: 10px; font-size: 23px; }
        .restaurant-section p { color: #666; margin-bottom: 20px; line-height: 1.6; }
        .restaurant-form-grid {
            display: grid; grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 15px; margin-bottom: 20px;
        }
        .restaurant-form-grid input {
            width: 100%; min-width: 0; box-sizing: border-box; padding: 12px;
            border: 1px solid #ffd2c2; border-radius: 8px; font-size: 14px;
            background: #fff; color: #333;
        }
        .restaurant-form-grid input:focus { outline: 1px solid #ff4d2d; border-color: #ff4d2d; }
        .table-wrapper { overflow-x: auto; margin-top: 20px; background: #fff; border: 1px solid #ffe2d6; border-radius: 12px; }
        .restaurant-table { width: 100%; min-width: 900px; border-collapse: collapse; }
        .restaurant-table th, .restaurant-table td {
            padding: 14px; border-bottom: 1px solid #ffe8df;
            text-align: left; vertical-align: middle;
        }
        .restaurant-table th { background: #fff0e9; color: #ff4d2d; white-space: nowrap; }
        .restaurant-table tbody tr:hover { background: #fffaf7; }
        .restaurant-table input, .restaurant-table select {
            width: 145px; max-width: 100%; box-sizing: border-box; padding: 9px;
            border: 1px solid #ffd2c2; border-radius: 6px; background: #fff;
        }
        .save-btn, .add-btn {
            border: none; cursor: pointer;
            background: linear-gradient(135deg, #ff512f, #f09819);
            color: #fff; padding: 10px 16px; border-radius: 20px;
            font-weight: bold; white-space: nowrap;
        }
        .save-btn:hover, .add-btn:hover { opacity: .88; }
        .delete-btn {
            border: none; cursor: pointer; background: #c62828; color: #fff;
            padding: 10px 16px; border-radius: 20px; font-weight: bold;
        }
        .delete-btn:hover { background: #a51d1d; }
        .cancel-btn {
            border: 1px solid #ff4d2d; cursor: pointer; background: #fff;
            color: #ff4d2d; padding: 10px 16px; border-radius: 20px;
            font-weight: bold; margin-left: 8px;
        }
        .message { padding: 13px; margin: 15px 0; background: #e8f8ed; color: #176b35; border-radius: 8px; }
        .error-message { padding: 13px; margin: 15px 0; background: #fff0ec; color: #b42318; border-radius: 8px; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #ff4d2d; text-decoration: none; font-weight: bold; }
        .restaurant-count { margin-top: 20px; color: #444; }
        .empty-row { text-align: center !important; padding: 30px !important; color: #777; }
        @media (max-width: 650px) {
            .restaurant-section { padding: 18px; }
            .restaurant-form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<nav class="admin-navbar">
    <a class="admin-logo" href="<%= request.getContextPath() %>/admin/dashboard.jsp">Foodwala Admin</a>
    <a class="logout-btn" href="<%= request.getContextPath() %>/logout">Logout</a>
</nav>

<main class="admin-container">
    <a class="back-link" href="<%= request.getContextPath() %>/admin/dashboard.jsp">&larr; Back to Dashboard</a>

    <section class="admin-welcome">
        <h1>Manage Restaurants</h1>
        <p>Add restaurants, update delivery times and availability, or delete restaurants.</p>
    </section>

    <% if ("success".equals(request.getParameter("added"))) { %>
        <div class="message">Restaurant added successfully.</div>
    <% } %>
    <% if ("success".equals(request.getParameter("updated"))) { %>
        <div class="message">Restaurant details updated successfully.</div>
    <% } %>
    <% if ("success".equals(request.getParameter("deleted"))) { %>
        <div class="message">Restaurant deleted successfully.</div>
    <% } %>
    <% if ("missingFields".equals(request.getParameter("error"))) { %>
        <div class="error-message">Please fill in all required fields.</div>
    <% } %>
    <% if ("invalidFields".equals(request.getParameter("error"))) { %>
        <div class="error-message">Please enter valid restaurant details and rating.</div>
    <% } %>
    <% if ("deliveryTime".equals(request.getParameter("error"))) { %>
        <div class="error-message">Please enter a valid delivery time.</div>
    <% } %>
    <% if ("deleteFailed".equals(request.getParameter("error"))) { %>
        <div class="error-message">
            This restaurant could not be deleted. Check whether related menu items or orders exist.
        </div>
    <% } %>

    <!-- The Add Restaurant form is created only when the button is clicked. -->
    <section class="restaurant-section">
        <button type="button" class="add-btn" onclick="showAddForm()">+ Add Restaurant</button>
        <div id="addRestaurantForm"></div>
    </section>

    <section>
        <h2 style="color: #ff4d2d;">Existing Restaurants</h2>
        <p class="restaurant-count"><strong>Total Restaurants:</strong> <%= restaurents.size() %></p>

        <div class="table-wrapper">
            <table class="restaurant-table">
                <thead>
                <tr>
                    <th>ID</th><th>Restaurant</th><th>Cuisine</th>
                    <th>Delivery Time</th><th>Status</th><th>Save Changes</th><th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% if (restaurents.isEmpty()) { %>
                    <tr><td colspan="7" class="empty-row">No restaurants found.</td></tr>
                <% } else {
                    for (Restaurent r : restaurents) {
                        String formId = "restaurantForm" + r.getRestaurantId();
                %>
                    <tr>
                        <td><%= r.getRestaurantId() %></td>
                        <td><%= r.getName() == null ? "" : r.getName() %></td>
                        <td><%= r.getCuisineType() == null ? "" : r.getCuisineType() %></td>
                        <td>
                            <form id="<%= formId %>" method="post" action="<%= request.getContextPath() %>/admin/restaurants">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="restaurantId" value="<%= r.getRestaurantId() %>">
                                <input type="text" name="deliveryTime"
                                       value="<%= r.getDeliveryTime() == null ? "" : r.getDeliveryTime() %>"
                                       maxlength="50" placeholder="e.g. 30-40 mins" required>
                            </form>
                        </td>
                        <td>
                            <select name="isActive" form="<%= formId %>">
                                <option value="true" <%= r.isActive() ? "selected" : "" %>>Active</option>
                                <option value="false" <%= !r.isActive() ? "selected" : "" %>>Inactive</option>
                            </select>
                        </td>
                        <td><button type="submit" form="<%= formId %>" class="save-btn">Save</button></td>
                        <td>
                            <form method="post" action="<%= request.getContextPath() %>/admin/restaurants"
                                  onsubmit="return confirm('Are you sure you want to delete this restaurant?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="restaurantId" value="<%= r.getRestaurantId() %>">
                                <button type="submit" class="delete-btn">Delete</button>
                            </form>
                        </td>
                    </tr>
                <%  }
                   } %>
                </tbody>
            </table>
        </div>
    </section>
</main>

<footer class="admin-footer">Foodwala Admin Panel</footer>

<script>
    const restaurantActionUrl = '<%= request.getContextPath() %>/admin/restaurants';

    function showAddForm() {
        const container = document.getElementById("addRestaurantForm");

        // Avoid creating another copy if the form is already open.
        if (container.innerHTML !== "") {
            return;
        }

        container.innerHTML = `
            <div style="margin-top: 22px;">
                <h2>Add New Restaurant</h2>
                <p>Enter the details of the restaurant you want to add.</p>
                <form method="post" action="${restaurantActionUrl}">
                    <input type="hidden" name="action" value="add">
                    <div class="restaurant-form-grid">
                        <input type="text" name="name" placeholder="Restaurant name" maxlength="150" required>
                        <input type="text" name="cuisineType" placeholder="Cuisine type" maxlength="100" required>
                        <input type="text" name="deliveryTime" placeholder="Delivery time (e.g. 30-40 mins)" maxlength="50" required>
                        <input type="text" name="address" placeholder="Restaurant address" maxlength="255" required>
                        <input type="number" name="adminUserId" placeholder="Admin user ID" min="1" required>
                        <input type="number" name="rating" placeholder="Rating (0-5)" min="0" max="5" step="0.1" value="0" required>
                        <input type="url" name="imagePath" placeholder="Restaurant image URL (optional)">
                    </div>
                    <button type="submit" class="save-btn">Save Restaurant</button>
                    <button type="button" class="cancel-btn" onclick="closeAddForm()">Cancel</button>
                </form>
            </div>
        `;
    }

    function closeAddForm() {
        document.getElementById("addRestaurantForm").innerHTML = "";
    }
</script>
</body>
</html>
