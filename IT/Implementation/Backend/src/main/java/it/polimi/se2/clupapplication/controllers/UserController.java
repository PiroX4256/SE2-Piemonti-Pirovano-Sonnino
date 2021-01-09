package it.polimi.se2.clupapplication.controllers;

import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.model.UserDTO;
import it.polimi.se2.clupapplication.model.LoginUser;
import it.polimi.se2.clupapplication.services.UserService;
import it.polimi.se2.clupapplication.model.AuthToken;
import it.polimi.se2.clupapplication.security.TokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

/**
 * This class handles the authentication backend of CLup, which is composed by the sign up and login methods.
 * @author Luca Pirovano
 */
@RestController
@CrossOrigin(origins = "*", maxAge = 3600)
@RequestMapping("/api/auth")
public class UserController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private TokenProvider jwtTokenUtil;

    @Autowired
    private UserService userService;

    /**
     * This method generates a Json Web Token (JWT), according to the RestFUL paradigm.
     * @param loginUser the user credentials (in a JSON Object form)
     * @return the authentication token to be stored on client side.
     * @throws AuthenticationException if there are some troubles with the login procedure.
     */
    @PostMapping(value = "/login")
    public ResponseEntity<?> generateToken(@RequestBody LoginUser loginUser) throws AuthenticationException {

        final Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginUser.getUsername(),
                        loginUser.getPassword()
                )
        );
        SecurityContextHolder.getContext().setAuthentication(authentication);
        final String token = jwtTokenUtil.generateToken(authentication);
        return ResponseEntity.ok(new AuthToken(token));
    }

    /**
     * This method permits to users to sign up and join the CLup community!
     * @param user the JSON representation of user's credentials
     * @return a fresh-new user object.
     */
    @RequestMapping(value="/signup", method = RequestMethod.POST)
    public ResponseEntity<?> saveUser(@RequestBody UserDTO user){
        try {
            User userEntity = userService.save(user);
            return ResponseEntity.ok(userEntity);
        } catch (DataIntegrityViolationException e) {
            return ResponseEntity.status(400).body("The profile with the provided username already exists in our systems.");
        }
    }

    @PreAuthorize("hasAnyRole('MANAGER', 'USER')")
    @RequestMapping(value="/userping", method = RequestMethod.GET)
    public String userPing(){
        return "Any User Can Read This";
    }

}
