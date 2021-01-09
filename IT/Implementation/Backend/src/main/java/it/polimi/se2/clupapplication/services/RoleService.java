package it.polimi.se2.clupapplication.services;

import it.polimi.se2.clupapplication.entities.Role;

public interface RoleService {
    Role findByName(String name);
}
