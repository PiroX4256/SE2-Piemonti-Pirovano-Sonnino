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

//TODO set all permissions
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
        if (storeService.getByManager(manager) != null) {
            return ResponseEntity.badRequest().build();
        }
        Store store = storeService.save(storeDTO, manager);
        return ResponseEntity.ok(store);
    }

    @PostMapping("/addSlot")
    @PreAuthorize("hasAnyRole('MANAGER')")
    public ResponseEntity<?> addHours(@RequestBody SlotDTO slotDTO) {
        storeService.addSlot(slotDTO, userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName()));
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

    @PreAuthorize("hasAnyRole('MANAGER', 'ATTENDANT')")
    @GetMapping("/getMyStore")
    public ResponseEntity<?> getMyStore() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findOne(authentication.getName());
        return ResponseEntity.ok(storeService.getByManager(user));
    }

    @PreAuthorize("hasRole('MANAGER')")
    @GetMapping("/getMyAttendants")
    public ResponseEntity<?> getMyAttendants() {
        User user = userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName());
        Store store = storeService.getByManager(user);
        return ResponseEntity.ok(store.getAttendants());
    }

    @PreAuthorize("hasRole('MANAGER')")
    @GetMapping("/getStoreSlots")
    public ResponseEntity<?> getStoreSlots() {
        User user = userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName());
        Store store = storeService.getByManager(user);
        return ResponseEntity.ok(storeService.getSlotsByStore(store));
    }

    @PreAuthorize("hasRole('MANAGER')")
    @PostMapping("/editStore")
    public ResponseEntity<?> editStore(@RequestBody StoreDTO storeDTO) {
        if (storeDTO.getName().equals("") || storeDTO.getAddress().equals("") || storeDTO.getLongitude() == 0 || storeDTO.getLatitude() == 0 || storeDTO.getCity().equals("") || storeDTO.getCap() <= 0) {
            return ResponseEntity.badRequest().body("Some required fields are missing, please check them and submit the form again.");
        }
        return ResponseEntity.ok(storeService.editStore(storeDTO, userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName())));
    }

    @GetMapping("/deleteSlot")
    @PreAuthorize("hasRole('MANAGER')")
    public ResponseEntity<?> deleteSlot(@RequestParam Long slotId) {
        try {
            if(storeService.deleteSlot(storeService.getByManager(userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName())), slotId)) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.unprocessableEntity().body("You cannot delete this slot, because there are active bookings!");
            }
        } catch (IllegalAccessException e) {
            return ResponseEntity.status(403).body("The store does not belong to you!");
        }
    }

    @GetMapping("/fireAttendant")
    @PreAuthorize("hasRole('MANAGER')")
    public ResponseEntity<?> fireAttendant(@RequestParam Long attendantId) {
        User attendant = userService.getById(attendantId);
        if (storeService.getByManager(userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName())) == storeService.getStoreByAttendant(attendant)) {
            userService.deleteUser(attendant);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.status(403).build();
    }
}
