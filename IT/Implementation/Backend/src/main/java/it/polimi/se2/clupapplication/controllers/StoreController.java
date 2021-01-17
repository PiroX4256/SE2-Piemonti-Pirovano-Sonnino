package it.polimi.se2.clupapplication.controllers;

import it.polimi.se2.clupapplication.entities.Slot;
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

/**
 * This controller handles the Store API, interfacing with the storeService and the userService.
 */
@RestController
@RequestMapping("/api/store")
public class StoreController {
    @Autowired
    private StoreService storeService;
    @Autowired
    private UserService userService;

    /**
     * Create a new store starting from a user POST request.
     * @param storeDTO the Data Transfer Object of the store to be created.
     * @return status code 200 with a new instance of store if everything goes fine, 400 otherwise.
     */
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

    /**
     * Create a new time slot to be bound to a store.
     * @param slotDTO the Data Transfer Object of the store to be created.
     * @return status code 200.
     */
    @PostMapping("/addSlot")
    @PreAuthorize("hasAnyRole('MANAGER')")
    public ResponseEntity<?> addHours(@RequestBody SlotDTO slotDTO) {
        Slot slot = storeService.addSlot(slotDTO, userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName()));
        return (slot!=null ? ResponseEntity.ok().body(slot) : ResponseEntity.badRequest().build());
    }

    /**
     * @param storeId the id of the store to be retrieved.
     * @return the Store serialized instance.
     */
    @GetMapping("/getStoreById")
    public ResponseEntity<?> getStore(@RequestParam Long storeId) {
        Store store = storeService.getStoreById(storeId);
        return ResponseEntity.ok(store);
    }

    /**
     * @return a list of all the existent stores.
     */
    @PreAuthorize("hasAnyRole('USER', 'MANAGER')")
    @GetMapping("/getAllStores")
    public ResponseEntity<?> getAllStores() {
        return ResponseEntity.ok(storeService.getAllStores());
    }

    /**
     * Retrieve all the available slot given a certain store.
     * @param storeId the id of the store which slots have to be retrieved.
     * @return the list of all the slots.
     */
    @GetMapping("/getAvailableSlots")
    public ResponseEntity<?> getAllSlots(@RequestParam Long storeId) {
        return ResponseEntity.ok(storeService.getAvailableSlots(storeId));
    }

    /**
     * @param cap the postcode of the stores to be retrieved.
     * @return the stores in that area.
     */
    @GetMapping("/getStoresByCap")
    public ResponseEntity<?> getStoresByCap(@RequestParam int cap) {
        return ResponseEntity.ok(storeService.getAllByCap(cap));
    }

    /**
     * @return the store of a given manager or attendant, properly identified through him (her) token, which is appended
     * to the request.
     */
    @PreAuthorize("hasAnyRole('MANAGER', 'ATTENDANT')")
    @GetMapping("/getMyStore")
    public ResponseEntity<?> getMyStore() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findOne(authentication.getName());
        if(user.getRoles().iterator().next().getName().equals("MANAGER")) {
            return ResponseEntity.ok(storeService.getStoreByAttendant(user));
        }
        else {
            return ResponseEntity.ok(storeService.getByManager(user));
        }
    }

    /**
     * @return a list of attendants of a store, given its manager. As before, the store manager is identified through
     * the personal authorization token.
     */
    @PreAuthorize("hasRole('MANAGER')")
    @GetMapping("/getMyAttendants")
    public ResponseEntity<?> getMyAttendants() {
        User user = userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName());
        Store store = storeService.getByManager(user);
        return ResponseEntity.ok(store.getAttendants());
    }

    /**
     * @return all the slots of a store, given its manager.
     */
    @PreAuthorize("hasRole('MANAGER')")
    @GetMapping("/getStoreSlots")
    public ResponseEntity<?> getStoreSlots() {
        User user = userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName());
        Store store = storeService.getByManager(user);
        return ResponseEntity.ok(storeService.getSlotsByStore(store));
    }

    /**
     * Edit the store information. This procedure can only be made by the store manager.
     * @param storeDTO the Data Transfer Object containing the updated information about the store object.
     * @return the updated store object.
     */
    @PreAuthorize("hasRole('MANAGER')")
    @PostMapping("/editStore")
    public ResponseEntity<?> editStore(@RequestBody StoreDTO storeDTO) {
        if (storeDTO.getName().equals("") || storeDTO.getAddress().equals("") || storeDTO.getLongitude() == 0 || storeDTO.getLatitude() == 0 || storeDTO.getCity().equals("") || storeDTO.getCap() <= 0) {
            return ResponseEntity.badRequest().body("Some required fields are missing, please check them and submit the form again.");
        }
        return ResponseEntity.ok(storeService.editStore(storeDTO, userService.findOne(SecurityContextHolder.getContext().getAuthentication().getName())));
    }

    /**
     * Delete a slot given its id.
     * @param slotId the id of the slot to be deleted.
     * @return status code 200 if request is successful, status code 422 if there are active bookings in that slot,
     * status code 403 if the store manager does not manage the store which the slot is bound to.
     */
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

    /**
     * Fire an attendant of a store given its id.
     * @param attendantId the id of the attendant to fire.
     * @return status code 200 if request is successful, status code 403 if the manager does not manage the attendant's store.
     */
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
