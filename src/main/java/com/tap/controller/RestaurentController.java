package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.daoimpl.RestaurentDAOImpl;
import com.tap.model.Restaurent;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurent")
public class RestaurentController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("===== RESTAURENT CONTROLLER CALLED =====");

        RestaurentDAOImpl restaurentDao = new RestaurentDAOImpl();

        List<Restaurent> allRestaurents =
                restaurentDao.getAllRestaurents();

        System.out.println("TOTAL RESTAURANTS = " + allRestaurents.size());

        req.setAttribute("restaurent", allRestaurents);

        RequestDispatcher rd =
                req.getRequestDispatcher("restaurent.jsp");

        rd.forward(req, resp);
    }
}