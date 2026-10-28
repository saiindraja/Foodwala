package com.tap.dao;

import java.util.List;

import com.tap.model.Order;

public interface OrderDAO {

    int addOrder(Order order);

    Order getOrder(int orderId);

    List<Order> getAllOrders();

    List<Order> getOrdersByUser(int userId);

    void updateOrder(Order order);

    void deleteOrder(int orderId);
}