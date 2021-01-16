package it.polimi.se2.clupapplication.model;

/**
 * Data Transfer Object representing the authentication information, which consists in a username and a password.
 */
public class LoginUserDTO {
    private final String username;
    private final String password;

    public LoginUserDTO(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }
}
