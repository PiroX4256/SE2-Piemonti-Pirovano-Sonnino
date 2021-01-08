package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.Slot;
import it.polimi.se2.clupapplication.entities.Store;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StoreRepository extends JpaRepository<Store, Long> {
}
