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

    public double getLongitude() {
        return longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public User getManager() {
        return manager;
    }

    public List<User> getAttendants() {
        return attendants;
    }
}
