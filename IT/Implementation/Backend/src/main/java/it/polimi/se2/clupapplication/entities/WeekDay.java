package it.polimi.se2.clupapplication.entities;

import com.sun.istack.NotNull;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import java.util.List;

@Entity
public class WeekDay {
    @Id
    private int dayCode;
    @NotNull
    private String dayName;

    public int getDayCode() {
        return dayCode;
    }

    public String getDayName() {
        return dayName;
    }
}
