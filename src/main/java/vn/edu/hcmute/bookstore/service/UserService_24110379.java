package vn.edu.hcmute.bookstore.service;

import vn.edu.hcmute.bookstore.model.User_24110379;

public interface UserService_24110379 {

    User_24110379 login(String email, String password);

    boolean existsByEmail(String email);

    void register(User_24110379 user);
}