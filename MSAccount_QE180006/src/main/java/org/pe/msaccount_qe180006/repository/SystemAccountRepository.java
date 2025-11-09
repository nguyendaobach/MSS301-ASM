package org.pe.msaccount_qe180006.repository;

import org.pe.msaccount_qe180006.entity.SystemAccount;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SystemAccountRepository extends JpaRepository<SystemAccount, Integer> {
    Optional<SystemAccount> findByEmail(String email);
}

