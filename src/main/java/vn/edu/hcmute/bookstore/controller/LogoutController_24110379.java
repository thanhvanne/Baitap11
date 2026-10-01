package vn.edu.hcmute.bookstore.controller;

import java.io.IOException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/logout")
public class LogoutController_24110379 extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws IOException {

        req.getSession().invalidate();

        resp.sendRedirect(
                req.getContextPath() + "/login");
    }
}