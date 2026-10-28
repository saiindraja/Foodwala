<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurent" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Foodwala - Restaurants</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/restaurent.css">
</head>

<body>

<%
    Cart cart = (Cart) session.getAttribute("cart");
    int cartCount = 0;

    if (cart != null) {
        cartCount = cart.getTotalQuantity();
    }

    User loggedInUser = (User) session.getAttribute("user");

    List<Restaurent> restaurents =
        (List<Restaurent>) request.getAttribute("restaurent");
%>

<!-- =====================================================
     NAVBAR
     ===================================================== -->

<nav class="navbar">

    <a href="<%= request.getContextPath() %>/restaurent"
       class="logo">
        Foodwala
    </a>

    <div class="nav-links">

        <a href="<%= request.getContextPath() %>/restaurent">
            Restaurants
        </a>

        <a href="<%= request.getContextPath() %>/orders">
            Orders
        </a>

        <%
            if (loggedInUser == null) {
        %>

            <a href="<%= request.getContextPath() %>/login.jsp">
                Login
            </a>

        <%
            } else {
        %>

            <a href="<%= request.getContextPath() %>/profile"
               class="user-link">
                👤 <%= loggedInUser.getUsername() %>
            </a>

            <a href="<%= request.getContextPath() %>/logout"
               class="logout-link">
                Logout
            </a>

        <%
            }
        %>

    </div>

    <a href="<%= request.getContextPath() %>/cart"
       class="cart-link">

        🛒 Cart

        <span class="cart-count">
            <%= cartCount %>
        </span>

    </a>

</nav>


<!-- =====================================================
     PREMIUM FOOD HERO
     ===================================================== -->

<section class="hero">

    <div class="hero-overlay"></div>

    <!-- LEFT CONTENT -->
    <div class="hero-content">

        <div class="hero-badge">
            ✦ Freshly made. Delivered with love.
        </div>

        <h1>
            Your cravings
            <span>start here.</span>
        </h1>

        <p>
            From soft idlis to crispy dosas,
            spicy biryanis to irresistible sweets —
            discover something delicious today.
        </p>

        <!-- SEARCH -->
        <div class="search-box">

            <span class="search-icon">
                🔍
            </span>

            <input
                type="text"
                id="restaurantSearch"
                placeholder="Search restaurants or cuisines..."
                autocomplete="off">

            <button
                type="button"
                class="search-btn"
                onclick="searchRestaurants()">
                Explore Food →
            </button>

        </div>

        <div class="hero-trust">

            <span>🍽️ 40+ Restaurants</span>

            <span>⚡ Fast Delivery</span>

            <span>❤️ Made for Food Lovers</span>

        </div>

    </div>


    <!-- =================================================
         RIGHT FOOD SHOWCASE
         ================================================= -->

    <div class="food-showcase">

        <div class="food-glow"></div>

        <div class="food-orbit orbit-one"></div>
        <div class="food-orbit orbit-two"></div>


        <!-- =================================================
             IDLI
             ================================================= -->

        <div class="food-slide slide-1 active">

            <div class="food-image-wrap">

                <img
                    src="https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto/dqqkysomtedjnhy4mqg6" onerror="this.onerror=null;this.src='https://images.pexels.com/photos/14831540/pexels-photo-14831540.jpeg?auto=compress&cs=tinysrgb&w=900';" referrerpolicy="no-referrer"
                    alt="Ghee Podi Idli">

            </div>

            <div class="food-label">

                <strong>Ghee Idli</strong>

                <span>Soft • Warm • Delicious</span>

            </div>

        </div>


        <!-- =================================================
             MASALA DOSA
             ================================================= -->

        <div class="food-slide slide-2">

            <div class="food-image-wrap">

                <img
                    src="https://154630363.cdn6.editmysite.com/uploads/1/5/4/6/154630363/XSWPR3Z73RCKZWWDDDQCERAH.png"
                    referrerpolicy="no-referrer"
                    alt="Masala Dosa">

            </div>

            <div class="food-label">

                <strong>Masala Dosa</strong>

                <span>Golden • Crispy • Aromatic</span>

            </div>

        </div>


        <!-- =================================================
             VADA
             ================================================= -->

        <div class="food-slide slide-3">

            <div class="food-image-wrap">

                <img
                    src="https://res.klook.com/images/w_1200%2Ch_630%2Cc_fill%2Cq_65/w_80%2Cx_15%2Cy_15%2Cg_south_west%2Cl_Klook_water_br_trans_yhcmh3/activities/kpbdmqfg4he939crua03/ChinatownLittleIndiaHalf-dayHeritageLocalFoodTour-KlookIndia.jpg" onerror="this.onerror=null;this.src='https://images.herzindagi.info/image/2024/Mar/instant-medu-vada-recipe-with-rice-flour.jpg';" referrerpolicy="no-referrer"
                    alt="Medu Vada">

            </div>

            <div class="food-label">

                <strong>Hot Vada</strong>

                <span>Crispy • Spicy • Fresh</span>

            </div>

        </div>


        <!-- =================================================
             POORI
             ================================================= -->

        <div class="food-slide slide-4">

            <div class="food-image-wrap">

                <img
                    src="https://i.cdn.newsbytesapp.com/ind/images/l23420250911201902.jpeg"
                    referrerpolicy="no-referrer"
                    alt="Puffed Poori">

            </div>

            <div class="food-label">

                <strong>Fluffy Poori</strong>

                <span>Hot • Puffy • Comforting</span>

            </div>

        </div>


        <!-- =================================================
             BIRYANI
             ================================================= -->

        <div class="food-slide slide-5">

            <div class="food-image-wrap">

                <img
                    src="https://chups.com/m2m/hyundai/food-images/Chicken-Biriyani.webp"
                    referrerpolicy="no-referrer"
                    alt="Chicken Biryani">

            </div>

            <div class="food-label">

                <strong>Royal Biryani</strong>

                <span>Rich • Spicy • Fragrant</span>

            </div>

        </div>


        <!-- =================================================
             GULAB JAMUN
             ================================================= -->

        <div class="food-slide slide-6">

            <div class="food-image-wrap">

                <img
                    src="https://epischerezepte.de/assets/images/1739387697124-lmn3rzrr.webp"
                    referrerpolicy="no-referrer"
                    alt="Gulab Jamun">

            </div>

            <div class="food-label">

                <strong>Gulab Jamun</strong>

                <span>Warm • Sweet • Irresistible</span>

            </div>

        </div>


        <!-- FLOATING DECORATIONS -->

        <div class="floating-spice spice-one">✦</div>
        <div class="floating-spice spice-two">✦</div>
        <div class="floating-spice spice-three">✧</div>

    </div>

