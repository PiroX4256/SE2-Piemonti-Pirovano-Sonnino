package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.Store;
import it.polimi.se2.clupapplication.entities.Ticket;
import it.polimi.se2.clupapplication.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalTime;
import java.util.Date;
import java.util.List;

public interface TicketRepository extends JpaRepository<Ticket, Long> {
    List<Ticket> findByUser(User user);
    @Query("SELECT t FROM Ticket t WHERE t.store = ?1 AND t.booking.slot.startingHour >= ?2 AND DATE(t.booking.visitDate) = DATE(?3)")
    List<Ticket> findByStore(Store store, LocalTime time, Date date);
}
