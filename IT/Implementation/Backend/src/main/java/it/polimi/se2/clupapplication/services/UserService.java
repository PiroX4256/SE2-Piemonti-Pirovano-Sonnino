package it.polimi.se2.clupapplication.services;

import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.model.UserDTO;

import java.util.List;

public interface UserService {
    User save(UserDTO user);
    List<User> findAll();
    User findOne(String username);
}
