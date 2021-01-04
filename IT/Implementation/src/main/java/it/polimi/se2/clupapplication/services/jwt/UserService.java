package it.polimi.se2.clupapplication.services.jwt;

import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.entities.UserDto;

import java.util.List;

public interface UserService {
    User save(UserDto user);
    List<User> findAll();
    User findOne(String username);
}
