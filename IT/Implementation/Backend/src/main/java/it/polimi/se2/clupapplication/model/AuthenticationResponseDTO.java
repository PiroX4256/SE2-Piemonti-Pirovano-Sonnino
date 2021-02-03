package it.polimi.se2.clupapplication.model;

/**
 * Data Transfer Object representing the authentication response information, which consists in a username and a
 * redirect url to which users will be brought if the login process is successful.
 */
public class AuthenticationResponseDTO {
    private final String username;
    private final String redirectUrl;
    private final String role;

    public AuthenticationResponseDTO(String username, String redirectUrl, String role) {
        this.username = username;
        this.redirectUrl = redirectUrl;
        this.role = role;
    }

    public String getUsername() {
        return username;
    }

    public String getRedirectUrl() {
        return redirectUrl;
    }

    public String getRole() {
        return role;
    }
}
