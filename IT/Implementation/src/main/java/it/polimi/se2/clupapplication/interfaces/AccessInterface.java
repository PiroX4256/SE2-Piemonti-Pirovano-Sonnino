package it.polimi.se2.clupapplication.interfaces;

import it.polimi.se2.clupapplication.entities.User;
import org.springframework.security.authentication.BadCredentialsException;

import javax.naming.AuthenticationException;

public interface AccessInterface {
    String login(String username, String password) throws BadCredentialsException;
    User authenticateByToken(String token) throws AuthenticationException;
    void logout(String username);
}
