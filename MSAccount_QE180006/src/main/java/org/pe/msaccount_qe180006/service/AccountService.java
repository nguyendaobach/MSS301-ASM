package org.pe.msaccount_qe180006.service;

import org.pe.msaccount_qe180006.dto.LoginRequest;
import org.pe.msaccount_qe180006.dto.LoginResponse;

public interface AccountService {
    LoginResponse login(LoginRequest request);

    boolean validateToken(String token);

    Integer getRoleFromToken(String token);
}

