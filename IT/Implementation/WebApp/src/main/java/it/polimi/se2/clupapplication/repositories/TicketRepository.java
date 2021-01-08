package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.Ticket;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TicketRepository extends JpaRepository<Ticket, Long> {
}
