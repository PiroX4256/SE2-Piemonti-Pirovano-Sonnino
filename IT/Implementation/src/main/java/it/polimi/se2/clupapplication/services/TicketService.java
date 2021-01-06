package it.polimi.se2.clupapplication.services;

import it.polimi.se2.clupapplication.entities.*;
import it.polimi.se2.clupapplication.model.Status;
import it.polimi.se2.clupapplication.model.TicketDTO;
import it.polimi.se2.clupapplication.repositories.*;
import org.slf4j.LoggerFactory;
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

    public Ticket createNewASAPTicket(Long storeId, User user) {
        Store store;
        Optional<Store> storeQuery = storeRepository.findById(storeId);
        if(storeQuery.isPresent()) {
            store = storeQuery.get();
            Ticket ticket = new Ticket(user, store, Status.SCHEDULED);
            Calendar calendar = Calendar.getInstance();
            List<Slot> slots = slotRepository.findByStoreAndWeekDayOrderByStartingHour(store, weekDayRepository.findById(calendar.get(Calendar.DAY_OF_WEEK)).get());
            LocalDateTime localDateTime = LocalDateTime.now();
            LocalTime now = localDateTime.toLocalTime();
            for(Slot s: slots) {
                if (now.compareTo(s.getStartingHour()) < 0 && bookingRepository.findBySlot(s).stream().count() < s.getStoreCapacity()) {
                    Booking b = new Booking(ticket, Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant()), s, UUID.randomUUID().toString());
                    ticket.setBooking(b);
                    b.setTicket(ticket);
                    bookingRepository.save(b);
                    ticketRepository.save(ticket);
                    return ticket;
                }
            }
        }
        return null;
    }
}
