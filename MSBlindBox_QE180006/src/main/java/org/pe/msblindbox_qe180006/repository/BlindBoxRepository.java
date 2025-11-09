package org.pe.msblindbox_qe180006.repository;

import org.pe.msblindbox_qe180006.entity.BlindBox;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BlindBoxRepository extends JpaRepository<BlindBox, Integer> {
    BlindBox findBlindBoxByBlindBoxID(Integer blindBoxID);
}
