package it.polimi.se2.clupapplication.controllers;

import it.polimi.se2.clupapplication.entities.Store;
import it.polimi.se2.clupapplication.model.SlotDTO;
import it.polimi.se2.clupapplication.model.StoreDTO;
import it.polimi.se2.clupapplication.services.StoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/store")
public class StoreController {
    @Autowired
    private StoreService storeService;

    @PostMapping("/create")
    @PreAuthorize("hasAnyRole('MANAGER')")
    public ResponseEntity<?> createNewStore(@RequestBody StoreDTO storeDTO) {
        Store store = storeService.save(storeDTO);
        return ResponseEntity.ok(store);
    }

    @PostMapping("/addSlot")
    @PreAuthorize("hasAnyRole('MANAGER')")
    public ResponseEntity<?> addHours(@RequestBody SlotDTO slotDTO) {
        storeService.addSlot(slotDTO);
        return null;
    }

    @GetMapping("/getStoreById")
    public ResponseEntity<?> getStore(@RequestParam Long storeId) {
        Store store = storeService.getStoreById(storeId);
        return ResponseEntity.ok(store);
    }

    @GetMapping("/getAllStores")
    public ResponseEntity<?> getAllStores() {
        return ResponseEntity.ok(storeService.getAllStores());
    }

    @GetMapping("/getAvailableSlots")
    public ResponseEntity<?> getAllSlots(@RequestParam Long storeId) {
        return ResponseEntity.ok(storeService.getAvailableSlots(storeId));
    }
}
