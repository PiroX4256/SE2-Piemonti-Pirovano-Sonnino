package it.polimi.se2.clupapplication.services;

import it.polimi.se2.clupapplication.entities.Role;

/**
 * Interface of user role. It is necessary to dial with the JWT Authentication System.
 * It contains the base method for the authentication process.
 */
public interface RoleService {
    /**
     *
     * @param name the role name to be searched in the database.
     * @return the role object fetched from the database, null if not present.
     */
    Role findByName(String name);
}
