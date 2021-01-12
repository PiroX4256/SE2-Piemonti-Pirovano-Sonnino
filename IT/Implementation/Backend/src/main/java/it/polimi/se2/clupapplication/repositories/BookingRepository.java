package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.Booking;
import it.polimi.se2.clupapplication.entities.Slot;
import it.polimi.se2.clupapplication.model.Status;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, Long> {
    List<Booking> findBySlotAndTicketStatus(Slot slot, Status status);
    Booking findByUuid(String uuid);
    @Query("SELECT b FROM Booking b WHERE b.slot = ?1 AND DATE(b.visitDate) = DATE(?2)")
    List<Booking> findAllBySlotAndVisitDate(Slot slot, Date date);
}
