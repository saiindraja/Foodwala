
package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.MenuDAO;
import com.tap.model.Menu;
import com.tap.util.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    private static final String ADD_MENU =
            "INSERT INTO menu "
          + "(restaurantId, itemName, description, price, imagePath, isAvailable) "
          + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String GET_MENU_BY_ID =
            "SELECT * FROM menu WHERE menuId = ?";

    private static final String GET_ALL_MENUS =
            "SELECT * FROM menu";

    private static final String GET_ALL_MENU_BY_RESTAURANT_ID =
            "SELECT * FROM menu WHERE restaurantId = ?";

    private static final String UPDATE_MENU =
            "UPDATE menu SET restaurantId = ?, itemName = ?, "
          + "description = ?, price = ?, imagePath = ?, "
          + "isAvailable = ? WHERE menuId = ?";

    private static final String DELETE_MENU =
            "DELETE FROM menu WHERE menuId = ?";


    @Override
    public void addMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(ADD_MENU)) {

            ps.setInt(1, menu.getRestaurantId());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setDouble(4, menu.getPrice());
            ps.setString(5, menu.getImagePath());
            ps.setBoolean(6, menu.isAvailable());

            ps.executeUpdate();

            System.out.println("Menu added successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public Menu getMenu(int menuId) {

        Menu menu = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(GET_MENU_BY_ID)) {

            ps.setInt(1, menuId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    menu = new Menu();

                    menu.setMenuId(rs.getInt("menuId"));
                    menu.setRestaurantId(rs.getInt("restaurantId"));
                    menu.setItemName(rs.getString("itemName"));
                    menu.setDescription(rs.getString("description"));
                    menu.setPrice(rs.getDouble("price"));
                    menu.setImagePath(rs.getString("imagePath"));
                    menu.setAvailable(rs.getBoolean("isAvailable"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }


    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menus = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(GET_ALL_MENUS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Menu menu = new Menu();

                menu.setMenuId(rs.getInt("menuId"));
                menu.setRestaurantId(rs.getInt("restaurantId"));
                menu.setItemName(rs.getString("itemName"));
                menu.setDescription(rs.getString("description"));
                menu.setPrice(rs.getDouble("price"));
                menu.setImagePath(rs.getString("imagePath"));
                menu.setAvailable(rs.getBoolean("isAvailable"));

                menus.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }


    @Override
    public List<Menu> getAllMenuByRestaurantId(int restaurantId) {

        List<Menu> menus = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(
                             GET_ALL_MENU_BY_RESTAURANT_ID)) {

            ps.setInt(1, restaurantId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Menu menu = new Menu();

                    menu.setMenuId(rs.getInt("menuId"));
                    menu.setRestaurantId(rs.getInt("restaurantId"));
                    menu.setItemName(rs.getString("itemName"));
                    menu.setDescription(rs.getString("description"));
                    menu.setPrice(rs.getDouble("price"));
                    menu.setImagePath(rs.getString("imagePath"));
                    menu.setAvailable(rs.getBoolean("isAvailable"));

                    menus.add(menu);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }


    @Override
    public void updateMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(UPDATE_MENU)) {

            ps.setInt(1, menu.getRestaurantId());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setDouble(4, menu.getPrice());
            ps.setString(5, menu.getImagePath());
            ps.setBoolean(6, menu.isAvailable());
            ps.setInt(7, menu.getMenuId());

            ps.executeUpdate();

            System.out.println("Menu updated successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void deleteMenu(int menuId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(DELETE_MENU)) {

            ps.setInt(1, menuId);

            ps.executeUpdate();

            System.out.println("Menu deleted successfully.");
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

