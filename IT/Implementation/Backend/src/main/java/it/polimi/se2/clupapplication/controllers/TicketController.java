package it.polimi.se2.clupapplication.controllers;

import it.polimi.se2.clupapplication.entities.Store;
import it.polimi.se2.clupapplication.entities.Ticket;
import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.services.StoreService;
import it.polimi.se2.clupapplication.services.TicketService;
import it.polimi.se2.clupapplication.services.UserService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.text.ParseException;
import java.util.Calendar;

/**
 * This controller handles the Ticket API, interfacing with the ticketService, the storeService and the userService.
 */
@RestController
@RequestMapping("/api/ticket")
public class TicketController {
    private static final Log LOG = LogFactory.getLog("TicketController");

    @Autowired
    private TicketService ticketService;
    @Autowired
    private UserService userService;
    @Autowired
    private StoreService storeService;

    /**
     * Initiate an ASAP (As Soon As Possible) ticket request, given the id of the store in which the reservation would be made.
     *
     * @param storeId the id of the store in which the reservation would be made.
     * @return status code 200 if request is successful, status code 422 if there are no available slots.
     */
    @PreAuthorize("hasRole('USER')")
    @GetMapping("/asap")
    public ResponseEntity<?> asapRetrieving(@RequestParam Long storeId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findOne(authentication.getName());
        Ticket ticket = ticketService.createNewASAPTicket(storeId, user);
        if (ticket != null) {
            return ResponseEntity.ok(ticket);
        } else {
            return ResponseEntity.unprocessableEntity().body("There are no available slots today or you already have a ticket in the selected store.");
        }
    }

    /**
     * Void a ticket (and an associated booking) given its id.
     *
     * @param ticketId the id of the ticket to be voided.
     * @return status code 200
     */
    @PreAuthorize("hasRole('USER')")
    @GetMapping("/voidTicket")
    public ResponseEntity<?> voidTicket(@RequestParam Long ticketId) {
        Ticket ticket = ticketService.getTicketById(ticketId);
        if (ticket.getUser() == userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName())) {
            ticketService.voidTicket(ticketId);
            return ResponseEntity.ok("Done!");
        } else {
            return ResponseEntity.status(403).build();
        }
    }

    /**
     * Void a ticket (and an associated booking) given its id.
     *
     * @param ticketId the id of the ticket to be voided.
     * @return status code 200
     */
    @PreAuthorize("hasAnyRole('MANAGER', 'ATTENDANT')")
    @GetMapping("/voidUserTicket")
    public ResponseEntity<?> voidUserTicket(@RequestParam Long ticketId) {
        ticketService.voidTicket(ticketId);
        return ResponseEntity.ok("Done!");
    }

    /**
     * Retrieve all the ticket information given its id.
     *
     * @param ticketId the id of the ticket whose information needs to be retrieved.
     * @return 200 ok, with the ticket serialized object.
     */
    @GetMapping("/getTicketInfo")
    public ResponseEntity<?> getTicketInfo(@RequestParam Long ticketId) {
        Ticket ticket = ticketService.getTicketById(ticketId);
        return ResponseEntity.ok(ticket);
    }

    /**
     * Validate a ticket when scanned through its QR Code. This operation is usually made by the store attendants present
     * at the entrance of the supermarket.
     *
     * @param uuid the unique booking id of the ticket.
     * @return status code 200 if request is successfull, status code 400 otherwise.
     */
    @PreAuthorize("hasRole('ATTENDANT')")
    @GetMapping("/validateTicket")
    public ResponseEntity<?> validateTicket(@RequestParam String uuid) throws ParseException {
        if (ticketService.validateTicket(uuid)) {
            return ResponseEntity.status(200).build();
        } else {
            return ResponseEntity.status(400).body("Ticket not found or already used");
        }
    }

    /**
     * @return the list of tickets of a user, identified through the personal token attached to the request.
     */
    @PreAuthorize("hasRole('USER')")
    @GetMapping("/getMyTickets")
    public ResponseEntity<?> getMyTickets() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return ResponseEntity.ok(ticketService.getTicketByUser(userService.findOne(authentication.getName())));
    }

    /**
     * @return the list of upcoming tickets of a manager's store, identified through the personal
     * token attached to the request.
     */
    @PreAuthorize("hasAnyRole('MANAGER', 'ATTENDANT')")
    @GetMapping("/getMyStoreUpcomingTickets")
    public ResponseEntity<?> getMyStoreTickets() {
        User user = userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName());
        if(user.getRoles().iterator().next().getName().equals("ATTENDANT")) {
            return ResponseEntity.ok(ticketService.getUpcomingTicketByStore(storeService.getStoreByAttendant(user)));
        } else {
            return ResponseEntity.ok(ticketService.getUpcomingTicketByStore(storeService.getByManager(user)));
        }
    }

    /**
     * Handles the procedure of "Hand Out on Spot" functionality. An attendant request a new ASAP ticket from its interface
     * and the system returns him (her) a new ticket object.
     *
     * @return status code 200 (along with a ticket instance) if the request if successful, status code 400 otherwise.
     */
    @PreAuthorize("hasRole('ATTENDANT')")
    @GetMapping("/handOutOnSpot")
    public ResponseEntity<?> handOutOnSpot() {
        Ticket ticket = ticketService.handOutOnSpot(userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName()));
        if (ticket == null) {
            return ResponseEntity.badRequest().body("Error creating your ticket.");
        }
        return ResponseEntity.ok(ticket);
    }

    /**
     * This method is scheduled in order to regularly delete the expired tickets. An expired ticket is a non-used ticket.
     * The time tolerance is about 1 hour.
     */
    @Scheduled(fixedDelay = 1800000)
    public void voidExpiredTickets() {
        LOG.info("Starting expired tickets check");
        ticketService.voidExpiredTicket();
    }
}
