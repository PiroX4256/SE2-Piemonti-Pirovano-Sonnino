package it.polimi.se2.clupapplication.services;

import it.polimi.se2.clupapplication.entities.Slot;
import it.polimi.se2.clupapplication.entities.Store;
import it.polimi.se2.clupapplication.entities.WeekDay;
import it.polimi.se2.clupapplication.model.SlotDTO;
import it.polimi.se2.clupapplication.model.StoreDTO;
import it.polimi.se2.clupapplication.repositories.SlotRepository;
import it.polimi.se2.clupapplication.repositories.StoreRepository;
import it.polimi.se2.clupapplication.repositories.WeekDayRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Calendar;
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

    public Store save(StoreDTO storeDTO) {
        Store store = new Store(storeDTO.getName(), storeDTO.getChain(), storeDTO.getLongitude(), storeDTO.getLatitude());
        storeRepository.save(store);
        return store;
    }

    public void addSlot(SlotDTO slotDTO) {
        Store store = storeRepository.getOne(slotDTO.getStoreId());
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
}
