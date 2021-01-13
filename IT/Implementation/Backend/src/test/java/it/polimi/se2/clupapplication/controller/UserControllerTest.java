package it.polimi.se2.clupapplication.controller;

import it.polimi.se2.clupapplication.controllers.UserController;
import it.polimi.se2.clupapplication.entities.Role;
import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.model.AuthTokenDTO;
import it.polimi.se2.clupapplication.model.LoginUserDTO;
import it.polimi.se2.clupapplication.model.UserDTO;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.context.SpringBootTest;
import org.junit.jupiter.api.Assertions;
import org.springframework.http.ResponseEntity;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.transaction.annotation.Transactional;

import java.util.Iterator;

@ExtendWith(SpringExtension.class)
@SpringBootTest
@WebAppConfiguration
@Transactional
public class UserControllerTest {
    private static final Log LOG = LogFactory.getLog("ContextLoaderListener");
    @Autowired
    private UserController userController;

    @Test
    public void contextLoads() {
        Assertions.assertNotNull(userController);
    }

    @Test
    public void userSignUpTest() {
        UserDTO userDTO = new UserDTO();
        userDTO.setUsername("testUser");
        userDTO.setPassword("testPassword");
        userDTO.setRole("USER");
        ResponseEntity response = userController.signup(userDTO);
        User user = (User)response.getBody();
        Assertions.assertEquals(userDTO.getUsername(), user.getUsername());
        Assertions.assertEquals(userDTO.getRole(), user.getRoles().iterator().next().getName());
    }

    @Test
    public Long managerSignUpTest() {
        UserDTO userDTO = new UserDTO();
        userDTO.setUsername("testManager");
        userDTO.setPassword("testPassword");
        userDTO.setRole("MANAGER");
        userDTO.setName("ManagerName");
        userDTO.setSurname("ManagerSurname");
        ResponseEntity response = userController.signup(userDTO);
        User user = (User)response.getBody();
        Assertions.assertEquals(userDTO.getUsername(), user.getUsername());
        Assertions.assertEquals(userDTO.getName(), user.getName());
        Assertions.assertEquals(userDTO.getSurname(), user.getSurname());
        Assertions.assertEquals(userDTO.getRole(), user.getRoles().iterator().next().getName());
        return user.getId();
    }

    @Test
    @WithMockUser(username = "testUser", roles = {"USER"})
    public void userSignUpAndLoginTest() {
        UserDTO userDTO = new UserDTO();
        userDTO.setUsername("testUser");
        userDTO.setPassword("testPassword");
        userDTO.setRole("USER");
        userController.signup(userDTO);
        AuthTokenDTO token = (AuthTokenDTO) userController.generateToken(new LoginUserDTO(userDTO.getUsername(), userDTO.getPassword())).getBody();
        Assertions.assertNotNull(token);
        LOG.info("Token generation successful! Token: " + token.getToken());
    }

}
