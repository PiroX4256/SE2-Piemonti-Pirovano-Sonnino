package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.Store;
import it.polimi.se2.clupapplication.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StoreRepository extends JpaRepository<Store, Long> {
    List<Store> findByCap(int cap);
    Store findByManager(User user);
    Store findByAttendantsContaining(User user);
}
