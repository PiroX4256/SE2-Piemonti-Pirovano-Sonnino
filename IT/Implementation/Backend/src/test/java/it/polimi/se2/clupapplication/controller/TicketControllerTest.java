package it.polimi.se2.clupapplication.controller;

import it.polimi.se2.clupapplication.controllers.StoreController;
import it.polimi.se2.clupapplication.controllers.TicketController;
import it.polimi.se2.clupapplication.controllers.UserController;
import it.polimi.se2.clupapplication.entities.Store;
import it.polimi.se2.clupapplication.entities.Ticket;
import it.polimi.se2.clupapplication.model.SlotDTO;
import it.polimi.se2.clupapplication.model.StoreDTO;
import it.polimi.se2.clupapplication.model.UserDTO;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.ResponseEntity;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;
import java.util.Calendar;

@ExtendWith(SpringExtension.class)
@SpringBootTest
@WebAppConfiguration
@Transactional
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class TicketControllerTest {
    @Autowired
    private TicketController ticketController;
    @Autowired
    private UserController userController;
    @Autowired
    private StoreController storeController;

    private Long storeId;

    @Test
    public void contextLoads() {
        Assertions.assertNotNull(ticketController);
    }

    @Test
    @WithMockUser(username = "user", roles = {"MANAGER"})
    public void createStore() {
        StoreDTO storeDTO = new StoreDTO();
        storeDTO.setName("Test Store");
        storeDTO.setAddress("Via di prova 1");
        storeDTO.setCity("Milano");
        storeDTO.setCap(20133);
        storeDTO.setLongitude(42.1025);
        storeDTO.setLatitude(8.5200);
        Store store = (Store)storeController.createNewStore(storeDTO).getBody();
        this.storeId = store.getId();
    }

    @BeforeEach
    public void customerSignUp() {
        UserDTO userDTO = new UserDTO();
        userDTO.setUsername("user");
        userDTO.setPassword("user");
        userDTO.setRole("USER");
        ResponseEntity response = userController.signup(userDTO);
    }

    @Test
    @WithMockUser(username = "user", roles = {"MANAGER"})
    public void addHours() {
        createStore();
        Calendar calendar = Calendar.getInstance();
        SlotDTO slotDTO = new SlotDTO(LocalTime.parse("23:59"), 40, storeId, calendar.get(Calendar.DAY_OF_WEEK));
        Assertions.assertNotNull(storeController.addHours(slotDTO));
    }

    @Test
    @WithMockUser(username = "user", roles = {"USER", "MANAGER"})
    public void getTicket() {
        addHours();
        Assertions.assertNotNull(ticketController.asapRetrieving(storeId).getBody());
    }

    @Test
    @WithMockUser(username = "user", roles = {"USER", "MANAGER"})
    public void getAndTicket() {
        addHours();
        Ticket ticket = (Ticket)ticketController.asapRetrieving(storeId).getBody();
        Assertions.assertEquals("Done!", ticketController.voidTicket(ticket.getId()).getBody());
    }

    @Test
    @WithMockUser(username = "user", roles = {"USER", "MANAGER"})
    public void getAndValidateTicket() {
        addHours();
        Ticket ticket = (Ticket)ticketController.asapRetrieving(storeId).getBody();
        ticketController.validateTicket(ticket.getBooking().getUuid());
        Assertions.assertEquals(((Ticket)ticketController.getTicketInfo(ticket.getId()).getBody()).getStatus().name(), "USED");
    }
}
