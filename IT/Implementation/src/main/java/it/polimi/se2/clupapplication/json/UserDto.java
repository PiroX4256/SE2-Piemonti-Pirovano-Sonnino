package it.polimi.se2.clupapplication.json;

import it.polimi.se2.clupapplication.entities.User;

public class UserDto {

    private String username;
    private String password;
    private String name;
    private String surname;
    private String role;

    public User getUserFromDto(){
        User user = new User(username, password);
        user.setName(name);
        user.setSurname(surname);

        return user;
    }

    public String getUsername() {
        return username;
    }

    public String getName() {
        return name;
    }

    public String getSurname() {
        return surname;
    }

    public String getPassword() {
        return password;
    }

    public String getRole() {
        return role;
    }
}