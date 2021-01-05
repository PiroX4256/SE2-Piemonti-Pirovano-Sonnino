package it.polimi.se2.clupapplication.services;

import it.polimi.se2.clupapplication.entities.OpeningHours;
import it.polimi.se2.clupapplication.entities.Store;
import it.polimi.se2.clupapplication.model.HoursDTO;
import it.polimi.se2.clupapplication.model.StoreDTO;
import it.polimi.se2.clupapplication.repositories.OpeningHoursRepository;
import it.polimi.se2.clupapplication.repositories.StoreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class StoreService {
    @Autowired
    private StoreRepository storeRepository;
    @Autowired
    private OpeningHoursRepository openingHoursRepository;

    public Store save(StoreDTO storeDTO) {
        Store store = new Store(storeDTO.getName(), storeDTO.getChain(), storeDTO.getLongitude(), storeDTO.getLatitude());
        storeRepository.save(store);
        return store;
    }

    public void addOpeningHours(HoursDTO hoursDTO) {
        Store store = storeRepository.getOne(hoursDTO.getStoreId());
        OpeningHours openingHours = new OpeningHours(hoursDTO.getDayCode(), hoursDTO.getOpeningHour(), hoursDTO.getClosingHour());
        openingHours.addStore(store);
        openingHoursRepository.save(openingHours);
    }

    public List<OpeningHours> getOpeningHours(Long storeId) {
        Store store = storeRepository.getOne(storeId);
        List<OpeningHours> openingHours = openingHoursRepository.findAllByStores(store);
        return openingHours;
    }
}
