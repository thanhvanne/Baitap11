package vn.edu.hcmute.bookstore.dao.impl;

import java.sql.*;

import vn.edu.hcmute.bookstore.dao.UserDAO_24110379;
import vn.edu.hcmute.bookstore.model.User_24110379;
import vn.edu.hcmute.bookstore.util.DBConnection_24110379;

public class UserDAOImpl_24110379 implements UserDAO_24110379 {

    @Override
    public User_24110379 login(String email, String password) {

        String sql =
                "SELECT * FROM users WHERE email=? AND passwd=?";

        try (Connection con = DBConnection_24110379.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                User_24110379 u = new User_24110379();

                u.setId(rs.getInt("id"));
                u.setEmail(rs.getString("email"));
                u.setFullname(rs.getString("fullname"));
                u.setPhone((Integer) rs.getObject("phone"));
                u.setPasswd(rs.getString("passwd"));
                u.setSignupDate(rs.getTimestamp("signup_date"));
                u.setLastLogin(rs.getTimestamp("last_login"));
                u.setAdmin(rs.getBoolean("is_admin"));

                return u;
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return null;
    }

    @Override
    public boolean existsByEmail(String email) {

        String sql = "SELECT 1 FROM users WHERE email=?";

        try (Connection con = DBConnection_24110379.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            return ps.executeQuery().next();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void insert(User_24110379 user) {

        String sql = """
            INSERT INTO users
            (email,fullname,phone,passwd,signup_date,is_admin)
            VALUES(?,?,?,?,GETDATE(),0)
            """;

        try (Connection con = DBConnection_24110379.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getFullname());

            if (user.getPhone() == null)
                ps.setNull(3, Types.INTEGER);
            else
                ps.setInt(3, user.getPhone());

            ps.setString(4, user.getPasswd());

            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void updateLastLogin(int id) {

        try (Connection con = DBConnection_24110379.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE users SET last_login=GETDATE() WHERE id=?")) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}