package it.polimi.se2.clupapplication.model;

import java.time.LocalTime;

public class HoursDTO {
    private Long storeId;
    private int dayCode;
    private LocalTime openingHour;
    private LocalTime closingHour;

    public HoursDTO(Long storeId, int dayCode, LocalTime openingHour, LocalTime closingHour) {
        this.storeId = storeId;
        this.dayCode = dayCode;
        this.openingHour = openingHour;
        this.closingHour = closingHour;
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

    public LocalTime getOpeningHour() {
        return openingHour;
    }

    public void setOpeningHour(LocalTime openingHour) {
        this.openingHour = openingHour;
    }

    public LocalTime getClosingHour() {
        return closingHour;
    }

    public void setClosingHour(LocalTime closingHour) {
        this.closingHour = closingHour;
    }
}
