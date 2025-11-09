package org.pe.msbrand_qe180006.service.impl;

import lombok.RequiredArgsConstructor;
import org.pe.msbrand_qe180006.dto.BlindBoxSyncDTO;
import org.pe.msbrand_qe180006.entity.BlindBox;
import org.pe.msbrand_qe180006.entity.Brand;
import org.pe.msbrand_qe180006.repository.BlindBoxRepository;
import org.pe.msbrand_qe180006.repository.BrandRepository;
import org.pe.msbrand_qe180006.service.BlindBoxSyncService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

@Service
@RequiredArgsConstructor
public class BlindBoxSyncServiceImpl implements BlindBoxSyncService {

    private final BlindBoxRepository blindBoxRepository;
    private final BrandRepository brandRepository;

    @Override
    @Transactional
    public void syncCreate(BlindBoxSyncDTO blindBox) {
        Brand brand = brandRepository.findById(blindBox.getBrandId())
                .orElseThrow(() -> new RuntimeException("Brand not found with ID: " + blindBox.getBrandId()));

        BlindBox blindBox1 = new BlindBox();
        blindBox1.setName(blindBox.getName());
        blindBox1.setBrand(brand);
        blindBox1.setCategoryID(blindBox.getCategoryId());
        blindBox1.setRarity(blindBox.getRarity());
        blindBox1.setPrice(blindBox.getPrice());
        blindBox1.setReleaseDate(blindBox.getReleaseDate());
        blindBox1.setStock(blindBox.getStock());

        blindBoxRepository.save(blindBox1);
    }

    @Override
    @Transactional
    public void syncUpdate(BlindBoxSyncDTO blindBox) {
        Brand brand = brandRepository.findById(blindBox.getBrandId())
                .orElseThrow(() -> new RuntimeException("Brand not found with ID: " + blindBox.getBrandId()));

        BlindBox blindBox1 = blindBoxRepository.findById(blindBox.getId())
                .orElseThrow(() -> new RuntimeException("BlindBox not found with ID: " + blindBox.getId()));

        blindBox1.setName(blindBox.getName());
        blindBox1.setBrand(brand);
        blindBox1.setCategoryID(blindBox.getCategoryId());
        blindBox1.setRarity(blindBox.getRarity());
        blindBox1.setPrice(blindBox.getPrice());
        blindBox1.setReleaseDate(blindBox.getReleaseDate());
        blindBox1.setStock(blindBox.getStock());

        blindBoxRepository.save(blindBox1);
    }

    @Override
    @Transactional
    public void syncDelete(Integer id) {
        blindBoxRepository.deleteById(id);
    }

    @Override
    public boolean existsById(Integer id) {
        return brandRepository.existsById(id);
    }
}
