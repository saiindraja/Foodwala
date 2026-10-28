
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || user.getRole() == null
            || !"admin".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<User> customers =
            (List<User>) request.getAttribute("customers");

    if (customers == null) {
        response.sendRedirect(request.getContextPath() + "/admin/customers");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Foodwala | Manage Customers</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/admin.css">

    <style>
        .customer-section {
            background: #fff;
            padding: 25px;
            margin: 25px 0;
            border: 1px solid #ffe2d6;
            border-radius: 16px;
            box-shadow: 0 5px 18px rgba(255, 77, 45, .08);
        }

        .customer-section h2 {
            color: #ff4d2d;
            margin-bottom: 10px;
            font-size: 23px;
        }

        .customer-count {
            margin-top: 20px;
            color: #444;
        }

        .table-wrapper {
            overflow-x: auto;
            margin-top: 20px;
            background: #fff;
            border: 1px solid #ffe2d6;
            border-radius: 12px;
        }

        .customer-table {
            width: 100%;
            min-width: 750px;
            border-collapse: collapse;
        }

        .customer-table th,
        .customer-table td {
            padding: 14px;
            border-bottom: 1px solid #ffe8df;
            text-align: left;
            vertical-align: middle;
        }

        .customer-table th {
            background: #fff0e9;
            color: #ff4d2d;
            white-space: nowrap;
        }

        .customer-table tbody tr:hover {
            background: #fffaf7;
        }

        .empty-row {
            text-align: center !important;
            padding: 30px !important;
            color: #777;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #ff4d2d;
            text-decoration: none;
            font-weight: bold;
        }

        .customer-message {
            padding: 13px;
            margin: 15px 0;
            background: #fff0ec;
            color: #b42318;
            border-radius: 8px;
        }

        @media (max-width: 650px) {
            .customer-section {
                padding: 18px;
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
            <h1>Manage Customers</h1>
            <p>View registered customer details in Foodwala.</p>
        </section>

        <section class="customer-section">

            <h2>Registered Customers</h2>

            <p class="customer-count">
                <strong>Total Customers:</strong>
                <%= customers.size() %>
            </p>

            <div class="table-wrapper">
                <table class="customer-table">

                    <thead>
                        <tr>
                            <th>Customer ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Address</th>
                        </tr>
                    </thead>

                    <tbody>

                        <% if (customers.isEmpty()) { %>

                            <tr>
                                <td colspan="5" class="empty-row">
                                    No customers found.
                                </td>
                            </tr>

                        <% } else {
                               for (User customer : customers) {
                        %>

                            <tr>
                                <td><%= customer.getUserId() %></td>

                                <td>
                                    <%= customer.getUsername() == null
                                            ? "" : customer.getUsername() %>
                                </td>

                                <td>
                                    <%= customer.getEmail() == null
                                            ? "" : customer.getEmail() %>
                                </td>

                                <td>
                                    <%= customer.getPhone() == null
                                            ? "" : customer.getPhone() %>
                                </td>

                                <td>
                                    <%= customer.getAddress() == null
                                            ? "" : customer.getAddress() %>
                                </td>
                            </tr>

                        <%     }
                           }
                        %>

                    </tbody>

                </table>
            </div>

        </section>

    </main>

    <footer class="admin-footer">
        Foodwala Admin Panel
    </footer>

</body>
</html>
