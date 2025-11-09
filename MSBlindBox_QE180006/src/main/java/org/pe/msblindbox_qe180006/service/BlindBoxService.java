package org.pe.msblindbox_qe180006.service;

import org.pe.msblindbox_qe180006.dto.BlindBoxDTO;
import org.pe.msblindbox_qe180006.entity.BlindBox;
import org.pe.msblindbox_qe180006.entity.BlindBoxCategory;

import java.util.List;

public interface BlindBoxService {
    List<?> getAll();
    BlindBox create(BlindBoxDTO blindBox);
    BlindBox update(Integer id, BlindBoxDTO blindBox);
    void delete(Integer id);
    List<BlindBoxCategory> getAllCategories();
    boolean isAdmin(String authHeader);
}
