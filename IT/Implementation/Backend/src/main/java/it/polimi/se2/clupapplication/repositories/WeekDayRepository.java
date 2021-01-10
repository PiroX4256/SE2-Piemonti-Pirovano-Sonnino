package it.polimi.se2.clupapplication.repositories;

import it.polimi.se2.clupapplication.entities.WeekDay;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WeekDayRepository extends JpaRepository<WeekDay, Integer> {
}
