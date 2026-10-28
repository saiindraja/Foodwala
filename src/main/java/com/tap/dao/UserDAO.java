package com.tap.dao;

import java.util.List;
import com.tap.model.User;

public interface UserDAO {

    void addUser(User user);

    User getUser(int userId);

    User getUser(String email);

    List<User> getAllUsers();

    void updateUser(User user);

    void deleteUser(int userId);
}
