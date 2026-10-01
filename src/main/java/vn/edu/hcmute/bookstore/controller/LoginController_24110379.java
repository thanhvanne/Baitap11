package vn.edu.hcmute.bookstore.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.hcmute.bookstore.service.UserService_24110379;
import vn.edu.hcmute.bookstore.service.impl.UserServiceImpl_24110379;

@WebServlet("/login")
public class LoginController_24110379 extends HttpServlet {

    private final UserService_24110379 service =
            new UserServiceImpl_24110379();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher(
                "/WEB-INF/views/auth/login.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        var user = service.login(email, password);

        if (user == null) {

            req.setAttribute("error",
                    "Email hoặc mật khẩu không đúng");

            doGet(req, resp);
            return;
        }

        req.getSession().setAttribute("user", user);

        if (user.isAdmin())
            resp.sendRedirect(
                    req.getContextPath() + "/admin/books");
        else
            resp.sendRedirect(
                    req.getContextPath() + "/home");
    }
}