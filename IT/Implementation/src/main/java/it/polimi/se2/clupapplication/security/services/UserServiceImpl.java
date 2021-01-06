package it.polimi.se2.clupapplication.security.services;


import it.polimi.se2.clupapplication.entities.Role;
import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.model.UserDTO;
import it.polimi.se2.clupapplication.repositories.UserRepository;
import it.polimi.se2.clupapplication.services.RoleService;
import it.polimi.se2.clupapplication.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service(value = "userService")
public class UserServiceImpl implements UserDetailsService, UserService {

    @Autowired
    private RoleService roleService;

    @Autowired
    private UserRepository userDao;

    @Autowired
    private BCryptPasswordEncoder bcryptEncoder;

    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userDao.findByUsername(username);
        if(user == null){
            throw new UsernameNotFoundException("Invalid username or password.");
        }
        return new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), getAuthority(user));
    }

    private Set<SimpleGrantedAuthority> getAuthority(User user) {
        Set<SimpleGrantedAuthority> authorities = new HashSet<>();
        user.getRoles().forEach(role -> {
            authorities.add(new SimpleGrantedAuthority("ROLE_" + role.getName()));
        });
        return authorities;
    }

    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        userDao.findAll().iterator().forEachRemaining(list::add);
        return list;
    }

    @Override
    public User findOne(String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public User save(UserDTO user) {

        User nUser = user.getUserFromDto();
        nUser.setPassword(bcryptEncoder.encode(user.getPassword()));

        Role role = roleService.findByName(user.getRole());
        Set<Role> roleSet = new HashSet<>();
        roleSet.add(role);

        nUser.setRoles(roleSet);
        return userDao.save(nUser);
    }
}
