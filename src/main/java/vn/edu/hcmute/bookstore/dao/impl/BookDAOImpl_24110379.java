package vn.edu.hcmute.bookstore.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import vn.edu.hcmute.bookstore.dao.BookDAO_24110379;
import vn.edu.hcmute.bookstore.model.Book_24110379;
import vn.edu.hcmute.bookstore.util.DBConnection_24110379;

public class BookDAOImpl_24110379
        implements BookDAO_24110379 {

    /*
     * =========================================================
     * MAP RESULTSET -> BOOK
     * =========================================================
     */
    private Book_24110379 mapBook(
            ResultSet rs)
            throws SQLException {

        Book_24110379 book =
                new Book_24110379();

        book.setBookid(
                rs.getInt("bookid"));

        int isbn =
                rs.getInt("isbn");

        if (rs.wasNull()) {
            book.setIsbn(null);
        } else {
            book.setIsbn(isbn);
        }

        book.setTitle(
                rs.getString("title"));

        book.setPublisher(
                rs.getString("publisher"));

        book.setPrice(
                rs.getBigDecimal("price"));

        book.setDescription(
                rs.getString("description"));

        book.setPublishDate(
                rs.getDate("publish_date"));

        book.setCoverImage(
                rs.getString("cover_image"));

        int quantity =
                rs.getInt("quantity");

        if (rs.wasNull()) {
            book.setQuantity(null);
        } else {
            book.setQuantity(quantity);
        }

        return book;
    }


    /*
     * =========================================================
     * CÂU 3
     * DANH SÁCH BOOK THEO AUTHOR
     * 03 SẢN PHẨM / TRANG
     * =========================================================
     */
    @Override
    public List<Book_24110379> findByAuthor(
            int authorId,
            int page,
            int size) {

        List<Book_24110379> books =
                new ArrayList<>();

        String sql = """
                SELECT
                    b.bookid,
                    b.isbn,
                    b.title,
                    b.publisher,
                    b.price,
                    b.description,
                    b.publish_date,
                    b.cover_image,
                    b.quantity,

                    a.author_id,
                    a.author_name,

                    (
                        SELECT COUNT(*)
                        FROM rating r
                        WHERE r.bookid = b.bookid
                    ) AS review_count

                FROM books b

                INNER JOIN book_author ba
                    ON b.bookid = ba.bookid

                INNER JOIN author a
                    ON ba.author_id = a.author_id

                WHERE a.author_id = ?

                ORDER BY b.bookid

                OFFSET ? ROWS
                FETCH NEXT ? ROWS ONLY
                """;

        try (
                Connection connection =
                        DBConnection_24110379
                                .getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            int offset =
                    (page - 1) * size;

            statement.setInt(
                    1,
                    authorId);

            statement.setInt(
                    2,
                    offset);

            statement.setInt(
                    3,
                    size);

            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                while (rs.next()) {

                    Book_24110379 book =
                            mapBook(rs);

                    book.setAuthorId(
                            rs.getInt(
                                    "author_id"));

                    book.setAuthorName(
                            rs.getString(
                                    "author_name"));

                    book.setReviewCount(
                            rs.getInt(
                                    "review_count"));

                    books.add(book);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            throw new RuntimeException(e);
        }

        return books;
    }


    /*
     * =========================================================
     * ĐẾM BOOK THEO AUTHOR
     * =========================================================
     */
    @Override
    public int countByAuthor(
            int authorId) {

        String sql = """
                SELECT COUNT(*)
                FROM book_author
                WHERE author_id = ?
                """;

        try (
                Connection connection =
                        DBConnection_24110379
                                .getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    authorId);

            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            throw new RuntimeException(e);
        }

        return 0;
    }


    /*
     * =========================================================
     * CÂU 4
     * CHI TIẾT 1 BOOK
     *
     * Không GROUP BY b.description vì description là TEXT.
     *
     * OUTER APPLY:
     * - gom danh sách tác giả
     * - đếm review
     * =========================================================
     */
    @Override
    public Book_24110379 findById(
            int id) {

        String sql = """
                SELECT
                    b.bookid,
                    b.isbn,
                    b.title,
                    b.publisher,
                    b.price,
                    b.description,
                    b.publish_date,
                    b.cover_image,
                    b.quantity,

                    author_data.author_name,

                    (
                        SELECT COUNT(*)
                        FROM rating r
                        WHERE r.bookid = b.bookid
                    ) AS review_count

                FROM books b

                OUTER APPLY
                (
                    SELECT
                        STRING_AGG(
                            a.author_name,
                            ', '
                        ) AS author_name

                    FROM book_author ba

                    INNER JOIN author a
                        ON a.author_id =
                           ba.author_id

                    WHERE ba.bookid =
                          b.bookid
                ) author_data

                WHERE b.bookid = ?
                """;

        try (
                Connection connection =
                        DBConnection_24110379
                                .getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    id);

            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (rs.next()) {

                    Book_24110379 book =
                            mapBook(rs);

                    book.setAuthorName(
                            rs.getString(
                                    "author_name"));

                    book.setReviewCount(
                            rs.getInt(
                                    "review_count"));

                    return book;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            throw new RuntimeException(e);
        }

        return null;
    }


    /*
     * =========================================================
     * CÂU 6
     * DANH SÁCH TẤT CẢ BOOK CHO ADMIN
     * =========================================================
     */
    @Override
    public List<Book_24110379> findAll(
            int page,
            int size) {

        List<Book_24110379> books =
                new ArrayList<>();

        String sql = """
                SELECT
                    bookid,
                    isbn,
                    title,
                    publisher,
                    price,
                    description,
                    publish_date,
                    cover_image,
                    quantity

                FROM books

                ORDER BY bookid

                OFFSET ? ROWS
                FETCH NEXT ? ROWS ONLY
                """;

        try (
                Connection connection =
                        DBConnection_24110379
                                .getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            int offset =
                    (page - 1) * size;

            statement.setInt(
                    1,
                    offset);

            statement.setInt(
                    2,
                    size);

            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                while (rs.next()) {

                    Book_24110379 book =
                            mapBook(rs);

                    books.add(book);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            throw new RuntimeException(e);
        }

        return books;
    }


    /*
     * =========================================================
     * ĐẾM TỔNG BOOK
     * =========================================================
     */
    @Override
    public int countAll() {

        String sql =
                "SELECT COUNT(*) FROM books";

        try (
                Connection connection =
                        DBConnection_24110379
                                .getConnection();

                Statement statement =
                        connection.createStatement();

                ResultSet rs =
                        statement.executeQuery(sql)
        ) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {

            e.printStackTrace();

            throw new RuntimeException(e);
        }

        return 0;
    }


    /*
     * =========================================================
     * CREATE BOOK
     * =========================================================
     */
    @Override
    public void insert(
            Book_24110379 book) {

        String sql = """
                INSERT INTO books
                (
                    isbn,
                    title,
                    publisher,
                    price,
                    description,
                    publish_date,
                    cover_image,
                    quantity
                )
                VALUES
                (
                    ?, ?, ?, ?, ?, ?, ?, ?
                )
                """;

        try (
                Connection connection =
                        DBConnection_24110379
                                .getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            setBookParameters(
                    statement,
                    book);

            statement.executeUpdate();

        } catch (Exception e) {

            e.printStackTrace();

            throw new RuntimeException(e);
        }
    }


    /*
     * =========================================================
     * UPDATE BOOK
     * =========================================================
     */
    @Override
    public void update(
            Book_24110379 book) {

        String sql = """
                UPDATE books

                SET
                    isbn = ?,
                    title = ?,
                    publisher = ?,
                    price = ?,
                    description = ?,
                    publish_date = ?,
                    cover_image = ?,
                    quantity = ?

                WHERE bookid = ?
                """;

        try (
                Connection connection =
                        DBConnection_24110379
                                .getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            setBookParameters(
                    statement,
                    book);

            statement.setInt(
                    9,
                    book.getBookid());

            statement.executeUpdate();

        } catch (Exception e) {

            e.printStackTrace();

            throw new RuntimeException(e);
        }
    }


    /*
     * =========================================================
     * SET THAM SỐ INSERT / UPDATE
     * =========================================================
     */
    private void setBookParameters(
            PreparedStatement statement,
            Book_24110379 book)
            throws SQLException {

        if (book.getIsbn() == null) {

            statement.setNull(
                    1,
                    java.sql.Types.INTEGER);

        } else {

            statement.setInt(
                    1,
                    book.getIsbn());
        }

        statement.setString(
                2,
                book.getTitle());

        statement.setString(
                3,
                book.getPublisher());

        statement.setBigDecimal(
                4,
                book.getPrice());

        statement.setString(
                5,
                book.getDescription());

        statement.setDate(
                6,
                book.getPublishDate());

        statement.setString(
                7,
                book.getCoverImage());

        if (book.getQuantity() == null) {

            statement.setNull(
                    8,
                    java.sql.Types.INTEGER);

        } else {

            statement.setInt(
                    8,
                    book.getQuantity());
        }
    }


    /*
     * =========================================================
     * DELETE BOOK
     * =========================================================
     */
    @Override
    public void delete(
            int id) {

        String sql = """
                DELETE FROM books
                WHERE bookid = ?
                """;

        try (
                Connection connection =
                        DBConnection_24110379
                                .getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    id);

            statement.executeUpdate();

        } catch (Exception e) {

            e.printStackTrace();

            throw new RuntimeException(e);
        }
    }
}