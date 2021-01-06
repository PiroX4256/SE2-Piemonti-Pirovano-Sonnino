package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.Slot;
import it.polimi.se2.clupapplication.entities.Store;
import it.polimi.se2.clupapplication.entities.WeekDay;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface SlotRepository extends JpaRepository<Slot, Long> {
    @Query("SELECT s FROM Slot s WHERE storeCapacity > 0")
    List<Slot> getAllByStore(Store store);
    List<Slot> findByStoreAndWeekDayOrderByStartingHour(Store store, WeekDay weekDay);
}
