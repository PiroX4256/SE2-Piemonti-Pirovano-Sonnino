package it.polimi.se2.clupapplication.controllers;

import it.polimi.se2.clupapplication.entities.Ticket;
import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.services.TicketService;
import it.polimi.se2.clupapplication.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Calendar;

@RestController
@RequestMapping("/api/ticket")
public class TicketController {
    @Autowired
    private TicketService ticketService;
    @Autowired
    private UserService userService;
    @Autowired
    private AuthenticationManager authenticationManager;

    @GetMapping("/asap")
    public ResponseEntity<?> asapRetrieving(@RequestParam Long storeId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Calendar calendar = Calendar.getInstance();
        System.out.println(calendar.get(Calendar.DAY_OF_WEEK));
        User user = userService.findOne(authentication.getName());
        return ResponseEntity.ok(ticketService.createNewASAPTicket(storeId, user));
    }

    @GetMapping("/voidTicket")
    public ResponseEntity<?> voidTicket(@RequestParam Long ticketId) {
        ticketService.voidTicket(ticketId);
        return ResponseEntity.ok("Done!");
    }

    @GetMapping("/getTicketInfo")
    public ResponseEntity<?> getTicketInfo(@RequestParam Long ticketId) {
        Ticket ticket = ticketService.getTicketById(ticketId);
        return ResponseEntity.ok(ticket);
    }

    @GetMapping("/validateTicket")
    public ResponseEntity<?> validateTicket(@RequestParam String uuid) {
        if(ticketService.validateTicket(uuid)) {
            return ResponseEntity.status(200).body("");
        } else {
            return ResponseEntity.status(400).body("Ticket not found or already used");
        }
    }
}
