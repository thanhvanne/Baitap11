package vn.edu.hcmute.bookstore.controller;

import java.io.IOException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.hcmute.bookstore.dao.RatingDAO_24110379;
import vn.edu.hcmute.bookstore.dao.impl.RatingDAOImpl_24110379;
import vn.edu.hcmute.bookstore.model.Rating_24110379;
import vn.edu.hcmute.bookstore.model.User_24110379;

@WebServlet("/review")
public class ReviewController_24110379 extends HttpServlet {

    private final RatingDAO_24110379 dao =
            new RatingDAOImpl_24110379();

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws IOException {

        User_24110379 user =
                (User_24110379) req.getSession()
                        .getAttribute("user");

        if (user == null) {
            resp.sendRedirect(
                    req.getContextPath() + "/login");
            return;
        }

        int bookId =
                Integer.parseInt(req.getParameter("bookId"));

        int rating =
                Integer.parseInt(req.getParameter("rating"));

        Rating_24110379 r = new Rating_24110379();

        r.setUserId(user.getId());
        r.setBookId(bookId);
        r.setRating(rating);
        r.setReviewText(req.getParameter("reviewText"));

        dao.save(r);

        resp.sendRedirect(req.getContextPath()
                + "/book/detail?id=" + bookId);
    }
}