</section>


<!-- =====================================================
     RESTAURANTS
     ===================================================== -->

<div class="container">

    <div class="section-header">

        <h2>
            Popular Restaurants
        </h2>

        <div class="restaurant-count"
             id="restaurantCount">

            <%
                if (restaurents != null) {
            %>

                <%= restaurents.size() %>
                restaurants available

            <%
                } else {
            %>

                0 restaurants available

            <%
                }
            %>

        </div>

    </div>


    <!-- FILTERS -->

    <div class="filters">

        <button type="button"
                class="filter active"
                data-filter="all">
            All
        </button>

        <button type="button"
                class="filter"
                data-filter="south indian">
            South Indian
        </button>

        <button type="button"
                class="filter"
                data-filter="north indian">
            North Indian
        </button>

        <button type="button"
                class="filter"
                data-filter="biryani">
            Biryani
        </button>

        <button type="button"
                class="filter"
                data-filter="chinese">
            Chinese
        </button>

        <button type="button"
                class="filter"
                data-filter="italian">
            Italian
        </button>

        <button type="button"
                class="filter"
                data-filter="fast food">
            Fast Food
        </button>

    </div>


    <!-- RESTAURANT CARDS -->

    <%
        if (restaurents != null && !restaurents.isEmpty()) {
    %>

        <div class="restaurant-grid"
             id="restaurantGrid">

            <%
                for (Restaurent restaurent : restaurents) {
            %>

                <div class="restaurant-card">

                    <div class="image-container">

                        <img
                            class="restaurant-image"
                            src="<%= restaurent.getImagePath() %>"
                            alt="<%= restaurent.getName() %>"
                            onerror="this.style.background='#eeeeee';">

                        <%
                            if (restaurent.isActive()) {
                        %>

                            <div class="status open">
                                ● Open Now
                            </div>

                        <%
                            } else {
                        %>

                            <div class="status closed">
                                ● Closed
                            </div>

                        <%
                            }
                        %>

                        <div class="rating">
                            ★ <%= restaurent.getRating() %>
                        </div>

                    </div>


                    <div class="card-content">

                        <div class="restaurant-name">
                            <%= restaurent.getName() %>
                        </div>

                        <div class="cuisine">
                            <%= restaurent.getCuisineType() %>
                        </div>

                        <div class="info-row">

                            <div class="info">
                                🕒 <%= restaurent.getDeliveryTime() %>
                            </div>

                            <div class="info">
                                🛵 Delivery
                            </div>

                        </div>

                        <div class="address">
                            📍 <%= restaurent.getAddress() %>
                        </div>

                        <a
                            href="<%= request.getContextPath() %>/menu?restaurantId=<%= restaurent.getRestaurantId() %>"
                            class="view-menu-btn">

                            View Menu →

                        </a>

                    </div>

                </div>

            <%
                }
            %>

        </div>


        <div
            class="empty-message"
            id="searchEmptyMessage">

            <h3>
                No restaurants found
            </h3>

            <p>
                Try another restaurant name, cuisine,
                or select a different filter.
            </p>

        </div>

    <%
        } else {
    %>

        <div
            class="empty-message"
            style="display:block;">

            <h3>
                No restaurants found
            </h3>

            <p>
                Please check again later.
            </p>

        </div>

    <%
        }
    %>

