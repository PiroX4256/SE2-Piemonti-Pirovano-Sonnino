package it.polimi.se2.clupapplication.controllers;

import it.polimi.se2.clupapplication.entities.Role;
import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.model.AuthenticationResponseDTO;
import it.polimi.se2.clupapplication.model.UserDTO;
import it.polimi.se2.clupapplication.model.LoginUserDTO;
import it.polimi.se2.clupapplication.services.EmailService;
import it.polimi.se2.clupapplication.services.RoleService;
import it.polimi.se2.clupapplication.services.StoreService;
import it.polimi.se2.clupapplication.services.UserService;
import it.polimi.se2.clupapplication.model.AuthTokenDTO;
import it.polimi.se2.clupapplication.security.TokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

/**
 * This class handles the authentication backend of CLup, which is composed by the sign up and login methods.
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
    @Autowired
    private RoleService roleService;
    @Autowired
    private StoreService storeService;
    @Autowired
    private EmailService emailService;

    /**
     * This method generates a Json Web Token (JWT), according to the RestFUL paradigm.
     *
     * @param loginUserDTO the user credentials (in a JSON Object form)
     * @return the authentication token to be stored on client side.
     * @throws AuthenticationException if there are some troubles with the login procedure.
     */
    @PostMapping(value = "/login")
    public ResponseEntity<?> generateToken(@RequestBody LoginUserDTO loginUserDTO) throws AuthenticationException {

        final Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginUserDTO.getUsername(),
                        loginUserDTO.getPassword()
                )
        );
        SecurityContextHolder.getContext().setAuthentication(authentication);
        final String token = jwtTokenUtil.generateToken(authentication);
        return ResponseEntity.ok(new AuthTokenDTO(token));
    }

    /**
     * This method permits to users to sign up and join the CLup community!
     *
     * @param user the JSON representation of user's credentials
     * @return a fresh-new user object.
     */
    @RequestMapping(value = "/signup", method = RequestMethod.POST)
    public ResponseEntity<?> signup(@RequestBody UserDTO user) {
        try {
            User userEntity = userService.save(user);
            ResponseEntity<?> responseEntity = generateToken(new LoginUserDTO(userEntity.getUsername(), user.getPassword()));
            Runnable myrunnable = () -> sendEmail(user.getUsername(), "Account Creation @CLup", "Your account has been created!\nLog in to www.clup.cf .\n\n-The CLup Team");
            new Thread(myrunnable).start();
            return responseEntity;
        } catch (DataIntegrityViolationException e) {
            return new ResponseEntity<String>("The profile with the provided username already exists in our systems.", HttpStatus.BAD_REQUEST);
        }
    }

    /**
     * Check if a user is logged in.
     * @return status code 200 if the authentication check is successful.
     */
    @PreAuthorize("hasAnyRole('MANAGER', 'USER')")
    @RequestMapping(value = "/checkLogin", method = RequestMethod.GET)
    public ResponseEntity<?> checkLogin() {
        return ResponseEntity.ok().build();
    }

    /**
     * @return all the information about the authenticated user, which is identified
     * through the personal token attached to the request.
     */
    @PreAuthorize("hasAnyRole('MANAGER', 'USER', 'ATTENDANT')")
    @GetMapping(value = "/me")
    public ResponseEntity<?> me() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findOne(authentication.getName());
        Role userRole = roleService.findByName("USER");
        Role managerRole = roleService.findByName("MANAGER");
        Role attendantRole = roleService.findByName("ATTENDANT");
        if(user.getRoles().contains(userRole)) {
            return ResponseEntity.ok(new AuthenticationResponseDTO(user.getUsername(), "/dashboard", userRole.getName()));
        }
        else if(user.getRoles().contains(managerRole)) {
            return ResponseEntity.ok(new AuthenticationResponseDTO(user.getUsername(), "/admin/dashboard", managerRole.getName()));
        } else if(user.getRoles().contains(attendantRole)) {
            return ResponseEntity.ok(new AuthenticationResponseDTO(user.getUsername(), "/attendant/", attendantRole.getName()));
        }
        return ResponseEntity.notFound().build();
    }

    /**
     * @return the store in which the attendant that made the request works.
     */
    @GetMapping("/getMyStore")
    @PreAuthorize("hasRole('ATTENDANT')")
    public ResponseEntity<?> getMyStore() {
        User user = userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName());
        return ResponseEntity.ok(storeService.getStoreByAttendant(user));
    }

    @GetMapping("/userPing")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<?> userPing() {
        return ResponseEntity.ok().build();
    }

    @GetMapping("/managerPing")
    @PreAuthorize("hasRole('MANAGER')")
    public ResponseEntity<?> managerPing() {
        return ResponseEntity.ok().build();
    }

    @GetMapping("/attendantPing")
    @PreAuthorize("hasRole('ATTENDANT')")
    public ResponseEntity<?> attendantPing() {
        return ResponseEntity.ok().build();
    }

    @Async
    public void sendEmail(String to, String subject, String msg) {
        emailService.sendSimpleMessage(to, subject, msg);
    }
}
