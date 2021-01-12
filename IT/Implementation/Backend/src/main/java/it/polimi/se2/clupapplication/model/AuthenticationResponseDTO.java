package it.polimi.se2.clupapplication.model;

/**
 * Data Transfer Object representing the authentication response information, which consists in a username and a
 * redirect url to which users will be brought if the login process is successful.
 */
public class AuthenticationResponseDTO {
    private final String username;
    private final String redirectUrl;

    public AuthenticationResponseDTO(String username, String redirectUrl) {
        this.username = username;
        this.redirectUrl = redirectUrl;
    }

    public String getUsername() {
        return username;
    }

    public String getRedirectUrl() {
        return redirectUrl;
    }
}
