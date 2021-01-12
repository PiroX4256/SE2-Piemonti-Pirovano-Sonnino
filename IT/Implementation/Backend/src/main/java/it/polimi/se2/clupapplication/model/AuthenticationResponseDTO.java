package it.polimi.se2.clupapplication.model;

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
