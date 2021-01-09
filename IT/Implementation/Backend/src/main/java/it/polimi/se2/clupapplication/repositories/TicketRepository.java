package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.Ticket;
import it.polimi.se2.clupapplication.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TicketRepository extends JpaRepository<Ticket, Long> {
    List<Ticket> findByUser(User user);
}
