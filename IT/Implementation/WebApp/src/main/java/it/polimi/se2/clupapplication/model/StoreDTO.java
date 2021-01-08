package it.polimi.se2.clupapplication.model;

import com.sun.istack.NotNull;
import it.polimi.se2.clupapplication.entities.Ticket;
import it.polimi.se2.clupapplication.entities.User;

import javax.persistence.*;
import java.util.List;

public class StoreDTO {
    private Long id;
    private String name;
    private String chain;
    private double longitude;
    private double latitude;
    private User manager;
    private List<User> attendants;
    private List<Ticket> tickets;

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getChain() {
        return chain;
    }

    public void setChain(String chain) {
        this.chain = chain;
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
