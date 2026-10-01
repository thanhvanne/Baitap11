package vn.edu.hcmute.bookstore.dao;

import vn.edu.hcmute.bookstore.model.User_24110379;

public interface UserDAO_24110379 {

    User_24110379 login(String email, String password);

    boolean existsByEmail(String email);

    void insert(User_24110379 user);

    void updateLastLogin(int id);
}