package it.polimi.se2.clupapplication.entities;

import com.sun.istack.NotNull;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import java.util.List;

/**
 * This class is an abstract representation of a day of a week, which is useful for defining store time slots.
 * The week is assumed to start with Sunday, which is day 1, and to end with Saturday, which is the day 7.
 */
@Entity
public class WeekDay {
    @Id
    private int dayCode;
    @NotNull
    private String dayName;

    public WeekDay() {}

    public WeekDay(int dayCode, String dayName) {
        this.dayCode = dayCode;
        this.dayName = dayName;
    }

    public int getDayCode() {
        return dayCode;
    }

    public String getDayName() {
        return dayName;
    }
}
