package org.pe.msbrand_qe180006.controller;

import lombok.RequiredArgsConstructor;
import org.pe.msbrand_qe180006.dto.BlindBoxSyncDTO;
import org.pe.msbrand_qe180006.service.BlindBoxSyncService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/brand")
@RequiredArgsConstructor
public class BrandValidationController {

    private final BlindBoxSyncService blindBoxSyncService;

    @GetMapping("/validate/{id}")
    public ResponseEntity<Boolean> validate(@PathVariable Integer id) {
        boolean exists = blindBoxSyncService.existsById(id);
        return ResponseEntity.ok(exists);
    }

    @PostMapping("/sync/blindbox")
    public ResponseEntity<Void> syncCreate(@RequestBody BlindBoxSyncDTO dto) {
        blindBoxSyncService.syncCreate(dto);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/sync/blindbox")
    public ResponseEntity<Void> syncUpdate(@RequestBody BlindBoxSyncDTO dto) {
        blindBoxSyncService.syncUpdate(dto);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/sync/blindbox/{id}")
    public ResponseEntity<Void> syncDelete(@PathVariable Integer id) {
        blindBoxSyncService.syncDelete(id);
        return ResponseEntity.ok().build();
    }
}
