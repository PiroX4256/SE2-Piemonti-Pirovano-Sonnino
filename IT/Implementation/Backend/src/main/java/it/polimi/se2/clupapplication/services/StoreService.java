package it.polimi.se2.clupapplication.services;

import it.polimi.se2.clupapplication.entities.*;
import it.polimi.se2.clupapplication.model.SlotDTO;
import it.polimi.se2.clupapplication.model.StoreDTO;
import it.polimi.se2.clupapplication.repositories.BookingRepository;
import it.polimi.se2.clupapplication.repositories.SlotRepository;
import it.polimi.se2.clupapplication.repositories.StoreRepository;
import it.polimi.se2.clupapplication.repositories.WeekDayRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class StoreService {
    @Autowired
    private StoreRepository storeRepository;
    @Autowired
    private SlotRepository slotRepository;
    @Autowired
    private WeekDayRepository weekDayRepository;
    @Autowired
    private BookingRepository bookingRepository;

    public Store save(StoreDTO storeDTO, User manager) {
        Store store = new Store(storeDTO.getName(), storeDTO.getChain(), storeDTO.getCity(), storeDTO.getAddress(), storeDTO.getCap(), storeDTO.getLongitude(), storeDTO.getLatitude());
        store.setManager(manager);
        storeRepository.save(store);
        return store;
    }

    public void addSlot(SlotDTO slotDTO, User user) {
        Store store = storeRepository.findByManager(user);
        Optional<WeekDay> weekDay = weekDayRepository.findById(slotDTO.getDayCode());
        if(weekDay.isPresent()) {
            Slot slot = new Slot(weekDay.get(), slotDTO.getStartingHour(), slotDTO.getStoreCapacity(), store);
            store.addSlot(slot);
            slotRepository.save(slot);
            storeRepository.save(store);
        }
    }

    public Store getStoreById(Long storeId) {
        Optional<Store> store = storeRepository.findById(storeId);
        return store.orElse(null);
    }

    public List<Store> getAllStores() {
        return storeRepository.findAll();
    }

    public List<Slot> getAvailableSlots(Long storeId) {
        Calendar calendar = Calendar.getInstance();
        return slotRepository.findByStoreAndWeekDayOrderByStartingHour(storeRepository.findById(storeId).get(), weekDayRepository.findById(calendar.get(Calendar.DAY_OF_WEEK)).get());
    }

    public List<Store> getAllByCap(int cap) {
        return storeRepository.findByCap(cap);
    }

    public Store getByManager(User user) {
        return storeRepository.findByManager(user);
    }

    public List<Slot> getSlotsByStore(Store store) {
        return slotRepository.findByStoreOrderByWeekDay(store);
    }

    public Store editStore(StoreDTO storeDTO, User user) {
        Store store = storeRepository.findByManager(user);
        store.setName(storeDTO.getName());
        store.setChain(storeDTO.getChain());
        store.setAddress(storeDTO.getAddress());
        store.setCap(storeDTO.getCap());
        store.setCity(storeDTO.getCity());
        storeRepository.save(store);
        return store;
    }

    public boolean deleteSlot(Store store, Long slotId) throws IllegalAccessException {
        Slot slot = slotRepository.findById(slotId).get();
        List<Booking> bookings = bookingRepository.findAllBySlotAndVisitDate(slot, new Date());
        if(!store.getSlots().contains(slot)) {
            throw new IllegalAccessException();
        } else if(bookings.size() > 0){
            return false;

        } else {
            slotRepository.delete(slot);
            return true;
        }
    }
}
