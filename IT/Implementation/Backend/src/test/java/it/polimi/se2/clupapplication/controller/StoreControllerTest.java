package it.polimi.se2.clupapplication.controller;

import it.polimi.se2.clupapplication.controllers.StoreController;
import it.polimi.se2.clupapplication.controllers.UserController;
import it.polimi.se2.clupapplication.entities.Slot;
import it.polimi.se2.clupapplication.entities.Store;
import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.model.SlotDTO;
import it.polimi.se2.clupapplication.model.StoreDTO;
import it.polimi.se2.clupapplication.model.UserDTO;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.ResponseEntity;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.event.annotation.BeforeTestMethod;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;
import java.util.List;

@ExtendWith(SpringExtension.class)
@SpringBootTest
@WebAppConfiguration
@Transactional
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class StoreControllerTest {
    @Autowired
    private StoreController storeController;
    @Autowired
    private UserController userController;


    private Long managerId;

    @BeforeEach
    public void createManager() {
        managerSignUp();
    }

    @Test
    public void contextLoads() {
        Assertions.assertNotNull(storeController);
    }

    public void managerSignUp() {
        UserDTO userDTO = new UserDTO();
        userDTO.setUsername("managerUser");
        userDTO.setPassword("managerUser");
        userDTO.setRole("MANAGER");
        userDTO.setName("ManagerName");
        userDTO.setSurname("ManagerSurname");
        ResponseEntity response = userController.signup(userDTO);
    }

    /*@Test
    @WithMockUser(username = "managerUser", roles = {"MANAGER"})*/
    public Store createStore() {
        StoreDTO storeDTO = new StoreDTO();
        storeDTO.setName("Test Store");
        storeDTO.setAddress("Via di prova 1");
        storeDTO.setCity("Milano");
        storeDTO.setCap(20133);
        storeDTO.setLongitude(42.1025);
        storeDTO.setLatitude(8.5200);
        Store store = (Store)storeController.createNewStore(storeDTO).getBody();
        return store;
    }

    @Test
    @WithMockUser(username = "managerUser", roles = {"MANAGER"})
    public void storeCreation() {
        Assertions.assertNotNull(createStore());
    }

    @Test
    @WithMockUser(username = "managerUser", roles = {"MANAGER"})
    public void createStoreAndAddHours() {
        Store store = createStore();
        SlotDTO slotDTO = new SlotDTO(LocalTime.parse("22:10"), 40, store.getId(), 1);
        Assertions.assertNotNull(storeController.addHours(slotDTO));
    }

    @Test
    @WithMockUser(username = "managerUser", roles = {"MANAGER"})
    public void CreateAndRetrieveSlot() {
        Store store = createStore();
        SlotDTO slotDTO = new SlotDTO(LocalTime.parse("22:10"), 40, store.getId(), 1);
        Slot slot = (Slot) storeController.addHours(slotDTO).getBody();
        Assertions.assertTrue(((List<Slot>)storeController.getStoreSlots().getBody()).contains(slot));
    }

}
