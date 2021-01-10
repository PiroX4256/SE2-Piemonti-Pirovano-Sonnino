package it.polimi.se2.clupapplication.model;

import it.polimi.se2.clupapplication.entities.User;

public class UserDTO {

    private String username;
    private String password;
    private String name;
    private String surname;
    private String role;
    private Long storeId;

    public User getUserFromDto(){
        User user = new User(username, password);
        user.setName(name);
        user.setSurname(surname);

        return user;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Long getStoreId() {
        return storeId;
    }
}