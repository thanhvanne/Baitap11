package vn.edu.hcmute.bookstore.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.hcmute.bookstore.dao.RatingDAO_24110379;
import vn.edu.hcmute.bookstore.dao.impl.RatingDAOImpl_24110379;
import vn.edu.hcmute.bookstore.service.BookService_24110379;
import vn.edu.hcmute.bookstore.service.impl.BookServiceImpl_24110379;

@WebServlet("/book/detail")
public class BookDetailController_24110379 extends HttpServlet {

    private final BookService_24110379 bookService =
            new BookServiceImpl_24110379();

    private final RatingDAO_24110379 ratingDAO =
            new RatingDAOImpl_24110379();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(req.getParameter("id"));

            var book = bookService.findById(id);

            if (book == null) {
                resp.sendError(404);
                return;
            }

            req.setAttribute("book", book);
            req.setAttribute("reviews",
                    ratingDAO.findByBook(id));

            req.getRequestDispatcher(
                    "/WEB-INF/views/book-detail.jsp")
                    .forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendError(400);
        }
    }
}