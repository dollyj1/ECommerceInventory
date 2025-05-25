package com.inventory.ecommerceinventory;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String URL = "jdbc:mysql://shinkansen.proxy.rlwy.net:44212/railway"; // Railway host + port + DB name
    private static final String USER = "root"; // Railway username
    private static final String PASSWORD = "lvyMsvmHqNHhIoMVkjjpgnQASLhRsJnj"; // Your actual password

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
