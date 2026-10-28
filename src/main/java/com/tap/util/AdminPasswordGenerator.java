
package com.tap.util;

import org.mindrot.jbcrypt.BCrypt;

public class AdminPasswordGenerator {

    public static void main(String[] args) {

        String password = "FoodwalaAdmin@2026";

        String hashedPassword = BCrypt.hashpw(
                password,
                BCrypt.gensalt(12)
        );

        System.out.println("Admin password hash:");
        System.out.println(hashedPassword);
    }
}
