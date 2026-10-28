package com.tap.test;

import java.util.List;

import com.tap.dao.UserDAO;
import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;

public class UserDAOTest {

    public static void main(String[] args) {

        UserDAO userDAO = new UserDAOImpl();

        // ------------------------------------------------
        // 1. ADD USER
        // ------------------------------------------------

        User user = new User();

        user.setUsername("DAO Test User");
        user.setPassword("test123");
        user.setEmail("daotestuser@gmail.com");
        user.setPhone("9876543210");
        user.setAddress("Bengaluru");
        user.setRole("USER");

        userDAO.addUser(user);

        System.out.println("1. ADD USER COMPLETED");


        // ------------------------------------------------
        // 2. GET USER BY EMAIL
        // ------------------------------------------------

        User addedUser = userDAO.getUser("daotestuser@gmail.com");

        if (addedUser != null) {

            System.out.println("\n2. GET USER BY EMAIL");
            System.out.println("User ID: " + addedUser.getUserId());
            System.out.println("Username: " + addedUser.getUsername());
            System.out.println("Email: " + addedUser.getEmail());

        } else {

            System.out.println("User not found.");
            return;
        }


        // ------------------------------------------------
        // 3. GET USER BY ID
        // ------------------------------------------------

        int userId = addedUser.getUserId();

        User userById = userDAO.getUser(userId);

        System.out.println("\n3. GET USER BY ID");

        if (userById != null) {

            System.out.println("User ID: " + userById.getUserId());
            System.out.println("Username: " + userById.getUsername());
            System.out.println("Email: " + userById.getEmail());

        } else {

            System.out.println("User not found.");
        }


        // ------------------------------------------------
        // 4. GET ALL USERS
        // ------------------------------------------------

        List<User> users = userDAO.getAllUsers();

        System.out.println("\n4. GET ALL USERS");

        for (User u : users) {

            System.out.println(
                    u.getUserId() + " | "
                    + u.getUsername() + " | "
                    + u.getEmail()
            );
        }


        // ------------------------------------------------
        // 5. UPDATE USER
        // ------------------------------------------------

        addedUser.setUsername("Updated DAO User");
        addedUser.setPhone("9999999999");
        addedUser.setAddress("Hyderabad");

        userDAO.updateUser(addedUser);

        System.out.println("\n5. UPDATE USER COMPLETED");


        // ------------------------------------------------
        // VERIFY UPDATE
        // ------------------------------------------------

        User updatedUser = userDAO.getUser(userId);

        System.out.println("\nUpdated User:");

        if (updatedUser != null) {

            System.out.println("User ID: " + updatedUser.getUserId());
            System.out.println("Username: " + updatedUser.getUsername());
            System.out.println("Phone: " + updatedUser.getPhone());
            System.out.println("Address: " + updatedUser.getAddress());

        }


        // ------------------------------------------------
        // 6. DELETE USER
        // ------------------------------------------------

        userDAO.deleteUser(userId);

        System.out.println("\n6. DELETE USER COMPLETED");


        // ------------------------------------------------
        // VERIFY DELETE
        // ------------------------------------------------

        User deletedUser = userDAO.getUser(userId);

        System.out.println("\nDelete Verification:");

        if (deletedUser == null) {

            System.out.println("User deleted successfully.");

        } else {

            System.out.println("User was not deleted.");
        }
    }
}