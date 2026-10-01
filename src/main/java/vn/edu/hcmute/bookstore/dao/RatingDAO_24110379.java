package vn.edu.hcmute.bookstore.dao;

import java.util.List;
import vn.edu.hcmute.bookstore.model.Rating_24110379;

public interface RatingDAO_24110379 {

    List<Rating_24110379> findByBook(int bookId);

    void save(Rating_24110379 rating);
}