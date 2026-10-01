package vn.edu.hcmute.bookstore.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order_24110379 {

    private int orderId;
    private int userId;

    private String receiverName;
    private String phone;
    private String address;
    private String note;

    private BigDecimal totalAmount;

    private String paymentMethod;
    private String status;

    private Timestamp createdAt;

    private List<OrderItem_24110379> items =
            new ArrayList<>();

    public Order_24110379() {
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(
            int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(
            int userId) {
        this.userId = userId;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(
            String receiverName) {
        this.receiverName =
                receiverName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(
            String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(
            String address) {
        this.address = address;
    }

    public String getNote() {
        return note;
    }

    public void setNote(
            String note) {
        this.note = note;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(
            BigDecimal totalAmount) {
        this.totalAmount =
                totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(
            String paymentMethod) {
        this.paymentMethod =
                paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(
            String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(
            Timestamp createdAt) {
        this.createdAt =
                createdAt;
    }

    public List<OrderItem_24110379>
            getItems() {
        return items;
    }

    public void setItems(
            List<OrderItem_24110379> items) {
        this.items = items;
    }
}