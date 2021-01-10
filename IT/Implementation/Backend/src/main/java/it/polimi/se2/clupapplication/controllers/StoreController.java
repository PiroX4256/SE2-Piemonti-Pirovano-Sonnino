package it.polimi.se2.clupapplication.controllers;

import it.polimi.se2.clupapplication.entities.Store;
import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.model.SlotDTO;
import it.polimi.se2.clupapplication.model.StoreDTO;
import it.polimi.se2.clupapplication.services.StoreService;
import it.polimi.se2.clupapplication.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/store")
public class StoreController {
    @Autowired
    private StoreService storeService;
    @Autowired
    private UserService userService;

    @PostMapping("/create")
    @PreAuthorize("hasAnyRole('MANAGER')")
    public ResponseEntity<?> createNewStore(@RequestBody StoreDTO storeDTO) {
        User manager = userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName());
        Store store = storeService.save(storeDTO, manager);
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

    @PreAuthorize("hasAnyRole('USER', 'MANAGER')")
    @GetMapping("/getAllStores")
    public ResponseEntity<?> getAllStores() {
        return ResponseEntity.ok(storeService.getAllStores());
    }

    @GetMapping("/getAvailableSlots")
    public ResponseEntity<?> getAllSlots(@RequestParam Long storeId) {
        return ResponseEntity.ok(storeService.getAvailableSlots(storeId));
    }

    @GetMapping("/getStoresByCap")
    public ResponseEntity<?> getStoresByCap(@RequestParam int cap) {
        return ResponseEntity.ok(storeService.getAllByCap(cap));
    }

    @GetMapping("/getMyStore")
    public ResponseEntity<?> getMyStore() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findOne(authentication.getName());
        return ResponseEntity.ok(storeService.getByManager(user));
    }
}
