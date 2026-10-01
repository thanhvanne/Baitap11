package vn.edu.hcmute.bookstore.service.impl;

import java.util.List;

import vn.edu.hcmute.bookstore.dao.BookDAO_24110379;
import vn.edu.hcmute.bookstore.dao.impl.BookDAOImpl_24110379;
import vn.edu.hcmute.bookstore.model.Book_24110379;
import vn.edu.hcmute.bookstore.service.BookService_24110379;

public class BookServiceImpl_24110379
        implements BookService_24110379 {

    private final BookDAO_24110379 dao =
            new BookDAOImpl_24110379();

    @Override
    public List<Book_24110379> findByAuthor(
            int authorId, int page, int size) {
        return dao.findByAuthor(authorId, page, size);
    }

    @Override
    public int countByAuthor(int authorId) {
        return dao.countByAuthor(authorId);
    }

    @Override
    public List<Book_24110379> findAll(int page, int size) {
        return dao.findAll(page, size);
    }

    @Override
    public int countAll() {
        return dao.countAll();
    }

    @Override
    public Book_24110379 findById(int id) {
        return dao.findById(id);
    }

    @Override
    public void insert(Book_24110379 book) {
        dao.insert(book);
    }

    @Override
    public void update(Book_24110379 book) {
        dao.update(book);
    }

    @Override
    public void delete(int id) {
        dao.delete(id);
    }
}