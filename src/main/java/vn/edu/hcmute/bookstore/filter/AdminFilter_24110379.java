package vn.edu.hcmute.bookstore.filter;

import java.io.IOException;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import vn.edu.hcmute.bookstore.model.User_24110379;

@WebFilter("/admin/*")
public class AdminFilter_24110379 implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req =
                (HttpServletRequest) request;

        HttpServletResponse resp =
                (HttpServletResponse) response;

        User_24110379 user =
                (User_24110379) req.getSession()
                        .getAttribute("user");

        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login");
            return;
        }

        if (!user.isAdmin()) {
            resp.sendError(
                    HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        chain.doFilter(request, response);
    }
}