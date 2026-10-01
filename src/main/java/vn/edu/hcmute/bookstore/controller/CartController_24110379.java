package vn.edu.hcmute.bookstore.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.edu.hcmute.bookstore.model.Book_24110379;
import vn.edu.hcmute.bookstore.model.CartItem_24110379;
import vn.edu.hcmute.bookstore.service.BookService_24110379;
import vn.edu.hcmute.bookstore.service.impl.BookServiceImpl_24110379;

@WebServlet("/cart")
public class CartController_24110379
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final BookService_24110379 bookService =
            new BookServiceImpl_24110379();

    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem_24110379> getCart(
            HttpSession session) {

        Map<Integer, CartItem_24110379> cart =
                (Map<Integer, CartItem_24110379>)
                    session.getAttribute("cart");

        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }

        return cart;
    }

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        Map<Integer, CartItem_24110379> cart =
                getCart(req.getSession());

        setCartAttributes(req, cart);

        req.getRequestDispatcher(
                "/WEB-INF/views/cart.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();

        Map<Integer, CartItem_24110379> cart =
                getCart(session);

        String action =
                req.getParameter("action");

        try {
            if ("add".equals(action)) {
                add(req, cart, session);
            } else if ("update".equals(action)) {
                update(req, cart, session);
            } else if ("increase".equals(action)) {
                increase(req, cart, session);
            } else if ("decrease".equals(action)) {
                decrease(req, cart, session);
            } else if ("remove".equals(action)) {
                remove(req, cart);
                session.setAttribute(
                        "cartMessage",
                        "Đã xóa sản phẩm khỏi giỏ hàng.");
            } else if ("clear".equals(action)) {
                cart.clear();
                session.setAttribute(
                        "cartMessage",
                        "Đã xóa toàn bộ giỏ hàng.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute(
                    "cartError",
                    "Dữ liệu giỏ hàng không hợp lệ.");
        }

        resp.sendRedirect(
                req.getContextPath() + "/cart");
    }

    private void add(
            HttpServletRequest req,
            Map<Integer, CartItem_24110379> cart,
            HttpSession session) {

        int bookId =
                Integer.parseInt(
                        req.getParameter("bookId"));

        int requestedQuantity = 1;

        try {
            String quantityParam =
                    req.getParameter("quantity");

            if (quantityParam != null
                    && !quantityParam.isBlank()) {
                requestedQuantity =
                        Integer.parseInt(quantityParam);
            }
        } catch (Exception ignored) {
            requestedQuantity = 1;
        }

        if (requestedQuantity < 1) {
            requestedQuantity = 1;
        }

        Book_24110379 book =
                bookService.findById(bookId);

        if (book == null) {
            session.setAttribute(
                    "cartError",
                    "Sản phẩm không tồn tại.");
            return;
        }

        int stock =
                book.getQuantity() == null
                    ? 0
                    : book.getQuantity();

        if (stock <= 0) {
            session.setAttribute(
                    "cartError",
                    "Sản phẩm đã hết hàng.");
            return;
        }

        CartItem_24110379 current =
                cart.get(bookId);

        int newQuantity =
                requestedQuantity;

        if (current != null) {
            newQuantity =
                    current.getQuantity()
                            + requestedQuantity;
        }

        if (newQuantity > stock) {
            newQuantity = stock;

            session.setAttribute(
                    "cartError",
                    "Số lượng tối đa có thể mua là "
                            + stock + ".");
        } else {
            session.setAttribute(
                    "cartMessage",
                    "Đã thêm sản phẩm vào giỏ hàng.");
        }

        if (current == null) {
            cart.put(
                    bookId,
                    new CartItem_24110379(
                            book,
                            newQuantity));
        } else {
            current.setBook(book);
            current.setQuantity(newQuantity);
        }
    }

    private void update(
            HttpServletRequest req,
            Map<Integer, CartItem_24110379> cart,
            HttpSession session) {

        int bookId =
                Integer.parseInt(
                        req.getParameter("bookId"));

        int quantity =
                Integer.parseInt(
                        req.getParameter("quantity"));

        CartItem_24110379 item =
                cart.get(bookId);

        if (item == null) {
            return;
        }

        Book_24110379 book =
                bookService.findById(bookId);

        if (book == null) {
            cart.remove(bookId);

            session.setAttribute(
                    "cartError",
                    "Sản phẩm không còn tồn tại.");
            return;
        }

        int stock =
                book.getQuantity() == null
                    ? 0
                    : book.getQuantity();

        if (stock <= 0) {
            cart.remove(bookId);

            session.setAttribute(
                    "cartError",
                    "Sản phẩm đã hết hàng và được xóa khỏi giỏ.");
            return;
        }

        if (quantity < 1) {
            quantity = 1;
        }

        if (quantity > stock) {
            quantity = stock;

            session.setAttribute(
                    "cartError",
                    "Số lượng tối đa có thể mua là "
                            + stock + ".");
        } else {
            session.setAttribute(
                    "cartMessage",
                    "Đã cập nhật số lượng.");
        }

        item.setBook(book);
        item.setQuantity(quantity);
    }

    private void increase(
            HttpServletRequest req,
            Map<Integer, CartItem_24110379> cart,
            HttpSession session) {

        int bookId =
                Integer.parseInt(
                        req.getParameter("bookId"));

        CartItem_24110379 item =
                cart.get(bookId);

        if (item == null) {
            return;
        }

        Book_24110379 book =
                bookService.findById(bookId);

        if (book == null) {
            cart.remove(bookId);
            return;
        }

        int stock =
                book.getQuantity() == null
                    ? 0
                    : book.getQuantity();

        if (stock <= 0) {
            cart.remove(bookId);

            session.setAttribute(
                    "cartError",
                    "Sản phẩm đã hết hàng.");
            return;
        }

        if (item.getQuantity() >= stock) {
            item.setQuantity(stock);

            session.setAttribute(
                    "cartError",
                    "Không thể vượt quá tồn kho: "
                            + stock + ".");
            return;
        }

        item.setBook(book);
        item.setQuantity(
                item.getQuantity() + 1);
    }

    private void decrease(
            HttpServletRequest req,
            Map<Integer, CartItem_24110379> cart,
            HttpSession session) {

        int bookId =
                Integer.parseInt(
                        req.getParameter("bookId"));

        CartItem_24110379 item =
                cart.get(bookId);

        if (item == null) {
            return;
        }

        if (item.getQuantity() <= 1) {
            item.setQuantity(1);

            session.setAttribute(
                    "cartError",
                    "Số lượng tối thiểu là 1.");
            return;
        }

        item.setQuantity(
                item.getQuantity() - 1);
    }

    private void remove(
            HttpServletRequest req,
            Map<Integer, CartItem_24110379> cart) {

        int bookId =
                Integer.parseInt(
                        req.getParameter("bookId"));

        cart.remove(bookId);
    }

    private void setCartAttributes(
            HttpServletRequest req,
            Map<Integer, CartItem_24110379> cart) {

        BigDecimal total =
                BigDecimal.ZERO;

        int totalQuantity = 0;

        for (CartItem_24110379 item
                : cart.values()) {

            total =
                    total.add(
                            item.getSubtotal());

            totalQuantity +=
                    item.getQuantity();
        }

        req.setAttribute("cart", cart);
        req.setAttribute(
                "cartTotal",
                total);
        req.setAttribute(
                "cartTotalQuantity",
                totalQuantity);

        HttpSession session =
                req.getSession();

        Object message =
                session.getAttribute(
                        "cartMessage");

        Object error =
                session.getAttribute(
                        "cartError");

        if (message != null) {
            req.setAttribute(
                    "cartMessage",
                    message);
            session.removeAttribute(
                    "cartMessage");
        }

        if (error != null) {
            req.setAttribute(
                    "cartError",
                    error);
            session.removeAttribute(
                    "cartError");
        }
    }
}