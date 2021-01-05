package it.polimi.se2.clupapplication.entities;

import com.sun.istack.NotNull;

import javax.persistence.*;
import java.util.List;

@Entity
public class Store {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @NotNull
    private String name;
    @NotNull
    private double longitude;
    @NotNull
    private double latitude;
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "store_manager")
    private User manager;
    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    private List<User> attendants;
    @OneToMany(mappedBy = "store")
    private List<Ticket> tickets;

    protected Store() {}

    public Store(String name, double longitude, double latitude) {
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
}
