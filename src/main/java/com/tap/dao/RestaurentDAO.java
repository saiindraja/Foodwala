package com.tap.dao;

import java.util.List;
import com.tap.model.Restaurent;

public interface RestaurentDAO {

    void addRestaurent(Restaurent restaurent);

    Restaurent getRestaurent(int restaurantId);

    List<Restaurent> getAllRestaurents();

    void updateRestaurent(Restaurent restaurent);

    void deleteRestaurent(int restaurantId);
}
