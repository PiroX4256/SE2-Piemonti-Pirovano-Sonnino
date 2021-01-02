package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsername(String username);
}
