<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Foodwala - Register</title>

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;

            font-family: Arial, Helvetica, sans-serif;

            background:
                radial-gradient(
                    circle at top left,
                    rgba(255, 140, 0, 0.12),
                    transparent 32%
                ),
                linear-gradient(
                    135deg,
                    #fffaf5,
                    #fff0e3
                );

            display: flex;
            align-items: center;
            justify-content: center;

            padding: 35px 20px;
        }

        /* ================= REGISTER CARD ================= */

        .register-container {
            width: 100%;
            max-width: 480px;

            background: rgba(255, 255, 255, 0.97);

            border: 1px solid rgba(87, 47, 25, 0.08);

            border-radius: 26px;

            padding: 36px 38px;

            box-shadow:
                0 18px 50px rgba(65, 32, 13, 0.12);
        }

        /* ================= LOGO ================= */

        .logo-area {
            display: flex;

            align-items: center;
            justify-content: center;

            gap: 10px;

            margin-bottom: 14px;
        }

        .logo-icon {
            width: 43px;
            height: 43px;

            display: flex;
            align-items: center;
            justify-content: center;

            border-radius: 13px;

            background:
                linear-gradient(
                    135deg,
                    #ff8c00,
                    #ee4218
                );

            color: white;

            font-size: 22px;

            box-shadow:
                0 7px 18px rgba(238, 66, 24, 0.22);
        }

        .logo {
            color: #241811;

            font-family: Georgia, "Times New Roman", serif;

            font-size: 27px;

            font-weight: 900;
        }

        /* ================= TITLE ================= */

        .title {
            text-align: center;

            font-family: Georgia, "Times New Roman", serif;

            font-size: 31px;

            font-weight: 900;

            color: #241811;

            margin-bottom: 7px;
        }

        .subtitle {
            text-align: center;

            color: #80685b;

            font-size: 13px;

            margin-bottom: 28px;
        }

        /* ================= BADGE ================= */

        .register-badge {
            width: fit-content;

            margin: 0 auto 14px;

            padding: 7px 13px;

            border-radius: 30px;

            background: #fff0e3;

            color: #ef4b1c;

            font-size: 10px;

            font-weight: 900;

            letter-spacing: 0.5px;
        }

        /* ================= ERROR ================= */

        .error-message {
            padding: 12px 14px;

            margin-bottom: 20px;

            border-radius: 11px;

            background: #fff0ef;

            border: 1px solid #f2c9c5;

            color: #b7352c;

            text-align: center;

            font-size: 13px;

            font-weight: 700;
        }

        /* ================= FORM ================= */

        .form-group {
            margin-bottom: 17px;
        }

        .form-group label {
            display: block;

            margin-bottom: 7px;

            color: #6e5142;

            font-size: 11px;

            font-weight: 900;

            text-transform: uppercase;

            letter-spacing: 0.5px;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {

            width: 100%;

            padding: 13px 14px;

            border: 1px solid #e5d7cc;

            border-radius: 11px;

            background: #fffdfa;

            color: #2d2019;

            font-family: Arial, Helvetica, sans-serif;

            font-size: 14px;

            outline: none;

            transition: 0.25s ease;
        }

        .form-group textarea {
            min-height: 82px;

            resize: vertical;
        }

        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: #b39d91;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {

            border-color: #f27635;

            background: white;

            box-shadow:
                0 0 0 3px rgba(242, 118, 53, 0.10);
        }

        /* ================= REGISTER BUTTON ================= */

        .register-btn {

            width: 100%;

            height: 45px;

            border: none;

            border-radius: 11px;

            background:
                linear-gradient(
                    135deg,
                    #ff8c00,
                    #ee4218
                );

            color: white;

            font-size: 13px;

            font-weight: 900;

            cursor: pointer;

            box-shadow:
                0 8px 20px rgba(238, 66, 24, 0.20);

            transition: 0.25s ease;
        }

        .register-btn:hover {

            transform: translateY(-2px);

            box-shadow:
                0 11px 25px rgba(238, 66, 24, 0.28);
        }

        /* ================= LOGIN ================= */

        .login-section {

            text-align: center;

            margin-top: 25px;

            padding-top: 20px;

            border-top: 1px solid #eee3dc;
        }

        .login-section p {

            margin-bottom: 8px;

            color: #80685b;

            font-size: 13px;
        }

        .login-link {

            color: #ef4b1c;

            font-size: 13px;

            font-weight: 900;

            text-decoration: none;
        }

        .login-link:hover {

            color: #d83b13;

            text-decoration: underline;
        }

        /* ================= BACK ================= */

        .back-link {

            display: block;

            width: fit-content;

            margin: 18px auto 0;

            color: #8a6755;

            font-size: 12px;

            font-weight: 800;

            text-decoration: none;

            transition: 0.25s ease;
        }

        .back-link:hover {

            color: #ef4b1c;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 520px) {

            body {
                padding: 20px 14px;
            }

            .register-container {

                padding: 30px 22px;

                border-radius: 22px;
            }

            .title {
                font-size: 27px;
            }

            .logo {
                font-size: 25px;
            }
        }

    </style>

</head>


<body>


    <div class="register-container">


        <!-- LOGO -->

        <div class="logo-area">

            <div class="logo-icon">
                🍴
            </div>

            <div class="logo">
                Foodwala
            </div>

        </div>


        <!-- BADGE -->

        <div class="register-badge">
            🍽️ JOIN FOODWALA
        </div>


        <!-- TITLE -->

        <div class="title">
            Create Account
        </div>

        <div class="subtitle">
            Create your account and start ordering delicious food
        </div>


        <%
            String error = request.getParameter("error");

            if ("required".equals(error)) {
        %>

            <div class="error-message">
                Please fill in all the fields.
            </div>

        <%
            }
        %>


        <!-- ================= REGISTRATION FORM ================= -->

        <form
            action="<%= request.getContextPath() %>/register"
            method="post"
        >


            <!-- USERNAME -->

            <div class="form-group">

                <label for="username">
                    Username
                </label>

                <input
                    type="text"
                    id="username"
                    name="username"
                    placeholder="Enter your username"
                    required
                >

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
                    placeholder="Enter your email"
                    required
                >

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
                    placeholder="Enter your password"
                    required
                >

            </div>


            <!-- PHONE -->

            <div class="form-group">

                <label for="phone">
                    Phone
                </label>

                <input
                    type="tel"
                    id="phone"
                    name="phone"
                    placeholder="Enter your phone number"
                    required
                >

            </div>


            <!-- ADDRESS -->

            <div class="form-group">

                <label for="address">
                    Address
                </label>

                <textarea
                    id="address"
                    name="address"
                    placeholder="Enter your address"
                    required
                ></textarea>

            </div>


            <!-- ROLE -->

            <div class="form-group">

                <label for="role">
                    Role
                </label>

                <select
                    id="role"
                    name="role"
                    required
                >

                    <option value="">
                        Select Role
                    </option>

                    <option value="CUSTOMER">
                        Customer
                    </option>

                </select>

            </div>


            <!-- REGISTER BUTTON -->

            <button
                type="submit"
                class="register-btn"
            >
                Create My Account
            </button>


        </form>


        <!-- LOGIN -->

        <div class="login-section">

            <p>
                Already have an account?
            </p>

            <a
                href="<%= request.getContextPath() %>/login.jsp"
                class="login-link"
            >
                Login to Foodwala
            </a>

        </div>


        <!-- BACK -->

        <a
            href="<%= request.getContextPath() %>/restaurent"
            class="back-link"
        >
            ← Back to Restaurants
        </a>


    </div>


</body>

</html>