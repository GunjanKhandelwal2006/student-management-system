package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility Class
 * Provides a static method to obtain a connection to the MySQL student_management database.
 */
public class DBConnection {
    
    // Database credentials for XAMPP MySQL
    private static final String URL = "jdbc:mysql://localhost:3306/student_management?useSSL=false";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";
    private static final String DRIVER_CLASS = "com.mysql.jdbc.Driver";

    /**
     * Obtains and returns a new java.sql.Connection to the database.
     * @return Connection object if successful, null otherwise
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Load MySQL JDBC Driver
            Class.forName(DRIVER_CLASS);
            // Establish Connection
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
}
