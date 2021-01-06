package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.Booking;
import it.polimi.se2.clupapplication.entities.Slot;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, Long> {
    List<Booking> findBySlot(Slot slot);
}
