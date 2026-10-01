package vn.edu.hcmute.bookstore.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.hcmute.bookstore.model.Book_24110379;
import vn.edu.hcmute.bookstore.service.BookService_24110379;
import vn.edu.hcmute.bookstore.service.impl.BookServiceImpl_24110379;

@WebServlet("/admin/books")
public class AdminBookController_24110379 extends HttpServlet {

    private final BookService_24110379 service =
            new BookServiceImpl_24110379();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("create".equals(action)) {

            req.getRequestDispatcher(
                    "/WEB-INF/views/admin/book-form.jsp")
                    .forward(req, resp);

            return;
        }

        if ("edit".equals(action)) {

            int id = Integer.parseInt(
                    req.getParameter("id"));

            req.setAttribute("book",
                    service.findById(id));

            req.getRequestDispatcher(
                    "/WEB-INF/views/admin/book-form.jsp")
                    .forward(req, resp);

            return;
        }

        if ("delete".equals(action)) {

            int id = Integer.parseInt(
                    req.getParameter("id"));

            service.delete(id);

            resp.sendRedirect(
                    req.getContextPath()
                    + "/admin/books");
            return;
        }

        list(req, resp);
    }

    private void list(HttpServletRequest req,
                      HttpServletResponse resp)
            throws ServletException, IOException {

        int page = 1;

        try {
            page = Integer.parseInt(
                    req.getParameter("page"));
        } catch (Exception ignored) {
        }

        int size = 5;
        int count = service.countAll();

        int totalPages =
                (int) Math.ceil(count / (double) size);

        req.setAttribute("books",
                service.findAll(page, size));

        req.setAttribute("page", page);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher(
                "/WEB-INF/views/admin/books.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws IOException {

        req.setCharacterEncoding("UTF-8");

        Book_24110379 b = new Book_24110379();

        String id = req.getParameter("bookid");

        if (id != null && !id.isBlank())
            b.setBookid(Integer.parseInt(id));

        b.setIsbn(
                Integer.valueOf(req.getParameter("isbn")));

        b.setTitle(req.getParameter("title"));

        b.setPublisher(
                req.getParameter("publisher"));

        b.setPrice(
                new BigDecimal(req.getParameter("price")));

        b.setDescription(
                req.getParameter("description"));

        b.setPublishDate(
                Date.valueOf(
                        req.getParameter("publishDate")));

        b.setCoverImage(
                req.getParameter("coverImage"));

        b.setQuantity(
                Integer.valueOf(
                        req.getParameter("quantity")));

        if (b.getBookid() == 0)
            service.insert(b);
        else
            service.update(b);

        resp.sendRedirect(
                req.getContextPath() + "/admin/books");
    }
}