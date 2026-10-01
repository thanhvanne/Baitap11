package vn.edu.hcmute.bookstore.dao.impl;

import java.sql.*;
import java.util.*;

import vn.edu.hcmute.bookstore.dao.AuthorDAO_24110379;
import vn.edu.hcmute.bookstore.model.Author_24110379;
import vn.edu.hcmute.bookstore.util.DBConnection_24110379;

public class AuthorDAOImpl_24110379 implements AuthorDAO_24110379 {

    @Override
    public List<Author_24110379> findAll() {

        List<Author_24110379> list = new ArrayList<>();

        String sql = "SELECT * FROM author ORDER BY author_name";

        try (Connection con = DBConnection_24110379.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Author_24110379 a = new Author_24110379();

                a.setAuthorId(rs.getInt("author_id"));
                a.setAuthorName(rs.getString("author_name"));
                a.setDateOfBirth(rs.getDate("date_of_birth"));

                list.add(a);
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return list;
    }
}