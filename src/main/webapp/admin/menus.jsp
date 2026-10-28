
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || user.getRole() == null
            || !"admin".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Menu> menus = (List<Menu>) request.getAttribute("menus");

    if (menus == null) {
        response.sendRedirect(request.getContextPath() + "/admin/menus");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Foodwala | Manage Menu</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/admin.css">

    <style>
        .table-wrapper {
            overflow-x: auto;
            margin-top: 20px;
        }

        .menu-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        .menu-table th,
        .menu-table td {
            padding: 12px;
            border-bottom: 1px solid #eee;
            text-align: left;
            vertical-align: middle;
        }

        .menu-table th {
            background: #ff512f;
            color: white;
        }

        .menu-table input[type="text"],
        .menu-table input[type="number"],
        .menu-table textarea,
        .menu-table select,
        .add-menu-form input[type="text"],
        .add-menu-form input[type="number"],
        .add-menu-form textarea,
        .add-menu-form select {
            width: 150px;
            max-width: 100%;
            padding: 9px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
            font: inherit;
        }

        .menu-table textarea,
        .add-menu-form textarea {
            min-height: 65px;
            resize: vertical;
        }

        .save-btn,
        .add-btn,
        .delete-btn,
        .cancel-btn {
            border: none;
            cursor: pointer;
            color: white;
            padding: 10px 15px;
            border-radius: 20px;
            font-weight: bold;
            margin: 3px;
        }

        .save-btn,
        .add-btn {
            background: linear-gradient(135deg, #ff512f, #f09819);
        }

        .delete-btn {
            background: #dc3545;
        }

        .cancel-btn {
            background: #6c757d;
        }

        .save-btn:hover,
        .add-btn:hover,
        .delete-btn:hover,
        .cancel-btn:hover {
            opacity: 0.85;
        }

        .message {
            padding: 12px;
            margin: 15px 0;
            background: #e8f8ed;
            color: #176b35;
            border-radius: 6px;
        }

        .error-message {
            padding: 12px;
            margin: 15px 0;
            background: #fff0ec;
            color: #b42318;
            border-radius: 6px;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #ff4d2d;
            text-decoration: none;
            font-weight: bold;
        }

        .menu-image {
            width: 65px;
            height: 55px;
            object-fit: cover;
            border-radius: 8px;
        }

        .add-menu-form {
            display: none;
            margin: 20px 0;
            padding: 22px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.08);
        }

        .add-menu-form h2 {
            margin-top: 0;
            color: #ff512f;
        }

        .add-menu-form .form-group {
            margin-bottom: 15px;
        }

        .add-menu-form label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
        }

        .add-menu-form input,
        .add-menu-form textarea,
        .add-menu-form select {
            width: 100%;
            max-width: 500px;
        }

        .action-buttons {
            min-width: 120px;
        }

        @media (max-width: 768px) {
            .menu-table th,
            .menu-table td {
                padding: 8px;
            }

            .add-menu-form {
                padding: 15px;
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

<main class="admin-container">

    <a class="back-link"
       href="<%= request.getContextPath() %>/admin/dashboard.jsp">
        &larr; Back to Dashboard
    </a>

    <section class="admin-welcome">
        <h1>Manage Menu Items</h1>
        <p>Add, update and delete restaurant menu items.</p>
    </section>

    <% if ("success".equals(request.getParameter("added"))) { %>
        <div class="message">
            Menu item added successfully!
        </div>
    <% } %>

    <% if ("success".equals(request.getParameter("updated"))) { %>
        <div class="message">
            Menu item updated successfully!
        </div>
    <% } %>

    <% if ("success".equals(request.getParameter("deleted"))) { %>
        <div class="message">
            Menu item deleted successfully!
        </div>
    <% } %>

    <% if ("price".equals(request.getParameter("error"))) { %>
        <div class="error-message">
            Please enter a valid price greater than or equal to zero.
        </div>
    <% } %>

    <% if ("invalid".equals(request.getParameter("error"))) { %>
        <div class="error-message">
            Please check the menu item details and try again.
        </div>
    <% } %>

    <% if ("restaurant".equals(request.getParameter("error"))) { %>
        <div class="error-message">
            The restaurant ID is invalid. Please enter an existing restaurant ID.
        </div>
    <% } %>

    <% if ("delete".equals(request.getParameter("error"))) { %>
        <div class="error-message">
            The menu item could not be deleted. It may be linked to an existing order.
        </div>
    <% } %>

    <p>
        <strong>Total Menu Items:</strong> <%= menus.size() %>
    </p>

    <!-- Add Menu button -->
    <button type="button" class="add-btn" onclick="showAddMenuForm()">
        + Add Menu
    </button>

    <!-- The Add Menu form is created only when the button is clicked -->
    <div id="addMenuContainer"></div>

    <div class="table-wrapper">
        <table class="menu-table">

            <thead>
                <tr>
                    <th>Menu ID</th>
                    <th>Restaurant ID</th>
                    <th>Image</th>
                    <th>Item Name</th>
                    <th>Description</th>
                    <th>Price (₹)</th>
                    <th>Availability</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>

            <% if (menus.isEmpty()) { %>

                <tr>
                    <td colspan="8">No menu items found.</td>
                </tr>

            <% } else {
                for (Menu m : menus) {
                    String formId = "menuForm" + m.getMenuId();
            %>

                <tr>
                    <td><%= m.getMenuId() %></td>

                    <td><%= m.getRestaurantId() %></td>

                    <td>
                        <% if (m.getImagePath() != null
                                && !m.getImagePath().trim().isEmpty()) { %>

                            <img class="menu-image"
                                 src="<%= m.getImagePath() %>"
                                 alt="Food image"
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='inline';">

                            <span style="display:none;">Image unavailable</span>

                        <% } else { %>
                            No image
                        <% } %>
                    </td>

                    <!-- Update form -->
                    <td>
                        <form id="<%= formId %>"
                              method="post"
                              action="<%= request.getContextPath() %>/admin/menus">

                            <input type="hidden"
                                   name="action"
                                   value="update">

                            <input type="hidden"
                                   name="menuId"
                                   value="<%= m.getMenuId() %>">

                            <input type="text"
                                   name="itemName"
                                   value="<%= m.getItemName() == null
                                       ? "" : m.getItemName() %>"
                                   maxlength="150"
                                   required>
                        </form>
                    </td>

                    <td>
                        <textarea name="description"
                                  form="<%= formId %>"
                                  maxlength="1000"
                                  required><%= m.getDescription() == null
                                      ? "" : m.getDescription() %></textarea>
                    </td>

                    <td>
                        <input type="number"
                               name="price"
                               form="<%= formId %>"
                               value="<%= m.getPrice() %>"
                               min="0"
                               step="0.01"
                               required>
                    </td>

                    <td>
                        <select name="isAvailable" form="<%= formId %>">
                            <option value="true"
                                <%= m.isAvailable() ? "selected" : "" %>>
                                Available
                            </option>

                            <option value="false"
                                <%= !m.isAvailable() ? "selected" : "" %>>
                                Unavailable
                            </option>
                        </select>
                    </td>

                    <td class="action-buttons">

                        <button type="submit"
                                form="<%= formId %>"
                                class="save-btn">
                            Save
                        </button>

                        <!-- Delete form -->
                        <form method="post"
                              action="<%= request.getContextPath() %>/admin/menus"
                              onsubmit="return confirm('Are you sure you want to delete this menu item?');">

                            <input type="hidden"
                                   name="action"
                                   value="delete">

                            <input type="hidden"
                                   name="menuId"
                                   value="<%= m.getMenuId() %>">

                            <button type="submit" class="delete-btn">
                                Delete
                            </button>
                        </form>

                    </td>
                </tr>

            <%  }
               } %>

            </tbody>
        </table>
    </div>

</main>

<footer class="admin-footer">
    Foodwala Admin Panel
</footer>

<script>
    function showAddMenuForm() {

        const container = document.getElementById("addMenuContainer");

        // If the form already exists, do not create it again.
        if (document.getElementById("addMenuForm")) {
            container.style.display = "block";
            document.getElementById("addMenuForm").scrollIntoView({
                behavior: "smooth",
                block: "start"
            });
            return;
        }

        container.innerHTML = `
            <form id="addMenuForm"
                  class="add-menu-form"
                  method="post"
                  action="<%= request.getContextPath() %>/admin/menus">

                <h2>Add New Menu Item</h2>

                <input type="hidden" name="action" value="add">

                <div class="form-group">
                    <label for="restaurantId">Restaurant ID</label>
                    <input type="number"
                           id="restaurantId"
                           name="restaurantId"
                           min="1"
                           required
                           placeholder="Enter existing restaurant ID">
                </div>

                <div class="form-group">
                    <label for="itemName">Food Item Name</label>
                    <input type="text"
                           id="itemName"
                           name="itemName"
                           maxlength="150"
                           required
                           placeholder="Example: Palak Paneer">
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description"
                              name="description"
                              maxlength="1000"
                              required
                              placeholder="Enter food item description"></textarea>
                </div>

                <div class="form-group">
                    <label for="price">Price (₹)</label>
                    <input type="number"
                           id="price"
                           name="price"
                           min="0"
                           step="0.01"
                           required
                           placeholder="Enter price">
                </div>

                <div class="form-group">
                    <label for="imagePath">Food Image URL</label>
                    <input type="text"
                           id="imagePath"
                           name="imagePath"
                           maxlength="1000"
                           placeholder="Enter a valid image URL">
                </div>

                <div class="form-group">
                    <label for="isAvailable">Availability</label>
                    <select id="isAvailable" name="isAvailable" required>
                        <option value="true" selected>Available</option>
                        <option value="false">Unavailable</option>
                    </select>
                </div>

                <button type="submit" class="save-btn">
                    Add Menu Item
                </button>

                <button type="button"
                        class="cancel-btn"
                        onclick="cancelAddMenuForm()">
                    Cancel
                </button>

            </form>
        `;

        const form = document.getElementById("addMenuForm");
        form.style.display = "block";

        form.scrollIntoView({
            behavior: "smooth",
            block: "start"
        });
    }

    function cancelAddMenuForm() {
        document.getElementById("addMenuContainer").innerHTML = "";
    }
</script>

</body>
</html>
