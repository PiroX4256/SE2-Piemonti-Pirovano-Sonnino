package it.polimi.se2.clupapplication.entities;

public class UserDto {

    private String username;
    private String password;
    private String name;
    private String surname;

    public User getUserFromDto(){
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
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
}