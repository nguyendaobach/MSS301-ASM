package org.pe.msaccount_qe180006.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class LoginResponse {
    private String token;
    private String email;
    private Integer role;
    private String message;
}

