package it.polimi.se2.clupapplication.entities;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class StoreAttendant {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String attendantCode;
    private String password;

    protected StoreAttendant() {}

    public StoreAttendant(String attendantCode, String password) {
        this.attendantCode = attendantCode;
        this.password = password;
    }

    public Long getId() {
        return id;
    }

    public String getAttendantCode() {
        return attendantCode;
    }

    public void setAttendantCode(String attendantCode) {
        this.attendantCode = attendantCode;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
