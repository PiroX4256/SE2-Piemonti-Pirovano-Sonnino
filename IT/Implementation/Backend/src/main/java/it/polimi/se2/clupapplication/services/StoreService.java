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

/**
 * This class acts as an intermediate between the controllers and the Store entity.
 * It's called from the controllers, it passes the request to the entities and return back the fetched objects.
 */
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

    /**
     * Create a new instance of Store object and put it in the database.
     * @param storeDTO the Data Transfer Object that represent the store entity.
     * @param manager the manager who made the request.
     * @return a new Store instance.
     */
    public Store save(StoreDTO storeDTO, User manager) {
        Store store = new Store(storeDTO.getName(), storeDTO.getChain(), storeDTO.getCity(), storeDTO.getAddress(), storeDTO.getCap(), storeDTO.getLongitude(), storeDTO.getLatitude());
        store.setManager(manager);
        storeRepository.save(store);
        return store;
    }

    /**
     * This method permits adding a new time slot to an existent store.
     * @param slotDTO the Data Transfer Object that represent the Slot entity.
     * @param manager the store manager, who is expected to be the author of the request.
     */
    public void addSlot(SlotDTO slotDTO, User manager) {
        Store store = storeRepository.findByManager(manager);
        Optional<WeekDay> weekDay = weekDayRepository.findById(slotDTO.getDayCode());
        if(weekDay.isPresent()) {
            Slot slot = new Slot(weekDay.get(), slotDTO.getStartingHour(), slotDTO.getStoreCapacity(), store);
            store.addSlot(slot);
            slotRepository.save(slot);
            storeRepository.save(store);
        }
    }

    /**
     * @param storeId the id of the store to be fetched.
     * @return the Store object if present, null otherwise.
     */
    public Store getStoreById(Long storeId) {
        return storeRepository.findById(storeId).orElse(null);
    }

    /**
     * @return all the Store objects in the database.
     */
    public List<Store> getAllStores() {
        return storeRepository.findAll();
    }

    /**
     * Get all the available slot for a specified store in the current day.
     * @param storeId the store whose slots are searched.
     * @return all the available slot of the current day.
     */
    public List<Slot> getAvailableSlots(Long storeId) {
        Calendar calendar = Calendar.getInstance();
        return slotRepository.findByStoreAndWeekDayOrderByStartingHour(storeRepository.findById(storeId).get(), weekDayRepository.findById(calendar.get(Calendar.DAY_OF_WEEK)).get());
    }

    /**
     * Get all the available stores given a postcode.
     * @param cap the postcode in which the store are searched.
     * @return the list of the stores of that area.
     */
    public List<Store> getAllByCap(int cap) {
        return storeRepository.findByCap(cap);
    }

    /**
     * Find a store given its manager.
     * @param manager the manager.
     * @return the manager's store.
     */
    public Store getByManager(User manager) {
        return storeRepository.findByManager(manager);
    }

    /**
     * Find all the slots ordered by week days, given a store object.
     * @param store the store whose slots are needed to be fetched.
     * @return the list of slots ordered by week days (from 1 to 7)
     */
    public List<Slot> getSlotsByStore(Store store) {
        return slotRepository.findByStoreOrderByWeekDay(store);
    }

    /**
     * Update the store object in the database.
     * @param storeDTO the Data Transfer Object representing the store entity.
     * @param manager the store manager
     * @return the modified Store object.
     */
    public Store editStore(StoreDTO storeDTO, User manager) {
        Store store = storeRepository.findByManager(manager);
        store.setName(storeDTO.getName());
        store.setChain(storeDTO.getChain());
        store.setAddress(storeDTO.getAddress());
        store.setCap(storeDTO.getCap());
        store.setCity(storeDTO.getCity());
        storeRepository.save(store);
        return store;
    }

    /**
     * Delete a certain slot of a specified store.
     * @param store the store whose slot has to be deleted.
     * @param slotId the slot id to be deleted.
     * @return true if the process is successful, false otherwise.
     * @throws IllegalAccessException if the request comes from a manager that is not the owner of the specified store.
     */
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

    /**
     * @param attendant the store attendant
     * @return the store in which the specified attendant works.
     */
    public Store getStoreByAttendant(User attendant) {
        return storeRepository.findByAttendantsContaining(attendant);
    }
}
