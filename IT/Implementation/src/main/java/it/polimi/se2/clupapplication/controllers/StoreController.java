package it.polimi.se2.clupapplication.controllers;

import it.polimi.se2.clupapplication.entities.Store;
import it.polimi.se2.clupapplication.model.HoursDTO;
import it.polimi.se2.clupapplication.model.StoreDTO;
import it.polimi.se2.clupapplication.services.StoreService;
import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/store")
public class StoreController {
    @Autowired
    private StoreService storeService;

    @PostMapping("/create")
    @PreAuthorize("hasAnyRole('MANAGER')")
    public ResponseEntity<?> createNewStore(@RequestBody StoreDTO storeDTO) {
        Store store = storeService.save(storeDTO);
        return ResponseEntity.ok(store);
    }

    @PostMapping("/addHours")
    @PreAuthorize("hasAnyRole('MANAGER')")
    public ResponseEntity<?> addHours(@RequestBody HoursDTO hoursDTO) {
        storeService.addOpeningHours(hoursDTO);
        return null;
    }

    @GetMapping("/getOpeningHours")
    public ResponseEntity<?> getOpeningHours(@RequestParam Long storeId) {
        return ResponseEntity.ok(storeService.getOpeningHours(storeId));
    }
}
