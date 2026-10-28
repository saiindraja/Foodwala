package com.tap.model;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {

    private Map<Integer, CartItem> items;
    private int restaurantId;

    public Cart() {
        items = new LinkedHashMap<>();
        restaurantId = 0;
    }

    // ==============================
    // ADD ITEM
    // ==============================
    public boolean addItem(Menu menu) {

        if (items.isEmpty()) {
            restaurantId = menu.getRestaurantId();
        }

        // Do not allow another restaurant
        if (restaurantId != menu.getRestaurantId()) {
            return false;
        }

        int menuId = menu.getMenuId();

        if (items.containsKey(menuId)) {

            CartItem cartItem = items.get(menuId);

            cartItem.setQuantity(
                cartItem.getQuantity() + 1
            );

        } else {

            CartItem cartItem = new CartItem(menu, 1);

            items.put(menuId, cartItem);
        }

        return true;
    }

    // ==============================
    // UPDATE QUANTITY
    // ==============================
    public void updateQuantity(int menuId, int quantity) {

        if (!items.containsKey(menuId)) {
            return;
        }

        if (quantity <= 0) {

            // Remove only this item
            items.remove(menuId);

            // Reset restaurant only when
            // the complete cart becomes empty
            if (items.isEmpty()) {
                restaurantId = 0;
            }

        } else {

            CartItem cartItem = items.get(menuId);

            cartItem.setQuantity(quantity);
        }
    }

    // ==============================
    // REMOVE ONE ITEM COMPLETELY
    // ==============================
    public void removeItem(int menuId) {

        items.remove(menuId);

        if (items.isEmpty()) {
            restaurantId = 0;
        }
    }

    // ==============================
    // GET ITEMS
    // ==============================
    public Collection<CartItem> getItems() {
        return items.values();
    }

    // ==============================
    // TOTAL AMOUNT
    // ==============================
    public double getTotalAmount() {

        double total = 0;

        for (CartItem item : items.values()) {
            total = total + item.getTotalPrice();
        }

        return total;
    }
    
 // ==========================================
 // GET QUANTITY OF ONE MENU ITEM
 // ==========================================
 public int getItemQuantity(int menuId) {

     if (items.containsKey(menuId)) {

         return items.get(menuId).getQuantity();
     }

     return 0;
 }

    // ==============================
    // TOTAL QUANTITY
    // ==============================
    public int getTotalQuantity() {

        int totalQuantity = 0;

        for (CartItem item : items.values()) {
            totalQuantity = totalQuantity + item.getQuantity();
        }

        return totalQuantity;
    }

    // ==============================
    // RESTAURANT ID
    // ==============================
    public int getRestaurantId() {
        return restaurantId;
    }

    // ==============================
    // EMPTY CHECK
    // ==============================
    public boolean isEmpty() {
        return items.isEmpty();
    }

    // ==============================
    // CLEAR CART
    // ==============================
    public void clear() {

        items.clear();

        restaurantId = 0;
    }
}