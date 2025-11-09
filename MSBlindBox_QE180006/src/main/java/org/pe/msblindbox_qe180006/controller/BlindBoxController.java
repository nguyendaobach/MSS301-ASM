package org.pe.msblindbox_qe180006.controller;

import org.pe.msblindbox_qe180006.dto.BlindBoxDTO;
import org.pe.msblindbox_qe180006.entity.BlindBox;
import org.pe.msblindbox_qe180006.entity.BlindBoxCategory;
import org.pe.msblindbox_qe180006.service.BlindBoxService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/blindboxes")
@CrossOrigin(origins = "*")
public class BlindBoxController {

    @Autowired
    private BlindBoxService blindBoxService;

    @GetMapping
    public ResponseEntity<List<?>> getAll() {
        return ResponseEntity.ok(blindBoxService.getAll());
    }

    @PostMapping
    public ResponseEntity<?> create(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @RequestBody BlindBoxDTO blindBox) {

        if (!blindBoxService.isAdmin(authHeader)) {
            return ResponseEntity.status(403).body("Admin role required");
        }

        try {
            BlindBox created = blindBoxService.create(blindBox);
            return ResponseEntity.ok(created);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

      @PutMapping("/{id}")
    public ResponseEntity<?> update(
            @PathVariable Integer id,
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @RequestBody BlindBoxDTO blindBox) {

        if (!blindBoxService.isAdmin(authHeader)) {
            return ResponseEntity.status(403).body("Admin role required");
        }

        try {
            BlindBox updated = blindBoxService.update(id, blindBox);
            return ResponseEntity.ok(updated);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(
            @PathVariable Integer id,
            @RequestHeader(value = "Authorization", required = false) String authHeader) {

        if (!blindBoxService.isAdmin(authHeader)) {
            return ResponseEntity.status(403).body("Admin role required");
        }
        try {
            blindBoxService.delete(id);
            return ResponseEntity.ok().body("Deleted successfully");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/categories")
    public ResponseEntity<List<BlindBoxCategory>> getAllCategories() {
        return ResponseEntity.ok(blindBoxService.getAllCategories());
    }


}