</div>


<!-- =====================================================
     FOOTER
     ===================================================== -->

<footer class="footer">

    <div class="footer-logo">
        Foodwala
    </div>

    <p>
        Delicious food. Delivered with care.
    </p>

</footer>


<!-- =====================================================
     JAVASCRIPT
     ===================================================== -->

<script>

/* ==================================================
   FOOD HERO SLIDER
   ================================================== */

const foodSlides = document.querySelectorAll(".food-slide");

let currentFood = 0;

function showFoodSlide(index) {

    foodSlides.forEach(function(slide) {
        slide.classList.remove("active");
    });

    if (foodSlides.length > 0) {
        foodSlides[index].classList.add("active");
    }
}

function showNextFood() {

    if (foodSlides.length === 0) {
        return;
    }

    currentFood++;

    if (currentFood >= foodSlides.length) {
        currentFood = 0;
    }

    showFoodSlide(currentFood);
}

showFoodSlide(currentFood);

setInterval(showNextFood, 4000);


/* ==================================================
   RESTAURANT SEARCH + FILTER
   ================================================== */

let selectedFilter = "all";

function getRestaurantCards() {

    return document.querySelectorAll(".restaurant-card");

}

function searchRestaurants() {

    applySearchAndFilter();

}

function applySearchAndFilter() {

    const searchInput =
        document.getElementById("restaurantSearch");

    if (!searchInput) {
        return;
    }

    const searchText =
        searchInput.value.trim().toLowerCase();

    const cards =
        getRestaurantCards();

    let visibleCount = 0;

    cards.forEach(function(card) {

        const restaurantNameElement =
            card.querySelector(".restaurant-name");

        const cuisineElement =
            card.querySelector(".cuisine");

        const addressElement =
            card.querySelector(".address");


        const restaurantName =
            restaurantNameElement
                ? restaurantNameElement.textContent.trim().toLowerCase()
                : "";


        const cuisine =
            cuisineElement
                ? cuisineElement.textContent.trim().toLowerCase()
                : "";


        const address =
            addressElement
                ? addressElement.textContent.trim().toLowerCase()
                : "";


        const searchMatch =
            searchText === "" ||
            restaurantName.includes(searchText) ||
            cuisine.includes(searchText) ||
            address.includes(searchText);


        let filterMatch = true;

        if (selectedFilter !== "all") {

            filterMatch =
                cuisine.includes(selectedFilter);

        }


        if (searchMatch && filterMatch) {

            card.style.display = "";
            visibleCount++;

        } else {

            card.style.display = "none";

        }

    });


    const countElement =
        document.getElementById("restaurantCount");


    if (countElement) {

        countElement.textContent =
            visibleCount +
            (visibleCount === 1
                ? " restaurant available"
                : " restaurants available");

    }


    const emptyMessage =
        document.getElementById("searchEmptyMessage");


    if (emptyMessage) {

        if (visibleCount === 0) {

            emptyMessage.style.display = "block";

        } else {

            emptyMessage.style.display = "none";

        }

    }

}


/* ==================================================
   FILTER BUTTONS
   ================================================== */

const filterButtons =
    document.querySelectorAll(".filter");

filterButtons.forEach(function(button) {

    button.addEventListener("click", function() {

        filterButtons.forEach(function(btn) {

            btn.classList.remove("active");

        });

        this.classList.add("active");

        selectedFilter =
            this.getAttribute("data-filter");

        applySearchAndFilter();

    });

});


/* ==================================================
   SEARCH WHILE TYPING
   ================================================== */

const searchInput =
    document.getElementById("restaurantSearch");

if (searchInput) {

    searchInput.addEventListener(
        "input",
        function() {

            applySearchAndFilter();

        }
    );


    searchInput.addEventListener(
        "keydown",
        function(event) {

            if (event.key === "Enter") {

                event.preventDefault();

                searchRestaurants();

            }

        }
    );

}


/* ==================================================
   INITIAL LOAD
   ================================================== */

applySearchAndFilter();

</script>

</body>
</html>
