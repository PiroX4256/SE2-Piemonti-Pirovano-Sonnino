package it.polimi.se2.clupapplication.entities;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.sun.istack.NotNull;
import it.polimi.se2.clupapplication.model.Status;

import javax.persistence.*;

@Entity
public class Ticket {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @JsonManagedReference
    @ManyToOne
    @JoinColumn(name = "user")
    @NotNull
    private User user;
    @JsonManagedReference
    @ManyToOne
    @JoinColumn(name = "store")
    @NotNull
    private Store store;
    @NotNull
    private Status status;
    @JsonManagedReference
    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn
    private Booking booking;

    protected Ticket() {}

    public Ticket(User user, Store store, Status status) {
        this.user = user;
        this.store = store;
        this.status = status;
    }

    public Long getId() {
        return id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }
}
