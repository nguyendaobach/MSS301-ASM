package org.pe.msaccount_qe180006.controller;

import org.pe.msaccount_qe180006.dto.LoginRequest;
import org.pe.msaccount_qe180006.dto.LoginResponse;
import org.pe.msaccount_qe180006.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/account")
@CrossOrigin(origins = "*")
public class AccountController {

    @Autowired
    private AccountService accountService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        LoginResponse response = accountService.login(request);
        if (response.getToken() == null) {
            return ResponseEntity.badRequest().body("Invalid credentials");
        }
        if (response.getToken() != null) {
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.badRequest().body(response);
    }

    @PostMapping("/validate")
    public ResponseEntity<Map<String, Object>> validateToken(@RequestHeader("Authorization") String token) {
        Map<String, Object> response = new HashMap<>();
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }

        boolean valid = accountService.validateToken(token);
        if (valid) {
            Integer role = accountService.getRoleFromToken(token);
            response.put("valid", true);
            response.put("role", role);
            return ResponseEntity.ok(response);
        }

        response.put("valid", false);
        return ResponseEntity.ok(response);
    }
}

