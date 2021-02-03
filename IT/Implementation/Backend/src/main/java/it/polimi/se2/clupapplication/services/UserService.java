package it.polimi.se2.clupapplication.services;

import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.model.UserDTO;

import java.util.List;

/**
 * Interface of user entity in the database. It is necessary to dial with the JWT Authentication System.
 * It contains the base method for the authentication process.
 */
public interface UserService {
    /**
     * Create a new User entity in the database.
     *
     * @param user the Data Transfer Object representing the User entity.
     * @return the new User instance.
     */
    User save(UserDTO user);

    List<User> findAll();

    /**
     * Return a user given its username.
     *
     * @param username the nickname of the user.
     * @return the User instance.
     */
    User findOne(String username);

    void deleteUser(User user);

    User getById(Long id);
}
