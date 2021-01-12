package it.polimi.se2.clupapplication.entities;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.sun.istack.NotNull;
import com.sun.istack.Nullable;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.validator.constraints.UniqueElements;

import javax.persistence.*;
import java.time.LocalTime;
import java.util.Date;

/**
 * This class is the representation of the Booking database entity.
 * See the DD document for more details.
 */
@Entity
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @JsonBackReference
    @OneToOne(mappedBy = "booking", cascade = CascadeType.ALL)
    private Ticket ticket;
    @NotNull
    private Date visitDate;
    @ManyToOne
    @JoinColumn
    private Slot slot;
    @NotNull
    @Column(unique = true)
    private String uuid;
    /**
     * Module 2 functionality: it will not be implemented.
     */
    @Nullable
    private int visitDuration;



    public Booking() {}

    public Booking(Ticket ticket, Date visitDate, Slot slot, String uuid) {
        this.ticket = ticket;
        this.visitDate = visitDate;
        this.slot = slot;
        this.uuid = uuid;
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

    public Slot getSlot() {
        return slot;
    }

    public String getUuid() {
        return uuid;
    }
}
