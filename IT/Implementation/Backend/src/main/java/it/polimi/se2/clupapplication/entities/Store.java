package it.polimi.se2.clupapplication.entities;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.sun.istack.NotNull;
import com.sun.istack.Nullable;
import net.minidev.json.annotate.JsonIgnore;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

/**
 * This class is the representation of the Store database entity.
 * See the DD document for more details.
 */
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
    private String address;
    @NotNull
    private String city;
    @NotNull
    private int cap;
    @NotNull
    private double longitude;
    @NotNull
    private double latitude;
    @OneToOne(cascade = CascadeType.DETACH)
    @JoinColumn(name = "store_manager")
    private User manager;
    @OneToMany(cascade = CascadeType.DETACH, orphanRemoval = true)
    private List<User> attendants = new ArrayList<>();
    @JsonBackReference
    @OneToMany(mappedBy = "store", orphanRemoval = true)
    private List<Ticket> tickets = new ArrayList<>();
    @OneToMany(mappedBy = "store", fetch = FetchType.LAZY, orphanRemoval = true)
    private List<Slot> slots = new ArrayList<>();

    protected Store() {}

    public Store(String name, String chain, String city, String address, int cap, double longitude, double latitude) {
        this.name = name;
        if(chain!=null) {
            this.chain = chain;
        }
        this.longitude = longitude;
        this.latitude = latitude;
        this.city = city;
        this.address = address;
        this.cap = cap;
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

    public String getAddress() {
        return address;
    }

    public String getCity() {
        return city;
    }

    public int getCap() {
        return cap;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public void setCap(int cap) {
        this.cap = cap;
    }

    public void addAttendant(User user) {
        attendants.add(user);
    }

    public void removeAttendant(User user) {
        attendants.remove(user);
    }
}
