package vn.edu.hcmute.bookstore.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.edu.hcmute.bookstore.model.CartItem_24110379;
import vn.edu.hcmute.bookstore.model.Order_24110379;
import vn.edu.hcmute.bookstore.model.User_24110379;
import vn.edu.hcmute.bookstore.service.OrderService_24110379;
import vn.edu.hcmute.bookstore.service.impl.OrderServiceImpl_24110379;

@WebServlet("/checkout")
public class CheckoutController_24110379
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final OrderService_24110379 orderService =
            new OrderServiceImpl_24110379();

    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem_24110379> getCart(
            HttpSession session) {

        return (Map<Integer, CartItem_24110379>)
                session.getAttribute("cart");
    }

    private User_24110379 getUser(
            HttpServletRequest req) {

        return (User_24110379)
                req.getSession()
                    .getAttribute("user");
    }

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        User_24110379 user =
                getUser(req);

        if (user == null) {
            resp.sendRedirect(
                    req.getContextPath()
                    + "/login");
            return;
        }

        Map<Integer, CartItem_24110379> cart =
                getCart(req.getSession());

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(
                    req.getContextPath()
                    + "/cart");
            return;
        }

        setCheckoutAttributes(
                req,
                user,
                cart);

        req.getRequestDispatcher(
                "/WEB-INF/views/checkout.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        User_24110379 user =
                getUser(req);

        if (user == null) {
            resp.sendRedirect(
                    req.getContextPath()
                    + "/login");
            return;
        }

        HttpSession session =
                req.getSession();

        Map<Integer, CartItem_24110379> cart =
                getCart(session);

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(
                    req.getContextPath()
                    + "/cart");
            return;
        }

        String receiverName =
                trim(req.getParameter(
                        "receiverName"));

        String phone =
                trim(req.getParameter(
                        "phone"));

        String address =
                trim(req.getParameter(
                        "address"));

        String note =
                trim(req.getParameter(
                        "note"));

        req.setAttribute(
                "receiverName",
                receiverName);

        req.setAttribute(
                "phone",
                phone);

        req.setAttribute(
                "address",
                address);

        req.setAttribute(
                "note",
                note);

        if (receiverName.isBlank()
                || phone.isBlank()
                || address.isBlank()) {

            req.setAttribute(
                    "error",
                    "Vui lòng nhập đầy đủ tên người nhận, "
                    + "số điện thoại và địa chỉ.");

            setCheckoutAttributes(
                    req,
                    user,
                    cart);

            req.getRequestDispatcher(
                    "/WEB-INF/views/checkout.jsp")
                    .forward(req, resp);

            return;
        }

        if (!phone.matches(
                "^[0-9+][0-9\\s.-]{7,19}$")) {

            req.setAttribute(
                    "error",
                    "Số điện thoại không hợp lệ.");

            setCheckoutAttributes(
                    req,
                    user,
                    cart);

            req.getRequestDispatcher(
                    "/WEB-INF/views/checkout.jsp")
                    .forward(req, resp);

            return;
        }

        Order_24110379 order =
                new Order_24110379();

        order.setUserId(
                user.getId());

        order.setReceiverName(
                receiverName);

        order.setPhone(
                phone);

        order.setAddress(
                address);

        order.setNote(
                note);

        order.setPaymentMethod(
                "COD");

        try {
            int orderId =
                    orderService.createCODOrder(
                            order,
                            cart);

            session.removeAttribute("cart");

            session.setAttribute(
                    "lastOrderId",
                    orderId);

            resp.sendRedirect(
                    req.getContextPath()
                    + "/checkout?success=1");

        } catch (IllegalArgumentException
                | IllegalStateException e) {

            req.setAttribute(
                    "error",
                    e.getMessage());

            setCheckoutAttributes(
                    req,
                    user,
                    cart);

            req.getRequestDispatcher(
                    "/WEB-INF/views/checkout.jsp")
                    .forward(req, resp);

        } catch (Exception e) {

            req.setAttribute(
                    "error",
                    "Không thể tạo đơn hàng. "
                    + "Vui lòng thử lại.");

            setCheckoutAttributes(
                    req,
                    user,
                    cart);

            req.getRequestDispatcher(
                    "/WEB-INF/views/checkout.jsp")
                    .forward(req, resp);
        }
    }

    private void setCheckoutAttributes(
            HttpServletRequest req,
            User_24110379 user,
            Map<Integer, CartItem_24110379> cart) {

        BigDecimal total =
                BigDecimal.ZERO;

        for (CartItem_24110379 item
                : cart.values()) {
            total =
                    total.add(
                            item.getSubtotal());
        }

        req.setAttribute(
                "cart",
                cart);

        req.setAttribute(
                "cartTotal",
                total);

        if (req.getAttribute(
                "receiverName") == null) {

            req.setAttribute(
                    "receiverName",
                    user.getFullname());
        }

        if (req.getAttribute(
                "phone") == null) {

            req.setAttribute(
                    "phone",
                    user.getPhone() == null
                        ? ""
                        : String.valueOf(
                                user.getPhone()));
        }
    }

    private String trim(String value) {
        return value == null
                ? ""
                : value.trim();
    }

    @Override
    protected void service(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        if ("GET".equalsIgnoreCase(
                req.getMethod())
                && "1".equals(
                    req.getParameter("success"))) {

            User_24110379 user =
                    getUser(req);

            if (user == null) {
                resp.sendRedirect(
                        req.getContextPath()
                        + "/login");
                return;
            }

            Object orderId =
                    req.getSession()
                        .getAttribute(
                            "lastOrderId");

            if (orderId == null) {
                resp.sendRedirect(
                        req.getContextPath()
                        + "/home");
                return;
            }

            req.setAttribute(
                    "orderId",
                    orderId);

            req.getSession()
                .removeAttribute(
                    "lastOrderId");

            req.getRequestDispatcher(
                    "/WEB-INF/views/order-success.jsp")
                    .forward(req, resp);

            return;
        }

        super.service(req, resp);
    }
}