<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.User" %>

<%
    response.setCharacterEncoding("UTF-8");

    Cart cart = (Cart) request.getAttribute("cart");
    if (cart == null) {
        cart = (Cart) session.getAttribute("cart");
    }

    User user = (User) request.getAttribute("user");
    if (user == null) {
        user = (User) session.getAttribute("user");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Foodwala - Checkout</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/common.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/checkout.css">
</head>

<body>

<nav class="navbar">
    <div class="nav-container">
        <a href="<%= request.getContextPath() %>/restaurent" class="logo">
            Foodwala
        </a>

        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/restaurent">Restaurants</a>
            <a href="<%= request.getContextPath() %>/orders">Orders</a>

            <% if (user != null) { %>
                <a href="<%= request.getContextPath() %>/profile">Profile</a>
                <a href="<%= request.getContextPath() %>/logout">Logout</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
            <% } %>

            <a href="<%= request.getContextPath() %>/cart" class="nav-cart">
                🛒 Cart
                <% if (cart != null && !cart.isEmpty()) { %>
                    <span class="cart-badge"><%= cart.getItems().size() %></span>
                <% } %>
            </a>
        </div>
    </div>
</nav>

<main class="checkout-page">

    <div class="checkout-header">
        <div>
            <span class="eyebrow">FOODWALA</span>
            <h1>Complete Your Order</h1>
            <p>Review your items, add your delivery details, and choose your payment method.</p>
        </div>

        <a href="<%= request.getContextPath() %>/cart" class="back-btn">
            ← Back to Cart
        </a>
    </div>

    <% if (cart == null || cart.isEmpty()) { %>

        <section class="empty-checkout">
            <div class="empty-icon">🛒</div>
            <h2>Your cart is empty</h2>
            <p>Add some delicious food before proceeding to checkout.</p>
            <a href="<%= request.getContextPath() %>/restaurent" class="primary-btn">
                Explore Restaurants
            </a>
        </section>

    <% } else { %>

        <form action="<%= request.getContextPath() %>/checkout" method="post">

            <div class="checkout-layout">

                <!-- LEFT SIDE -->
                <div class="checkout-main">

                    <section class="checkout-card">
                        <div class="card-heading">
                            <div>
                                <span class="step-number">01</span>
                                <div>
                                    <h2>Your Order</h2>
                                    <p>Items you are ordering</p>
                                </div>
                            </div>
                        </div>

                        <div class="order-items">

                            <% for (CartItem item : cart.getItems()) { %>

                                <div class="order-item">

                                    <div class="food-image-wrap">
                                        <img src="<%= item.getMenu().getImagePath() %>"
                                             alt="<%= item.getMenu().getItemName() %>"
                                             class="food-image">
                                    </div>

                                    <div class="item-info">
                                        <h3><%= item.getMenu().getItemName() %></h3>
                                        <p>₹<%= item.getMenu().getPrice() %> each</p>
                                        <span class="quantity-pill">
                                            Qty: <%= item.getQuantity() %>
                                        </span>
                                    </div>

                                    <div class="item-total">
                                        ₹<%= item.getTotalPrice() %>
                                    </div>

                                </div>

                            <% } %>

                        </div>
                    </section>

                    <!-- DELIVERY -->
                    <section class="checkout-card">

                        <div class="card-heading">
                            <div>
                                <span class="step-number">02</span>
                                <div>
                                    <h2>Delivery Details</h2>
                                    <p>Where should we deliver your food?</p>
                                </div>
                            </div>
                        </div>

                        <div class="form-box">

                            <div class="form-row">

                                <div class="form-group">
                                    <label for="name">Full Name</label>
                                    <input type="text"
                                           id="name"
                                           name="name"
                                           value="<%= user != null && user.getUsername() != null ? user.getUsername() : "" %>"
                                           placeholder="Enter your name"
                                           required>
                                </div>

                                <div class="form-group">
                                    <label for="phone">Phone Number</label>
                                    <input type="tel"
                                           id="phone"
                                           name="phone"
                                           value="<%= user != null && user.getPhone() != null ? user.getPhone() : "" %>"
                                           placeholder="Enter phone number"
                                           required>
                                </div>

                            </div>

                            <div class="form-group">
                                <label for="address">Delivery Address</label>
                                <textarea id="address"
                                          name="address"
                                          placeholder="Enter your complete delivery address"
                                          required><%= user != null && user.getAddress() != null ? user.getAddress() : "" %></textarea>
                            </div>

                            <div class="form-row">

                                <div class="form-group">
                                    <label for="city">City</label>
                                    <input type="text"
                                           id="city"
                                           name="city"
                                           placeholder="Enter city"
                                           required>
                                </div>

                                <div class="form-group">
                                    <label for="pincode">Pincode</label>
                                    <input type="text"
                                           id="pincode"
                                           name="pincode"
                                           placeholder="6-digit pincode"
                                           maxlength="6"
                                           required>
                                </div>

                            </div>

                            <div class="form-group">
                                <label for="instructions">
                                    Delivery Instructions
                                    <span class="optional">(Optional)</span>
                                </label>

                                <textarea id="instructions"
                                          name="instructions"
                                          class="small-textarea"
                                          placeholder="Example: Call when you reach the gate"></textarea>
                            </div>

                        </div>

                    </section>

                    <!-- PAYMENT -->
                    <section class="checkout-card">

                        <div class="card-heading">
                            <div>
                                <span class="step-number">03</span>
                                <div>
                                    <h2>Payment Method</h2>
                                    <p>Choose how you want to pay</p>
                                </div>
                            </div>
                        </div>

                        <div class="payment-list">

                            <label class="payment-option">
                                <input type="radio"
                                       id="cod"
                                       name="paymentMethod"
                                       value="COD"
                                       onclick="showPayment('codDetails')"
                                       required>

                                <span class="payment-icon">💵</span>

                                <span class="payment-text">
                                    <strong>Cash on Delivery</strong>
                                    <small>Pay when your order arrives</small>
                                </span>

                                <span class="radio-mark"></span>
                            </label>

                            <div id="codDetails" class="payment-details">
                                <strong>Cash on Delivery selected.</strong>
                                <p>Keep the exact amount ready when your food is delivered.</p>
                            </div>


                            <label class="payment-option">
                                <input type="radio"
                                       id="upi"
                                       name="paymentMethod"
                                       value="UPI"
                                       onclick="showPayment('upiDetails')">

                                <span class="payment-icon">📱</span>

                                <span class="payment-text">
                                    <strong>UPI</strong>
                                    <small>Pay using your UPI ID</small>
                                </span>

                                <span class="radio-mark"></span>
                            </label>

                            <div id="upiDetails" class="payment-details">

                                <div class="form-group">
                                    <label for="upiId">UPI ID</label>
                                    <input type="text"
                                           id="upiId"
                                           name="upiId"
                                           placeholder="example@upi">
                                </div>

                            </div>


                            <label class="payment-option">
                                <input type="radio"
                                       id="card"
                                       name="paymentMethod"
                                       value="CARD"
                                       onclick="showPayment('cardDetails')">

                                <span class="payment-icon">💳</span>

                                <span class="payment-text">
                                    <strong>Credit / Debit Card</strong>
                                    <small>Pay securely using your card</small>
                                </span>

                                <span class="radio-mark"></span>
                            </label>

                            <div id="cardDetails" class="payment-details">

                                <div class="form-group">
                                    <label for="cardNumber">Card Number</label>
                                    <input type="text"
                                           id="cardNumber"
                                           name="cardNumber"
                                           placeholder="Enter card number"
                                           maxlength="16">
                                </div>

                                <div class="form-row">

                                    <div class="form-group">
                                        <label for="expiry">Expiry Date</label>
                                        <input type="text"
                                               id="expiry"
                                               name="expiry"
                                               placeholder="MM/YY">
                                    </div>

                                    <div class="form-group">
                                        <label for="cvv">CVV</label>
                                        <input type="password"
                                               id="cvv"
                                               name="cvv"
                                               placeholder="CVV"
                                               maxlength="3">
                                    </div>

                                </div>

                            </div>

                        </div>

                    </section>

                </div>

                <!-- RIGHT SIDE -->
                <aside class="checkout-summary">

                    <div class="summary-card">

                        <div class="summary-top">
                            <span>ORDER SUMMARY</span>
                            <span class="secure-badge">✓ Secure</span>
                        </div>

                        <h2>Ready to order?</h2>
                        <p class="summary-subtitle">
                            Your food is almost on its way.
                        </p>

                        <div class="summary-divider"></div>

                        <div class="summary-row">
                            <span>Items</span>
                            <span><%= cart.getItems().size() %></span>
                        </div>

                        <div class="summary-row">
                            <span>Subtotal</span>
                            <span>₹<%= cart.getTotalAmount() %></span>
                        </div>

                        <div class="summary-row">
                            <span>Delivery</span>
                            <span class="free">FREE</span>
                        </div>

                        <div class="summary-divider"></div>

                        <div class="summary-total">
                            <span>Total</span>
                            <strong>₹<%= cart.getTotalAmount() %></strong>
                        </div>

                        <button type="submit" class="place-order-btn">
                            Place Order
                            <span>→</span>
                        </button>

                        <div class="secure-note">
                            🔒 Your order details are securely submitted.
                        </div>

                    </div>

                </aside>

            </div>

        </form>

    <% } %>

</main>

<script>
function showPayment(paymentId) {

    var paymentDetails =
        document.querySelectorAll(".payment-details");

    for (var i = 0; i < paymentDetails.length; i++) {
        paymentDetails[i].classList.remove("active");
    }

    document.getElementById(paymentId).classList.add("active");
}
</script>

</body>
</html>
