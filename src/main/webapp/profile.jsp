<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Cart" %>

<%
    User user = (User) request.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String error = request.getParameter("error");
    String updated = request.getParameter("updated");

    Cart cart = (Cart) session.getAttribute("cart");

    int cartCount = 0;

    if (cart != null && cart.getItems() != null) {
        cartCount = cart.getItems().size();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Profile - Foodwala</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/profile.css">

</head>

<body>


    <!-- ================= NAVBAR ================= -->

    <nav class="navbar">

        <a href="<%= request.getContextPath() %>/restaurent"
           class="logo">

            <span class="logo-icon">🍴</span>

            <span>Foodwala</span>

        </a>


        <div class="nav-links">

            <a href="<%= request.getContextPath() %>/restaurent">
                Restaurants
            </a>

            <a href="<%= request.getContextPath() %>/orders">
                Orders
            </a>

            <a href="<%= request.getContextPath() %>/profile"
               class="active">
                Profile
            </a>

            <a href="<%= request.getContextPath() %>/cart"
               class="cart-link">

                Cart

                <% if (cartCount > 0) { %>

                    <span class="cart-count">
                        <%= cartCount %>
                    </span>

                <% } %>

            </a>

        </div>

    </nav>


    <!-- ================= MAIN ================= -->

    <div class="page-wrapper">


        <!-- PAGE HEADING -->

        <div class="page-heading">

            <div class="badge">
                👤 MY ACCOUNT
            </div>

            <h1>My Profile</h1>

            <p>
                Manage your Foodwala account information
            </p>

        </div>


        <!-- PROFILE CARD -->

        <div class="profile-card">


            <!-- PROFILE HEADER -->

            <div class="profile-top">

                <div class="profile-icon">
                    👤
                </div>

                <div class="profile-heading">

                    <h2>
                        <%= user.getUsername() %>
                    </h2>

                    <p>
                        Your personal account details
                    </p>

                </div>

            </div>


            <!-- SUCCESS MESSAGE -->

            <% if ("true".equals(updated)) { %>

                <div class="message success-message">

                    ✓ Profile updated successfully.

                </div>

            <% } %>


            <!-- ERROR MESSAGE -->

            <% if (error != null) { %>

                <div class="message error-message">

                    ⚠ <%= error %>

                </div>

            <% } %>


            <!-- PROFILE BODY -->

            <div class="profile-body">


                <!-- ================= VIEW MODE ================= -->

                <div id="viewSection"
                     class="view-mode">


                    <div class="details-grid">


                        <!-- USERNAME -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Username
                            </span>

                            <span class="detail-value">
                                <%= user.getUsername() %>
                            </span>

                        </div>


                        <!-- EMAIL -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Email
                            </span>

                            <span class="detail-value">
                                <%= user.getEmail() %>
                            </span>

                        </div>


                        <!-- PHONE -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Phone
                            </span>

                            <span class="detail-value">

                                <%= user.getPhone() != null
                                        ? user.getPhone()
                                        : "Not provided" %>

                            </span>

                        </div>


                        <!-- ROLE -->

                        <div class="detail-box">

                            <span class="detail-label">
                                Account Role
                            </span>

                            <span class="detail-value">
                                <%= user.getRole() %>
                            </span>

                        </div>


                        <!-- ADDRESS -->

                        <div class="detail-box address-box">

                            <span class="detail-label">
                                Address
                            </span>

                            <span class="detail-value">

                                <%= user.getAddress() != null
                                        ? user.getAddress()
                                        : "Not provided" %>

                            </span>

                        </div>


                    </div>


                    <!-- ACCOUNT TYPE -->

                    <div class="role-box">

                        <span class="detail-label">
                            Account Type
                        </span>

                        <span class="role-value">
                            <%= user.getRole() %>
                        </span>

                    </div>


                    <!-- UPDATE BUTTON -->

                    <div class="button-row">

                        <button
                            type="button"
                            class="button primary-button"
                            onclick="enableEdit()">

                            ✎ Update Profile

                        </button>

                    </div>

                </div>


                <!-- ================= EDIT MODE ================= -->

                <div id="editSection"
                     class="edit-mode">


                    <form
                        action="<%= request.getContextPath() %>/profile"
                        method="post">


                        <!-- USERNAME -->

                        <div class="form-group">

                            <label for="username">
                                Username
                            </label>

                            <input
                                type="text"
                                id="username"
                                name="username"
                                value="<%= user.getUsername() %>"
                                required>

                        </div>


                        <!-- EMAIL -->

                        <div class="form-group">

                            <label for="email">
                                Email
                            </label>

                            <input
                                type="email"
                                id="email"
                                name="email"
                                value="<%= user.getEmail() %>"
                                required>

                        </div>


                        <!-- PASSWORD -->

                        <div class="form-group">

                            <label for="password">
                                Password
                            </label>

                            <input
                                type="password"
                                id="password"
                                name="password"
                                value="<%= user.getPassword() %>"
                                required>

                        </div>


                        <!-- PHONE -->

                        <div class="form-group">

                            <label for="phone">
                                Phone
                            </label>

                            <input
                                type="text"
                                id="phone"
                                name="phone"
                                value="<%= user.getPhone() != null
                                        ? user.getPhone()
                                        : "" %>">

                        </div>


                        <!-- ADDRESS -->

                        <div class="form-group">

                            <label for="address">
                                Address
                            </label>

                            <textarea
                                id="address"
                                name="address"><%= user.getAddress() != null
                                        ? user.getAddress()
                                        : "" %></textarea>

                        </div>


                        <!-- ROLE -->

                        <div class="role-box">

                            <span class="detail-label">
                                Account Role
                            </span>

                            <span class="role-value">
                                <%= user.getRole() %>
                            </span>

                        </div>


                        <!-- BUTTONS -->

                        <div class="button-row">

                            <button
                                type="submit"
                                class="button primary-button">

                                ✓ Save Changes

                            </button>


                            <button
                                type="button"
                                class="button secondary-button"
                                onclick="cancelEdit()">

                                Cancel

                            </button>

                        </div>


                    </form>

                </div>


                <!-- BACK -->

                <a
                    href="<%= request.getContextPath() %>/restaurent"
                    class="back-link">

                    ← Back to Restaurants

                </a>


            </div>

        </div>

    </div>


    <!-- ================= JAVASCRIPT ================= -->

    <script>

        function enableEdit() {

            document.getElementById("viewSection").style.display = "none";

            document.getElementById("editSection").style.display = "block";

        }


        function cancelEdit() {

            document.getElementById("editSection").style.display = "none";

            document.getElementById("viewSection").style.display = "block";

        }

    </script>


</body>

</html>