package vn.edu.hcmute.bookstore.service;

import java.util.List;
import vn.edu.hcmute.bookstore.model.Book_24110379;

public interface BookService_24110379 {

    List<Book_24110379> findByAuthor(int authorId, int page, int size);

    int countByAuthor(int authorId);

    List<Book_24110379> findAll(int page, int size);

    int countAll();

    Book_24110379 findById(int id);

    void insert(Book_24110379 book);

    void update(Book_24110379 book);

    void delete(int id);
}