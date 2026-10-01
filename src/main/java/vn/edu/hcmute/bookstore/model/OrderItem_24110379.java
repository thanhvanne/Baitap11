package vn.edu.hcmute.bookstore.model;

import java.math.BigDecimal;

public class OrderItem_24110379 {

    private int bookId;
    private String bookTitle;
    private int quantity;
    private BigDecimal unitPrice;

    public OrderItem_24110379() {
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(
            String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(
            int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(
            BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getSubtotal() {

        if (unitPrice == null) {
            return BigDecimal.ZERO;
        }

        return unitPrice.multiply(
                BigDecimal.valueOf(
                        quantity));
    }
}