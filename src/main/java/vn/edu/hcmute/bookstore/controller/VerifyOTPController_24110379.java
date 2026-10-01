package vn.edu.hcmute.bookstore.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.hcmute.bookstore.model.User_24110379;
import vn.edu.hcmute.bookstore.service.UserService_24110379;
import vn.edu.hcmute.bookstore.service.impl.UserServiceImpl_24110379;

@WebServlet("/verify-otp")
public class VerifyOTPController_24110379 extends HttpServlet {

    private final UserService_24110379 service =
            new UserServiceImpl_24110379();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher(
                "/WEB-INF/views/auth/verify-otp.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        String expected =
                (String) session.getAttribute("otp");

        Long expires =
                (Long) session.getAttribute("otpExpires");

        User_24110379 user =
                (User_24110379)
                        session.getAttribute("pendingUser");

        if (expected == null || expires == null || user == null) {
            resp.sendRedirect(
                    req.getContextPath() + "/register");
            return;
        }

        if (System.currentTimeMillis() > expires) {
            req.setAttribute("error", "OTP đã hết hạn.");
            doGet(req, resp);
            return;
        }

        if (!expected.equals(req.getParameter("otp"))) {
            req.setAttribute("error", "OTP không chính xác.");
            doGet(req, resp);
            return;
        }

        service.register(user);

        session.removeAttribute("pendingUser");
        session.removeAttribute("otp");
        session.removeAttribute("otpExpires");

        resp.sendRedirect(
                req.getContextPath()
                + "/login?registered=1");
    }
}