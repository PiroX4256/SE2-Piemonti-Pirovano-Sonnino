package it.polimi.se2.clupapplication.services;

import it.polimi.se2.clupapplication.entities.Booking;
import it.polimi.se2.clupapplication.repositories.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BookingService {
    @Autowired
    private BookingRepository bookingRepository;

    public Booking createNewBooking() {
        return null;
    }

}
