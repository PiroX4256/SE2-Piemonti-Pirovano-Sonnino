package it.polimi.se2.clupapplication.model;

/**
 * Data Transfer Object representing the authentication token sent to the client, which consists in a string of mixed characters.
 */
public class AuthTokenDTO {

    private String token;

    public AuthTokenDTO() {

    }

    public AuthTokenDTO(String token) {
        this.token = token;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

}