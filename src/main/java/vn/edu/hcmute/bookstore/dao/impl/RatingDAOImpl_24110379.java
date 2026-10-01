package vn.edu.hcmute.bookstore.dao.impl;

import java.sql.*;
import java.util.*;

import vn.edu.hcmute.bookstore.dao.RatingDAO_24110379;
import vn.edu.hcmute.bookstore.model.Rating_24110379;
import vn.edu.hcmute.bookstore.util.DBConnection_24110379;

public class RatingDAOImpl_24110379 implements RatingDAO_24110379 {

    @Override
    public List<Rating_24110379> findByBook(int bookId) {

        List<Rating_24110379> list = new ArrayList<>();

        String sql = """
            SELECT r.*, u.fullname
            FROM rating r
            JOIN users u ON r.userid=u.id
            WHERE r.bookid=?
            """;

        try (Connection con = DBConnection_24110379.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Rating_24110379 r = new Rating_24110379();

                r.setUserId(rs.getInt("userid"));
                r.setBookId(rs.getInt("bookid"));
                r.setRating(rs.getInt("rating"));
                r.setReviewText(rs.getString("review_text"));
                r.setFullname(rs.getString("fullname"));

                list.add(r);
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return list;
    }

    @Override
    public void save(Rating_24110379 r) {

        String sql = """
            MERGE rating AS target
            USING (SELECT ? userid, ? bookid) AS source
            ON target.userid=source.userid
            AND target.bookid=source.bookid

            WHEN MATCHED THEN
                UPDATE SET rating=?, review_text=?

            WHEN NOT MATCHED THEN
                INSERT(userid,bookid,rating,review_text)
                VALUES(?,?,?,?);
            """;

        try (Connection con = DBConnection_24110379.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, r.getUserId());
            ps.setInt(2, r.getBookId());

            ps.setInt(3, r.getRating());
            ps.setString(4, r.getReviewText());

            ps.setInt(5, r.getUserId());
            ps.setInt(6, r.getBookId());
            ps.setInt(7, r.getRating());
            ps.setString(8, r.getReviewText());

            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}