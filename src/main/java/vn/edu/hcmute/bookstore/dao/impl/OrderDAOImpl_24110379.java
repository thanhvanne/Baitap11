package vn.edu.hcmute.bookstore.dao.impl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import vn.edu.hcmute.bookstore.dao.OrderDAO_24110379;
import vn.edu.hcmute.bookstore.model.CartItem_24110379;
import vn.edu.hcmute.bookstore.model.OrderItem_24110379;
import vn.edu.hcmute.bookstore.model.Order_24110379;
import vn.edu.hcmute.bookstore.util.DBConnection_24110379;

public class OrderDAOImpl_24110379
        implements OrderDAO_24110379 {

    private static class CheckoutBook {

        private int bookId;

        private String title;

        private int stock;

        private BigDecimal price;

        private int quantity;
    }

    @Override
    public int createCODOrder(
            Order_24110379 order,
            Map<Integer, CartItem_24110379> cart) {

        if (cart == null || cart.isEmpty()) {

            throw new IllegalArgumentException(
                    "Giỏ hàng đang trống.");
        }

        Connection con = null;

        try {

            con =
                DBConnection_24110379
                    .getConnection();

            con.setAutoCommit(false);

            Map<Integer, CheckoutBook> checkoutBooks =
                    new LinkedHashMap<>();

            BigDecimal total =
                    BigDecimal.ZERO;

            /*
             * Khóa các dòng sách trong quá trình
             * checkout để tránh hai người cùng mua
             * vượt quá số lượng tồn kho.
             */
            String lockBookSql = """
                SELECT
                    bookid,
                    title,
                    price,
                    quantity
                FROM books WITH (UPDLOCK, HOLDLOCK)
                WHERE bookid = ?
                """;

            try (PreparedStatement ps =
                    con.prepareStatement(
                            lockBookSql)) {

                for (CartItem_24110379 cartItem
                        : cart.values()) {

                    if (cartItem == null
                            || cartItem.getBook() == null) {

                        throw new IllegalStateException(
                                "Dữ liệu giỏ hàng không hợp lệ.");
                    }

                    int bookId =
                            cartItem
                                .getBook()
                                .getBookid();

                    int buyQuantity =
                            cartItem
                                .getQuantity();

                    if (buyQuantity < 1) {

                        throw new IllegalStateException(
                                "Số lượng sản phẩm không hợp lệ.");
                    }

                    ps.setInt(
                            1,
                            bookId);

                    try (ResultSet rs =
                            ps.executeQuery()) {

                        if (!rs.next()) {

                            throw new IllegalStateException(
                                    "Sản phẩm ID "
                                    + bookId
                                    + " không còn tồn tại.");
                        }

                        CheckoutBook book =
                                new CheckoutBook();

                        book.bookId =
                                rs.getInt(
                                        "bookid");

                        book.title =
                                rs.getString(
                                        "title");

                        book.price =
                                rs.getBigDecimal(
                                        "price");

                        book.stock =
                                rs.getInt(
                                        "quantity");

                        if (rs.wasNull()) {
                            book.stock = 0;
                        }

                        book.quantity =
                                buyQuantity;

                        if (book.price == null) {

                            throw new IllegalStateException(
                                    "Sản phẩm \""
                                    + book.title
                                    + "\" chưa có giá hợp lệ.");
                        }

                        if (book.stock
                                < buyQuantity) {

                            throw new IllegalStateException(
                                    "Sản phẩm \""
                                    + book.title
                                    + "\" chỉ còn "
                                    + book.stock
                                    + " sản phẩm.");
                        }

                        total =
                            total.add(
                                book.price.multiply(
                                    BigDecimal.valueOf(
                                            buyQuantity)));

                        checkoutBooks.put(
                                book.bookId,
                                book);
                    }
                }
            }

            /*
             * Đơn COD vừa được user tạo luôn có
             * trạng thái NEW = Đơn hàng mới.
             */
            String insertOrderSql = """
                INSERT INTO orders
                (
                    userid,
                    receiver_name,
                    phone,
                    address,
                    note,
                    total_amount,
                    payment_method,
                    status,
                    created_at
                )
                VALUES
                (
                    ?, ?, ?, ?, ?, ?,
                    'COD',
                    'NEW',
                    GETDATE()
                )
                """;

            int orderId;

            try (PreparedStatement ps =
                    con.prepareStatement(
                            insertOrderSql,
                            Statement
                                .RETURN_GENERATED_KEYS)) {

                ps.setInt(
                        1,
                        order.getUserId());

                ps.setString(
                        2,
                        order.getReceiverName());

                ps.setString(
                        3,
                        order.getPhone());

                ps.setString(
                        4,
                        order.getAddress());

                ps.setString(
                        5,
                        order.getNote());

                ps.setBigDecimal(
                        6,
                        total);

                ps.executeUpdate();

                try (ResultSet rs =
                        ps.getGeneratedKeys()) {

                    if (!rs.next()) {

                        throw new IllegalStateException(
                                "Không tạo được đơn hàng.");
                    }

                    orderId =
                            rs.getInt(1);
                }
            }

            String insertDetailSql = """
                INSERT INTO order_details
                (
                    order_id,
                    bookid,
                    quantity,
                    unit_price
                )
                VALUES (?, ?, ?, ?)
                """;

            String updateStockSql = """
                UPDATE books
                SET quantity = quantity - ?
                WHERE bookid = ?
                  AND quantity >= ?
                """;

            try (
                PreparedStatement detailPs =
                    con.prepareStatement(
                            insertDetailSql);

                PreparedStatement stockPs =
                    con.prepareStatement(
                            updateStockSql)
            ) {

                for (CheckoutBook book
                        : checkoutBooks.values()) {

                    detailPs.setInt(
                            1,
                            orderId);

                    detailPs.setInt(
                            2,
                            book.bookId);

                    detailPs.setInt(
                            3,
                            book.quantity);

                    detailPs.setBigDecimal(
                            4,
                            book.price);

                    detailPs.executeUpdate();

                    stockPs.setInt(
                            1,
                            book.quantity);

                    stockPs.setInt(
                            2,
                            book.bookId);

                    stockPs.setInt(
                            3,
                            book.quantity);

                    int updated =
                            stockPs.executeUpdate();

                    if (updated != 1) {

                        throw new IllegalStateException(
                                "Tồn kho sản phẩm \""
                                + book.title
                                + "\" đã thay đổi. "
                                + "Vui lòng kiểm tra lại giỏ hàng.");
                    }
                }
            }

            con.commit();

            order.setOrderId(
                    orderId);

            order.setTotalAmount(
                    total);

            order.setPaymentMethod(
                    "COD");

            order.setStatus(
                    "NEW");

            return orderId;

        } catch (Exception e) {

            if (con != null) {

                try {
                    con.rollback();
                } catch (Exception ignored) {
                }
            }

            if (e instanceof
                    IllegalArgumentException) {

                throw (IllegalArgumentException) e;
            }

            if (e instanceof
                    IllegalStateException) {

                throw (IllegalStateException) e;
            }

            throw new RuntimeException(e);

        } finally {

            if (con != null) {

                try {
                    con.setAutoCommit(true);
                } catch (Exception ignored) {
                }

                try {
                    con.close();
                } catch (Exception ignored) {
                }
            }
        }
    }

    @Override
    public List<Order_24110379> findByUser(
            int userId,
            String status) {

        List<Order_24110379> orders =
                new ArrayList<>();

        boolean filterStatus =
                status != null
                && !status.isBlank();

        String orderSql;

        if (filterStatus) {

            orderSql = """
                SELECT
                    order_id,
                    userid,
                    receiver_name,
                    phone,
                    address,
                    note,
                    total_amount,
                    payment_method,
                    status,
                    created_at
                FROM orders
                WHERE userid = ?
                  AND status = ?
                ORDER BY
                    created_at DESC,
                    order_id DESC
                """;

        } else {

            orderSql = """
                SELECT
                    order_id,
                    userid,
                    receiver_name,
                    phone,
                    address,
                    note,
                    total_amount,
                    payment_method,
                    status,
                    created_at
                FROM orders
                WHERE userid = ?
                ORDER BY
                    created_at DESC,
                    order_id DESC
                """;
        }

        String detailSql = """
            SELECT
                od.bookid,
                b.title,
                od.quantity,
                od.unit_price
            FROM order_details od
            INNER JOIN books b
                ON od.bookid = b.bookid
            WHERE od.order_id = ?
            ORDER BY od.order_detail_id
            """;

        try (
            Connection con =
                DBConnection_24110379
                    .getConnection();

            PreparedStatement orderPs =
                con.prepareStatement(
                        orderSql);

            PreparedStatement detailPs =
                con.prepareStatement(
                        detailSql)
        ) {

            orderPs.setInt(
                    1,
                    userId);

            if (filterStatus) {

                orderPs.setString(
                        2,
                        status);
            }

            try (ResultSet rs =
                    orderPs.executeQuery()) {

                while (rs.next()) {

                    Order_24110379 order =
                            new Order_24110379();

                    order.setOrderId(
                            rs.getInt(
                                    "order_id"));

                    order.setUserId(
                            rs.getInt(
                                    "userid"));

                    order.setReceiverName(
                            rs.getString(
                                    "receiver_name"));

                    order.setPhone(
                            rs.getString(
                                    "phone"));

                    order.setAddress(
                            rs.getString(
                                    "address"));

                    order.setNote(
                            rs.getString(
                                    "note"));

                    order.setTotalAmount(
                            rs.getBigDecimal(
                                    "total_amount"));

                    order.setPaymentMethod(
                            rs.getString(
                                    "payment_method"));

                    order.setStatus(
                            rs.getString(
                                    "status"));

                    order.setCreatedAt(
                            rs.getTimestamp(
                                    "created_at"));

                    List<OrderItem_24110379>
                            items =
                            new ArrayList<>();

                    detailPs.setInt(
                            1,
                            order.getOrderId());

                    try (ResultSet itemRs =
                            detailPs.executeQuery()) {

                        while (itemRs.next()) {

                            OrderItem_24110379 item =
                                new OrderItem_24110379();

                            item.setBookId(
                                    itemRs.getInt(
                                            "bookid"));

                            item.setBookTitle(
                                    itemRs.getString(
                                            "title"));

                            item.setQuantity(
                                    itemRs.getInt(
                                            "quantity"));

                            item.setUnitPrice(
                                    itemRs.getBigDecimal(
                                            "unit_price"));

                            items.add(item);
                        }
                    }

                    order.setItems(
                            items);

                    orders.add(
                            order);
                }
            }

        } catch (Exception e) {

            throw new RuntimeException(e);
        }

        return orders;
    }
}