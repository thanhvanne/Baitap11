package vn.edu.hcmute.bookstore.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.edu.hcmute.bookstore.dao.AuthorDAO_24110379;
import vn.edu.hcmute.bookstore.dao.impl.AuthorDAOImpl_24110379;
import vn.edu.hcmute.bookstore.model.Author_24110379;
import vn.edu.hcmute.bookstore.service.BookService_24110379;
import vn.edu.hcmute.bookstore.service.impl.BookServiceImpl_24110379;

@WebServlet({"/home", "/books"})
public class HomeController_24110379 extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final BookService_24110379 bookService =
            new BookServiceImpl_24110379();

    private final AuthorDAO_24110379 authorDAO =
            new AuthorDAOImpl_24110379();

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        int page = 1;

        try {
            page = Integer.parseInt(
                    req.getParameter("page"));
        } catch (Exception ignored) {
        }

        if (page < 1) {
            page = 1;
        }

        var authors = authorDAO.findAll();

        req.setAttribute("authors", authors);

        if (authors.isEmpty()) {

            req.setAttribute("page", 1);
            req.setAttribute("totalPages", 0);

            req.getRequestDispatcher(
                    "/WEB-INF/views/home.jsp")
                    .forward(req, resp);

            return;
        }

        int requestedAuthorId;

        try {

            requestedAuthorId =
                    Integer.parseInt(
                            req.getParameter("authorId"));

        } catch (Exception e) {

            requestedAuthorId =
                    authors.get(0).getAuthorId();
        }

        Author_24110379 selectedAuthor = null;

        for (Author_24110379 author : authors) {

            if (author.getAuthorId()
                    == requestedAuthorId) {

                selectedAuthor = author;
                break;
            }
        }

        if (selectedAuthor == null) {
            selectedAuthor = authors.get(0);
        }

        int selectedAuthorId =
                selectedAuthor.getAuthorId();

        final int PAGE_SIZE = 3;

        int totalItems =
                bookService.countByAuthor(
                        selectedAuthorId);

        int totalPages =
                (int) Math.ceil(
                        totalItems / (double) PAGE_SIZE);

        if (totalPages > 0 && page > totalPages) {
            page = totalPages;
        }

        req.setAttribute(
                "selectedAuthor",
                selectedAuthor);

        req.setAttribute(
                "books",
                bookService.findByAuthor(
                        selectedAuthorId,
                        page,
                        PAGE_SIZE));

        req.setAttribute("page", page);
        req.setAttribute(
                "totalPages",
                totalPages);

        req.getRequestDispatcher(
                "/WEB-INF/views/home.jsp")
                .forward(req, resp);
    }
}