package vn.edu.hcmute.bookstore.service.impl;

import vn.edu.hcmute.bookstore.dao.UserDAO_24110379;
import vn.edu.hcmute.bookstore.dao.impl.UserDAOImpl_24110379;
import vn.edu.hcmute.bookstore.model.User_24110379;
import vn.edu.hcmute.bookstore.service.UserService_24110379;

public class UserServiceImpl_24110379
        implements UserService_24110379 {

    private final UserDAO_24110379 dao =
            new UserDAOImpl_24110379();

    @Override
    public User_24110379 login(String email, String password) {

        User_24110379 user = dao.login(email, password);

        if (user != null)
            dao.updateLastLogin(user.getId());

        return user;
    }

    @Override
    public boolean existsByEmail(String email) {
        return dao.existsByEmail(email);
    }

    @Override
    public void register(User_24110379 user) {
        dao.insert(user);
    }
}