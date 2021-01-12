package it.polimi.se2.clupapplication.services;

import it.polimi.se2.clupapplication.entities.*;
import it.polimi.se2.clupapplication.model.Status;
import it.polimi.se2.clupapplication.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.*;

@Service
public class TicketService {
    @Autowired
    private TicketRepository ticketRepository;
    @Autowired
    private StoreRepository storeRepository;
    @Autowired
    private SlotRepository slotRepository;
    @Autowired
    private WeekDayRepository weekDayRepository;
    @Autowired
    private BookingRepository bookingRepository;

    /**
     * This method creates a new ASAP (As Soon As Possible) ticket.
     * First of all, it queries the store, fetching all the available upcoming slots.
     * Then, it checks if there are some bookings in the first slot and, in particular, if there is the possibility of
     * retrieving other tickets. If true, it creates new Ticket and Booking instances.
     * @param storeId the store in which the ASAP request has to be made.
     * @param user the user who requested the slot.
     * @return a new Ticket instance if the creation is successful, null otherwise.
     */
    public Ticket createNewASAPTicket(Long storeId, User user) {
        Store store;
        Optional<Store> storeQuery = storeRepository.findById(storeId);
        if (storeQuery.isPresent()) {
            store = storeQuery.get();
            Ticket ticket = new Ticket(user, store, Status.SCHEDULED);
            Calendar calendar = Calendar.getInstance();
            List<Slot> slots = slotRepository.findByStoreAndWeekDayOrderByStartingHour(store, weekDayRepository.findById(calendar.get(Calendar.DAY_OF_WEEK)).get());
            LocalDateTime localDateTime = LocalDateTime.now();
            LocalTime now = localDateTime.toLocalTime();
            for (Slot s : slots) {
                if (now.compareTo(s.getStartingHour()) < 0) {
                    long scheduledOnSlot = bookingRepository.findBySlotAndTicketStatus(s, Status.SCHEDULED).stream().count();
                    long bookedOnSlot = bookingRepository.findBySlotAndTicketStatus(s, Status.BOOKED).stream().count();
                    if (scheduledOnSlot + bookedOnSlot < s.getStoreCapacity()) {
                        Booking b = new Booking(ticket, Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant()), s, UUID.randomUUID().toString());
                        ticket.setBooking(b);
                        b.setTicket(ticket);
                        bookingRepository.save(b);
                        ticketRepository.save(ticket);
                        return ticket;
                    }
                }
            }
        }
        return null;
    }

    /**
     * Void an existent ticket relying on its id.
     * @param ticketId the id of the ticket to be voided.
     */
    public void voidTicket(Long ticketId) {
        Optional<Ticket> optionalTicket = ticketRepository.findById(ticketId);
        if (optionalTicket.isPresent()) {
            Ticket ticket = optionalTicket.get();
            ticket.setStatus(Status.VOID);
            ticketRepository.save(ticket);
        }
    }

    /**
     * @param ticketId the id of the ticket to be retrieved.
     * @return the Ticket object if present, null otherwise.
     */
    public Ticket getTicketById(Long ticketId) {
        return ticketRepository.findById(ticketId).orElse(null);
    }

    /**
     * Validate a ticket through its unique id (uuid). This method is generally called from the attendants' smartphones,
     * which read the users' tickets at the entrance of the supermarkets.
     * @param uuid the unique id of the ticket to be validated.
     * @return true if the validation is successful, false otherwise.
     */
    public boolean validateTicket(String uuid) {
        Booking booking = bookingRepository.findByUuid(uuid);
        if (booking != null) {
            booking.getTicket().setStatus(Status.USED);
            ticketRepository.save(booking.getTicket());
            return true;
        }
        return false;
    }

    /**
     * @param user the user whose tickets has to be retrieved.
     * @return his (her) tickets list.
     */
    public List<Ticket> getTicketByUser(User user) {
        return ticketRepository.findByUser(user);
    }

    /**
     * Fetch all the upcoming tickets of a given store. It is generally used by store managers and attendants.
     * @param store the store whose upcoming tickets have to be retrieved.
     * @return the list of upcoming tickets.
     */
    public List<Ticket> getUpcomingTicketByStore(Store store) {
        LocalTime now = LocalTime.now();
        return ticketRepository.findByStore(store, now, new Date());
    }

    /**
     * This methods takes care of the procedure of handing a ticket on the spot, which is managed by the store attendant, in a
     * proper store area.
     * @param user the store attendant who made the request.
     * @return the generated ticket.
     */
    public Ticket handOutOnSpot(User user) {
        Store store = storeRepository.findByAttendantsContaining(user);
        return createNewASAPTicket(store.getId(), user);
    }
}
