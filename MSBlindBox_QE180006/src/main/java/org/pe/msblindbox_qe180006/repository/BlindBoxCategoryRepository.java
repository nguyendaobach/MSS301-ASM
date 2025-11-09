package org.pe.msblindbox_qe180006.repository;

import org.pe.msblindbox_qe180006.entity.BlindBoxCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BlindBoxCategoryRepository extends JpaRepository<BlindBoxCategory, Integer> {
    BlindBoxCategory findBlindBoxCategoryByCategoryID(Integer categoryID);
}
