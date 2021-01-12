package it.polimi.se2.clupapplication.entities;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.sun.istack.NotNull;

import javax.persistence.*;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 * This class is the representation of the Slot database entity.
 * See the DD document for more details.
 */
@Entity
public class Slot {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @NotNull
    private LocalTime startingHour;
    @NotNull
    private int storeCapacity;
    @ManyToOne
    WeekDay weekDay;
    @JsonBackReference
    @ManyToOne
    Store store;


    protected Slot() {}

    public Slot(WeekDay weekDay, LocalTime startingHour, int maxCapacity, Store store) {
        this.weekDay = weekDay;
        this.startingHour = startingHour;
        this.storeCapacity = maxCapacity;
        this.store = store;
    }

    public Long getId() {
        return id;
    }

    public LocalTime getStartingHour() {
        return startingHour;
    }

    public void setStartingHour(LocalTime startingHour) {
        this.startingHour = startingHour;
    }

    public int getStoreCapacity() {
        return storeCapacity;
    }

    public void setStoreCapacity(int storeCapacity) {
        this.storeCapacity = storeCapacity;
    }

    public WeekDay getWeekDay() {
        return weekDay;
    }

    public void setWeekDay(WeekDay weekDay) {
        this.weekDay = weekDay;
    }

    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }
}
