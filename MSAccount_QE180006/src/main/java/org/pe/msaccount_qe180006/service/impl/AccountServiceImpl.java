package org.pe.msaccount_qe180006.service.impl;

import org.pe.msaccount_qe180006.dto.LoginRequest;
import org.pe.msaccount_qe180006.dto.LoginResponse;
import org.pe.msaccount_qe180006.entity.SystemAccount;
import org.pe.msaccount_qe180006.repository.SystemAccountRepository;
import org.pe.msaccount_qe180006.service.AccountService;
import org.pe.msaccount_qe180006.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class AccountServiceImpl implements AccountService {

    @Autowired
    private SystemAccountRepository accountRepository;

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    public LoginResponse login(LoginRequest request) {
        Optional<SystemAccount> accountOpt = accountRepository.findByEmail(request.getEmail());

        if (accountOpt.isEmpty()) {
            return new LoginResponse(null, null, null, "Email not found");
        }

        SystemAccount account = accountOpt.get();

        if (!account.getIsActive()) {
            return new LoginResponse(null, null, null, "Account is not active");
        }

        if (!account.getPassword().equals(request.getPassword())) {
            return new LoginResponse(null, null, null, "Invalid password");
        }

        String token = jwtUtil.generateToken(account.getEmail(), account.getRole());
        return new LoginResponse(token, account.getEmail(), account.getRole(), "Login successful");
    }

    @Override
    public boolean validateToken(String token) {
        return jwtUtil.validateToken(token);
    }

    @Override
    public Integer getRoleFromToken(String token) {
        return jwtUtil.extractRole(token);
    }
}

