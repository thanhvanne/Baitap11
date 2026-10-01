package vn.edu.hcmute.bookstore.controller;

import java.io.IOException;
import java.security.SecureRandom;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.hcmute.bookstore.model.User_24110379;
import vn.edu.hcmute.bookstore.service.UserService_24110379;
import vn.edu.hcmute.bookstore.service.impl.UserServiceImpl_24110379;
import vn.edu.hcmute.bookstore.util.MailUtil_24110379;

@WebServlet("/register")
public class RegisterController_24110379 extends HttpServlet {

    private final UserService_24110379 service =
            new UserServiceImpl_24110379();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher(
                "/WEB-INF/views/auth/register.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");

        if (service.existsByEmail(email)) {
            req.setAttribute("error",
                    "Email đã tồn tại.");
            doGet(req, resp);
            return;
        }

        User_24110379 user = new User_24110379();

        user.setEmail(email);
        user.setFullname(req.getParameter("fullname"));

        try {
            user.setPhone(Integer.parseInt(
                    req.getParameter("phone")));
        } catch (Exception e) {
            user.setPhone(null);
        }

        user.setPasswd(req.getParameter("password"));

        String otp = String.format(
                "%06d",
                new SecureRandom().nextInt(1_000_000));

        HttpSession session = req.getSession();

        session.setAttribute("pendingUser", user);
        session.setAttribute("otp", otp);
        session.setAttribute("otpExpires",
                System.currentTimeMillis() + 5 * 60 * 1000);

        try {
            MailUtil_24110379.sendOTP(email, otp);

            resp.sendRedirect(
                    req.getContextPath() + "/verify-otp");

        } catch (Exception e) {

            session.removeAttribute("pendingUser");
            session.removeAttribute("otp");
            session.removeAttribute("otpExpires");

            req.setAttribute("error",
                    "Không gửi được OTP: " + e.getMessage());

            doGet(req, resp);
        }
    }
}