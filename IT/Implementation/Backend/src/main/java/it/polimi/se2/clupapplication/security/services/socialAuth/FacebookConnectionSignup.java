package it.polimi.se2.clupapplication.security.services.socialAuth;

import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.model.UserDTO;
import it.polimi.se2.clupapplication.repositories.UserRepository;
import it.polimi.se2.clupapplication.services.UserService;
import org.apache.commons.text.RandomStringGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.social.connect.Connection;
import org.springframework.social.connect.ConnectionSignUp;
import org.springframework.stereotype.Service;

@Service
public class FacebookConnectionSignup implements ConnectionSignUp {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Override
    public String execute(Connection<?> connection) {
        RandomStringGenerator pwdGenerator = new RandomStringGenerator.Builder().withinRange(33, 45)
                .build();
        User user = userRepository.findByUsername(connection.getKey().getProviderUserId());
        if (user != null) {
            return user.getUsername();
        }
        String[] nameAndSurname = connection.getDisplayName().split(" ");
        UserDTO userDTO = new UserDTO();
        userDTO.setName(nameAndSurname[0]);
        userDTO.setSurname(nameAndSurname[1]);
        userDTO.setUsername(connection.getKey().getProviderUserId());
        userDTO.setRole("USER");
        userDTO.setPassword(pwdGenerator.generate(10));
        userService.save(userDTO);
        return userDTO.getUsername();
    }
}