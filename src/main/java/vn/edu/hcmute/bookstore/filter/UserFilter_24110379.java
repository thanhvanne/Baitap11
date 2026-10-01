package vn.edu.hcmute.bookstore.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.edu.hcmute.bookstore.model.User_24110379;

@WebFilter(urlPatterns = {
    "/cart",
    "/checkout",
    "/orders/*"
})
public class UserFilter_24110379
        implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req =
                (HttpServletRequest) request;

        HttpServletResponse resp =
                (HttpServletResponse) response;

        User_24110379 user =
                (User_24110379)
                    req.getSession()
                       .getAttribute("user");

        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login");

            return;
        }

        if (user.isAdmin()) {

            resp.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Chức năng này chỉ dành cho User.");

            return;
        }

        chain.doFilter(
                request,
                response);
    }
}