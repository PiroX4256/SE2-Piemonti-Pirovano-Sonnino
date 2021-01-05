package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.OpeningHours;
import it.polimi.se2.clupapplication.entities.Store;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OpeningHoursRepository extends JpaRepository<OpeningHours, Long> {
    List<OpeningHours> findAllByStores(Store store);
}
