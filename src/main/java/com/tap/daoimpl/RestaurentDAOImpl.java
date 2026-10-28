package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.RestaurentDAO;
import com.tap.model.Restaurent;
import com.tap.util.DBConnection;

public class RestaurentDAOImpl implements RestaurentDAO {

    private static final String ADD_RESTAURENT =
            "INSERT INTO restaurents "
          + "(name, cuisineType, deliveryTime, address, adminUserId, rating, isActive, imagePath) "
          + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_RESTAURENT_BY_ID =
            "SELECT * FROM restaurents WHERE restaurantId = ?";

    private static final String GET_ALL_RESTAURENTS =
            "SELECT * FROM restaurents";

    private static final String UPDATE_RESTAURENT =
            "UPDATE restaurents SET name = ?, cuisineType = ?, "
          + "deliveryTime = ?, address = ?, adminUserId = ?, "
          + "rating = ?, isActive = ?, imagePath = ? "
          + "WHERE restaurantId = ?";

    private static final String DELETE_RESTAURENT =
            "DELETE FROM restaurents WHERE restaurantId = ?";


    @Override
    public void addRestaurent(Restaurent restaurent) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(ADD_RESTAURENT)) {

            ps.setString(1, restaurent.getName());
            ps.setString(2, restaurent.getCuisineType());
            ps.setString(3, restaurent.getDeliveryTime());
            ps.setString(4, restaurent.getAddress());
            ps.setInt(5, restaurent.getAdminUserId());
            ps.setDouble(6, restaurent.getRating());
            ps.setBoolean(7, restaurent.isActive());
            ps.setString(8, restaurent.getImagePath());

            ps.executeUpdate();

            System.out.println("Restaurant added successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public Restaurent getRestaurent(int restaurantId) {

        Restaurent restaurent = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(GET_RESTAURENT_BY_ID)) {

            ps.setInt(1, restaurantId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    restaurent = new Restaurent();

                    restaurent.setRestaurantId(rs.getInt("restaurantId"));
                    restaurent.setName(rs.getString("name"));
                    restaurent.setCuisineType(rs.getString("cuisineType"));
                    restaurent.setDeliveryTime(rs.getString("deliveryTime"));
                    restaurent.setAddress(rs.getString("address"));
                    restaurent.setAdminUserId(rs.getInt("adminUserId"));
                    restaurent.setRating(rs.getDouble("rating"));
                    restaurent.setActive(rs.getBoolean("isActive"));
                    restaurent.setImagePath(rs.getString("imagePath"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurent;
    }


    @Override
    public List<Restaurent> getAllRestaurents() {

        List<Restaurent> restaurents = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(GET_ALL_RESTAURENTS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Restaurent restaurent = new Restaurent();

                restaurent.setRestaurantId(rs.getInt("restaurantId"));
                restaurent.setName(rs.getString("name"));
                restaurent.setCuisineType(rs.getString("cuisineType"));
                restaurent.setDeliveryTime(rs.getString("deliveryTime"));
                restaurent.setAddress(rs.getString("address"));
                restaurent.setAdminUserId(rs.getInt("adminUserId"));
                restaurent.setRating(rs.getDouble("rating"));
                restaurent.setActive(rs.getBoolean("isActive"));
                restaurent.setImagePath(rs.getString("imagePath"));

                restaurents.add(restaurent);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurents;
    }


    @Override
    public void updateRestaurent(Restaurent restaurent) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_RESTAURENT)) {

            ps.setString(1, restaurent.getName());
            ps.setString(2, restaurent.getCuisineType());
            ps.setString(3, restaurent.getDeliveryTime());
            ps.setString(4, restaurent.getAddress());
            ps.setInt(5, restaurent.getAdminUserId());
            ps.setDouble(6, restaurent.getRating());
            ps.setBoolean(7, restaurent.isActive());
            ps.setString(8, restaurent.getImagePath());
            ps.setInt(9, restaurent.getRestaurantId());

            ps.executeUpdate();

            System.out.println("Restaurant updated successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void deleteRestaurent(int restaurantId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_RESTAURENT)) {

            ps.setInt(1, restaurantId);

            ps.executeUpdate();

            System.out.println("Restaurant deleted successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}