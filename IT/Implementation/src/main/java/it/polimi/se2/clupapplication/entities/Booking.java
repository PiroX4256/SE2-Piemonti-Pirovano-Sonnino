package it.polimi.se2.clupapplication.entities;

import com.sun.istack.NotNull;
import com.sun.istack.Nullable;

import javax.persistence.*;
import java.util.Date;

@Entity
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @OneToOne
    private Ticket ticket;
    @NotNull
    private Date visitDate;
    /**
     * Module 2 functionality: it will not be implemented.
     */
    @Nullable
    private int visitDuration;

    public Booking() {}

    public Booking(Ticket ticket, Date visitDate, int visitDuration) {
        this.ticket = ticket;
        this.visitDate = visitDate;
        this.visitDuration = visitDuration;
    }

    public Long getId() {
        return id;
    }

    public Ticket getTicket() {
        return ticket;
    }

    public void setTicket(Ticket ticket) {
        this.ticket = ticket;
    }

    public Date getVisitDate() {
        return visitDate;
    }

    public void setVisitDate(Date visitDate) {
        this.visitDate = visitDate;
    }

    public int getVisitDuration() {
        return visitDuration;
    }

    public void setVisitDuration(int visitDuration) {
        this.visitDuration = visitDuration;
    }
}
