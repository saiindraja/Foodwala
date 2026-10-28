<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Foodwala - Login</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/common.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/login.css">
</head>

<body>

<div class="login-page">

    <div class="login-visual">

        <div class="visual-content">

            <a href="<%= request.getContextPath() %>/restaurent"
               class="brand">
                Foodwala
            </a>

            <span class="visual-tag">WELCOME BACK</span>

            <h1>
                Good food is<br>
                <span>always worth</span><br>
                coming back for.
            </h1>

            <p>
                Sign in to continue ordering your favourite meals
                from Foodwala's best restaurants.
            </p>

            <div class="food-showcase">
                <div class="food-circle">🍛</div>
                <div class="food-circle small">🍕</div>
                <div class="food-circle small second">🍔</div>
            </div>

        </div>

    </div>

    <div class="login-side">

        <div class="login-card">

            <div class="mobile-brand">
                <a href="<%= request.getContextPath() %>/restaurent">
                    Foodwala
                </a>
            </div>

            <div class="login-heading">
                <span class="eyebrow">FOODWALA ACCOUNT</span>

                <h2>Welcome back 👋</h2>

                <p>
                    Login to your account to continue.
                </p>
            </div>

            <%
                String error = request.getParameter("error");

                if ("invalid".equals(error)) {
            %>

                <div class="error-message">
                    <span>!</span>
                    <div>
                        <strong>Login failed</strong>
                        <small>Invalid email or password.</small>
                    </div>
                </div>

            <%
                }
            %>

            <%
                if ("required".equals(error)) {
            %>

                <div class="error-message">
                    <span>!</span>
                    <div>
                        <strong>Details required</strong>
                        <small>Please enter email and password.</small>
                    </div>
                </div>

            <%
                }
            %>

            <form
                action="<%= request.getContextPath() %>/login"
                method="post"
                class="login-form"
            >

                <div class="form-group">

                    <label for="email">
                        Email Address
                    </label>

                    <div class="input-wrap">
                        <span class="input-icon">✉</span>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="Enter your email"
                            autocomplete="email"
                            required
                        >
                    </div>

                </div>

                <div class="form-group">

                    <label for="password">
                        Password
                    </label>

                    <div class="input-wrap">
                        <span class="input-icon">🔒</span>

                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            autocomplete="current-password"
                            required
                        >
                    </div>

                </div>

                <button
                    type="submit"
                    class="login-btn"
                >
                    Login
                    <span>→</span>
                </button>

            </form>

            <div class="register-section">

                <span>New to Foodwala?</span>

                <a
                    href="<%= request.getContextPath() %>/register.jsp"
                    class="register-link"
                >
                    Create an account
                </a>

            </div>

            <a
                href="<%= request.getContextPath() %>/restaurent"
                class="back-link"
            >
                ← Back to Restaurants
            </a>

            <div class="login-footer">
                🔒 Your account information is kept secure.
            </div>

        </div>

    </div>

</div>

</body>
</html>
