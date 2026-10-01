package vn.edu.hcmute.bookstore.service.impl;

import java.util.List;
import java.util.Map;

import vn.edu.hcmute.bookstore.dao.OrderDAO_24110379;
import vn.edu.hcmute.bookstore.dao.impl.OrderDAOImpl_24110379;
import vn.edu.hcmute.bookstore.model.CartItem_24110379;
import vn.edu.hcmute.bookstore.model.Order_24110379;
import vn.edu.hcmute.bookstore.service.OrderService_24110379;

public class OrderServiceImpl_24110379
        implements OrderService_24110379 {

    private final OrderDAO_24110379 dao =
            new OrderDAOImpl_24110379();

    @Override
    public int createCODOrder(
            Order_24110379 order,
            Map<Integer, CartItem_24110379> cart) {

        if (order == null) {

            throw new IllegalArgumentException(
                    "Thông tin đơn hàng không hợp lệ.");
        }

        if (order.getReceiverName() == null
                || order.getReceiverName()
                        .isBlank()) {

            throw new IllegalArgumentException(
                    "Vui lòng nhập tên người nhận.");
        }

        if (order.getPhone() == null
                || order.getPhone()
                        .isBlank()) {

            throw new IllegalArgumentException(
                    "Vui lòng nhập số điện thoại.");
        }

        if (order.getAddress() == null
                || order.getAddress()
                        .isBlank()) {

            throw new IllegalArgumentException(
                    "Vui lòng nhập địa chỉ nhận hàng.");
        }

        if (cart == null
                || cart.isEmpty()) {

            throw new IllegalArgumentException(
                    "Giỏ hàng đang trống.");
        }

        return dao.createCODOrder(
                order,
                cart);
    }

    @Override
    public List<Order_24110379> findByUser(
            int userId,
            String status) {

        return dao.findByUser(
                userId,
                status);
    }
}