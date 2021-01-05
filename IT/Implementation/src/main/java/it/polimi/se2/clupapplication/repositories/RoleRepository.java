package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.Role;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoleRepository extends JpaRepository<Role, Long> {
    Role findByName(String name);
}
