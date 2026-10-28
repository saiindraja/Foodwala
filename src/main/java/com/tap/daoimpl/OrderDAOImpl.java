package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderDAO;
import com.tap.model.Order;
import com.tap.util.DBConnection;

public class OrderDAOImpl implements OrderDAO {

    private static final String ADD_ORDER =
            "INSERT INTO orders "
          + "(userId, restaurantId, orderDate, totalAmount, status, paymentMethod, address) "
          + "VALUES (?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_ORDER_BY_ID =
            "SELECT * FROM orders WHERE orderId = ?";

    private static final String GET_ALL_ORDERS =
            "SELECT * FROM orders";

    private static final String GET_ORDERS_BY_USER =
            "SELECT * FROM orders WHERE userId = ?";

    private static final String UPDATE_ORDER =
            "UPDATE orders SET userId = ?, restaurantId = ?, "
          + "orderDate = ?, totalAmount = ?, status = ?, "
          + "paymentMethod = ?, address = ? "
          + "WHERE orderId = ?";

    private static final String DELETE_ORDER =
            "DELETE FROM orders WHERE orderId = ?";


    @Override
    public int addOrder(Order order) {

        int generatedOrderId = 0;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(
                     ADD_ORDER,
                     Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getRestaurantId());
            ps.setTimestamp(3, order.getOrderDate());
            ps.setDouble(4, order.getTotalAmount());
            ps.setString(5, order.getStatus());
            ps.setString(6, order.getPaymentMethod());
            ps.setString(7, order.getAddress());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {

                if (rs.next()) {
                    generatedOrderId = rs.getInt(1);
                }
            }

            System.out.println(
                    "Order added successfully. Order ID: "
                    + generatedOrderId);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return generatedOrderId;
    }


    @Override
    public Order getOrder(int orderId) {

        Order order = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(GET_ORDER_BY_ID)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    order = new Order();

                    order.setOrderId(rs.getInt("orderId"));
                    order.setUserId(rs.getInt("userId"));
                    order.setRestaurantId(rs.getInt("restaurantId"));
                    order.setOrderDate(
                            rs.getTimestamp("orderDate"));
                    order.setTotalAmount(
                            rs.getDouble("totalAmount"));
                    order.setStatus(
                            rs.getString("status"));
                    order.setPaymentMethod(
                            rs.getString("paymentMethod"));
                    order.setAddress(
                            rs.getString("address"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }


    @Override
    public List<Order> getAllOrders() {

        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(GET_ALL_ORDERS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Order order = new Order();

                order.setOrderId(rs.getInt("orderId"));
                order.setUserId(rs.getInt("userId"));
                order.setRestaurantId(
                        rs.getInt("restaurantId"));
                order.setOrderDate(
                        rs.getTimestamp("orderDate"));
                order.setTotalAmount(
                        rs.getDouble("totalAmount"));
                order.setStatus(
                        rs.getString("status"));
                order.setPaymentMethod(
                        rs.getString("paymentMethod"));
                order.setAddress(
                        rs.getString("address"));

                orders.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }


    @Override
    public List<Order> getOrdersByUser(int userId) {

        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(GET_ORDERS_BY_USER)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Order order = new Order();

                    order.setOrderId(
                            rs.getInt("orderId"));
                    order.setUserId(
                            rs.getInt("userId"));
                    order.setRestaurantId(
                            rs.getInt("restaurantId"));
                    order.setOrderDate(
                            rs.getTimestamp("orderDate"));
                    order.setTotalAmount(
                            rs.getDouble("totalAmount"));
                    order.setStatus(
                            rs.getString("status"));
                    order.setPaymentMethod(
                            rs.getString("paymentMethod"));
                    order.setAddress(
                            rs.getString("address"));

                    orders.add(order);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }


    @Override
    public void updateOrder(Order order) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(UPDATE_ORDER)) {

            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getRestaurantId());
            ps.setTimestamp(3, order.getOrderDate());
            ps.setDouble(4, order.getTotalAmount());
            ps.setString(5, order.getStatus());
            ps.setString(6, order.getPaymentMethod());
            ps.setString(7, order.getAddress());
            ps.setInt(8, order.getOrderId());

            ps.executeUpdate();

            System.out.println("Order updated successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void deleteOrder(int orderId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(DELETE_ORDER)) {

            ps.setInt(1, orderId);

            ps.executeUpdate();

            System.out.println("Order deleted successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}