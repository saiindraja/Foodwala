
package com.tap.dao;

import java.util.List;
import com.tap.model.Menu;

public interface MenuDAO {

    void addMenu(Menu menu);

    Menu getMenu(int menuId);

    List<Menu> getAllMenus();

    // Get all menu items belonging to one restaurant
    List<Menu> getAllMenuByRestaurantId(int restaurantId);

    void updateMenu(Menu menu);

    void deleteMenu(int menuId);
}

