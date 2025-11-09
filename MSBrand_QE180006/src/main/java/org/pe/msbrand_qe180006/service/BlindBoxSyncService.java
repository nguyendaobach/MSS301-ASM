package org.pe.msbrand_qe180006.service;

import org.pe.msbrand_qe180006.dto.BlindBoxSyncDTO;

public interface BlindBoxSyncService {
    void syncCreate(BlindBoxSyncDTO dto);
    void syncUpdate(BlindBoxSyncDTO dto);
    void syncDelete(Integer id);

    boolean existsById(Integer id);
}

