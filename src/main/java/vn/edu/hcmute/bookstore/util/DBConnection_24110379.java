package vn.edu.hcmute.bookstore.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBConnection_24110379 {

    private static String url;
    private static String username;
    private static String password;

    static {
        try {
            Properties p = new Properties();

            InputStream input = DBConnection_24110379.class
                    .getClassLoader()
                    .getResourceAsStream("db.properties");

            p.load(input);

            String driver = p.getProperty("db.driver");
            url = p.getProperty("db.url");
            username = p.getProperty("db.username");
            password = p.getProperty("db.password");

            Class.forName(driver);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(url, username, password);
    }
}