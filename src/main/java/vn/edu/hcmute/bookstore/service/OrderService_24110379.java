package vn.edu.hcmute.bookstore.service;

import java.util.List;
import java.util.Map;

import vn.edu.hcmute.bookstore.model.CartItem_24110379;
import vn.edu.hcmute.bookstore.model.Order_24110379;

public interface OrderService_24110379 {

    int createCODOrder(
            Order_24110379 order,
            Map<Integer, CartItem_24110379> cart);

    List<Order_24110379> findByUser(
            int userId,
            String status);
}