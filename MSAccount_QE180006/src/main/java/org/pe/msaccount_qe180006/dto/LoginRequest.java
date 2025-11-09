package org.pe.msaccount_qe180006.dto;

import lombok.Data;

@Data
public class LoginRequest {
    private String email;
    private String password;
}

