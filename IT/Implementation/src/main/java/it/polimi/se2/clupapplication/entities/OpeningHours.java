package it.polimi.se2.clupapplication.entities;

import com.sun.istack.NotNull;

import javax.persistence.*;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Entity
public class OpeningHours {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @NotNull
    @ManyToMany
    @JoinColumn
    private List<Store> stores;
    @NotNull
    private int dayCode;
    @NotNull
    private LocalTime openingHour;
    @NotNull
    private LocalTime closingHour;

    protected OpeningHours() {}

    public OpeningHours(int dayCode, LocalTime openingHour, LocalTime closingHour) {
        this.dayCode = dayCode;
        this.openingHour = openingHour;
        this.closingHour = closingHour;
        this.stores = new ArrayList<>();
    }

    public void addStore(Store store) {
        this.stores.add(store);
    }

    public Long getId() {
        return id;
    }

    public List<Store> getStores() {
        return stores;
    }

    public void setStores(List<Store> stores) {
        this.stores = stores;
    }

    public int getDayCode() {
        return dayCode;
    }

    public void setDayCode(int dayCode) {
        this.dayCode = dayCode;
    }

    public LocalTime getOpeningHour() {
        return openingHour;
    }

    public void setOpeningHour(LocalTime openingHour) {
        this.openingHour = openingHour;
    }

    public LocalTime getClosingHour() {
        return closingHour;
    }

    public void setClosingHour(LocalTime closingHour) {
        this.closingHour = closingHour;
    }
}
