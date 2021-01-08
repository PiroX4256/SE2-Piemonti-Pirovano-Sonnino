package it.polimi.se2.clupapplication.model;

import java.time.LocalTime;

public class SlotDTO {
    private LocalTime startingHour;
    private int storeCapacity;
    private Long storeId;
    private int dayCode;

    public SlotDTO(LocalTime startingHour, int storeCapacity, Long storeId, int dayCode) {
        this.startingHour = startingHour;
        this.storeCapacity = storeCapacity;
        this.storeId = storeId;
        this.dayCode = dayCode;
    }

    public LocalTime getStartingHour() {
        return startingHour;
    }

    public void setStartingHour(LocalTime startingHour) {
        this.startingHour = startingHour;
    }

    public int getStoreCapacity() {
        return storeCapacity;
    }

    public void setStoreCapacity(int storeCapacity) {
        this.storeCapacity = storeCapacity;
    }

    public Long getStoreId() {
        return storeId;
    }

    public void setStoreId(Long storeId) {
        this.storeId = storeId;
    }

    public int getDayCode() {
        return dayCode;
    }

    public void setDayCode(int dayCode) {
        this.dayCode = dayCode;
    }
}
