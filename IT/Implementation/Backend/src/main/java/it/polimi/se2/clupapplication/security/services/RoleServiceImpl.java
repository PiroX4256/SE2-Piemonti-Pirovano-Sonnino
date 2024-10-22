package it.polimi.se2.clupapplication.security.services;

import it.polimi.se2.clupapplication.entities.Role;
import it.polimi.se2.clupapplication.repositories.RoleRepository;
import it.polimi.se2.clupapplication.services.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service(value = "roleService")
public class RoleServiceImpl implements RoleService {

    @Autowired
    private RoleRepository roleDao;

    @Override
    public Role findByName(String name) {
        return roleDao.findByName(name);
    }
}
