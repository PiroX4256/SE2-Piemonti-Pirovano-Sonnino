package it.polimi.se2.clupapplication.entities;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.sun.istack.NotNull;
import com.sun.istack.Nullable;
import net.minidev.json.annotate.JsonIgnore;

import javax.persistence.*;
import java.util.List;

@Entity
public class Store {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @NotNull
    private String name;
    @Nullable
    private String chain;
    @NotNull
    private double longitude;
    @NotNull
    private double latitude;
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "store_manager")
    private User manager;
    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    private List<User> attendants;
    @JsonBackReference
    @OneToMany(mappedBy = "store")
    private List<Ticket> tickets;
    @OneToMany(mappedBy = "store", fetch = FetchType.LAZY)
    private List<Slot> slots;

    protected Store() {}

    public Store(String name, String chain, double longitude, double latitude) {
        this.name = name;
        this.longitude = longitude;
        this.latitude = latitude;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public User getManager() {
        return manager;
    }

    public void setManager(User manager) {
        this.manager = manager;
    }

    public List<User> getAttendants() {
        return attendants;
    }

    public void setAttendants(List<User> attendants) {
        this.attendants = attendants;
    }

    public List<Ticket> getTickets() {
        return tickets;
    }

    public void setTickets(List<Ticket> tickets) {
        this.tickets = tickets;
    }

    public String getChain() {
        return chain;
    }

    public void setChain(String chain) {
        this.chain = chain;
    }

    public List<Slot> getSlots() {
        return slots;
    }

    public void setSlots(List<Slot> openingHours) {
        this.slots = openingHours;
    }

    public void addSlot(Slot openingHour) {
        this.slots.add(openingHour);
    }
}
