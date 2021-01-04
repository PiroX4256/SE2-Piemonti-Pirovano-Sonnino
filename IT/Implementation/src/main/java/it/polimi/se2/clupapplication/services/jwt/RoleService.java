package it.polimi.se2.clupapplication.services.jwt;

import it.polimi.se2.clupapplication.entities.Role;

public interface RoleService {
    Role findByName(String name);
}
