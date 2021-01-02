package it.polimi.se2.clupapplication.controllers;

import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.repositories.UserRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class UserController {
    private final UserRepository repository;

    UserController(UserRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/usertest")
    public User getUser() {
        return repository.findByUsername("pippo");
    }

    /**
     * Create a new User instance from the API
     * @param newUser the JSONObject of the new user to be created
     * @return a new User instance which is saved into the repository
     */
    @PostMapping("/users/")
    User newUser(@RequestBody User newUser) {
        return repository.save(newUser);
    }

    @DeleteMapping("/users/{id}")
    public void deleteUser(@PathVariable Long id) {
        repository.deleteById(id);
    }
}
