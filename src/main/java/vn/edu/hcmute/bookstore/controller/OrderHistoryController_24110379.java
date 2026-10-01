package vn.edu.hcmute.bookstore.controller;

import java.io.IOException;
import java.util.Set;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.edu.hcmute.bookstore.model.User_24110379;
import vn.edu.hcmute.bookstore.service.OrderService_24110379;
import vn.edu.hcmute.bookstore.service.impl.OrderServiceImpl_24110379;

@WebServlet("/orders/history")
public class OrderHistoryController_24110379
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * 8 trạng thái đúng theo yêu cầu đề bài.
     */
    private static final Set<String>
            VALID_STATUSES =
            Set.of(
                "NEW",
                "CONFIRMED",
                "PREPARING",
                "SHIPPING",
                "DELIVERING",
                "DELIVERED",
                "CANCELLED",
                "RETURNED"
            );

    private final OrderService_24110379
            orderService =
            new OrderServiceImpl_24110379();

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding(
                "UTF-8");

        resp.setCharacterEncoding(
                "UTF-8");

        User_24110379 user =
                (User_24110379)
                    req.getSession()
                       .getAttribute("user");

        /*
         * UserFilter đã kiểm tra,
         * controller vẫn kiểm tra lại.
         */
        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login");

            return;
        }

        /*
         * Admin không được sử dụng
         * lịch sử mua hàng của User.
         */
        if (user.isAdmin()) {

            resp.sendError(
                    HttpServletResponse
                        .SC_FORBIDDEN);

            return;
        }

        String status =
                req.getParameter(
                        "status");

        if (status != null) {

            status =
                status.trim()
                      .toUpperCase();

            /*
             * Không chấp nhận trạng thái
             * ngoài 8 trạng thái quy định.
             */
            if (!VALID_STATUSES
                    .contains(status)) {

                status = null;
            }
        }

        req.setAttribute(
                "selectedStatus",
                status);

        req.setAttribute(
                "orders",
                orderService.findByUser(
                        user.getId(),
                        status));

        req.getRequestDispatcher(
                "/WEB-INF/views/order-history.jsp")
                .forward(req, resp);
    }
}