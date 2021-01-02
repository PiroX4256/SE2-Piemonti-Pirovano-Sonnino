package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.StoreAttendant;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StoreRepository extends JpaRepository<StoreAttendant, Long> {}
