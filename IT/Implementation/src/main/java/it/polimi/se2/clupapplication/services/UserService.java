package it.polimi.se2.clupapplication.services;

import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.json.UserDto;

import java.sql.SQLIntegrityConstraintViolationException;
import java.util.List;

public interface UserService {
    User save(UserDto user);
    List<User> findAll();
    User findOne(String username);
}
