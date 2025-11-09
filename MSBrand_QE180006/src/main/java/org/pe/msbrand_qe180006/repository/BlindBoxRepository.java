package org.pe.msbrand_qe180006.repository;

import org.pe.msbrand_qe180006.entity.BlindBox;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BlindBoxRepository extends JpaRepository<BlindBox, Integer> {
}

