package org.pe.msblindbox_qe180006.service.impl;

import org.pe.msblindbox_qe180006.dto.BlindBoxDTO;
import org.pe.msblindbox_qe180006.entity.BlindBox;
import org.pe.msblindbox_qe180006.entity.BlindBoxCategory;
import org.pe.msblindbox_qe180006.repository.BlindBoxCategoryRepository;
import org.pe.msblindbox_qe180006.repository.BlindBoxRepository;
import org.pe.msblindbox_qe180006.service.BlindBoxService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Service
public class BlindBoxServiceImpl implements BlindBoxService {

    @Autowired
    private BlindBoxRepository blindBoxRepository;

    @Autowired
    private BlindBoxCategoryRepository categoryRepository;

    @Autowired
    private RestTemplate restTemplate;

    @Override
    public List<?> getAll() {
        return blindBoxRepository.findAll();
    }

    @Override
    @Transactional
    public BlindBox create(BlindBoxDTO blindBox) {

        //blindBox này là để meta data
        // tạo đối tượng mới blindbox1 nhé

        if (blindBox.getName() == null || blindBox.getName().length() <= 10) {
            throw new RuntimeException("Name must be greater than 10 characters");
        }

        if (blindBox.getStock() == null || blindBox.getStock() < 1 || blindBox.getStock() > 100) {
            throw new RuntimeException("Stock must be between 1 and 100");
        }

        Integer categoryId = blindBox.getCategoryId();
        if (categoryId == null) {
            throw new RuntimeException("Category is required");
        }

        BlindBoxCategory category = categoryRepository.findBlindBoxCategoryByCategoryID(categoryId);
        if(category == null){
            throw new RuntimeException("Category with ID " + categoryId + " does not exist");
        }

        if (blindBox.getBrandId() == null) {
            throw new RuntimeException("Brand is required");
        }

        if(!isBrandValid(blindBox.getBrandId())){
            throw new RuntimeException("Brand with ID " + blindBox.getBrandId() + " does not exist");
        }

        BlindBox blindBox1 = new BlindBox();
        blindBox1.setName(blindBox.getName());
        blindBox1.setBrandID(blindBox.getBrandId());
        blindBox1.setReleaseDate(LocalDate.now());
        blindBox1.setCategory(category);
        blindBox1.setRarity(blindBox.getRarity());
        blindBox1.setPrice(blindBox.getPrice());
        blindBox1.setReleaseDate(LocalDate.now());
        blindBox1.setStock(blindBox.getStock());
        BlindBox savedBlindBox = blindBoxRepository.save(blindBox1);

        syncToMSBrand(savedBlindBox, "CREATE");

        return savedBlindBox;
    }

    @Override
    @Transactional
    public BlindBox update(Integer id, BlindBoxDTO blindBox) {
        if (blindBox.getName() == null || blindBox.getName().length() <= 10) {
            throw new RuntimeException("Name must be greater than 10 characters");
        }

        if (blindBox.getStock() == null || blindBox.getStock() < 1 || blindBox.getStock() > 100) {
            throw new RuntimeException("Stock must be between 1 and 100");
        }

        Integer categoryId = blindBox.getCategoryId();
        if (categoryId == null) {
            throw new RuntimeException("Category is required");
        }

        BlindBoxCategory category = categoryRepository.findBlindBoxCategoryByCategoryID(categoryId);
        if(category == null){
            throw new RuntimeException("Category with ID " + categoryId + " does not exist");
        }

        if (blindBox.getBrandId() == null) {
            throw new RuntimeException("Brand is required");
        }
        if (!isBrandValid(blindBox.getBrandId())) {
            throw new RuntimeException("Brand with ID " + blindBox.getBrandId() + " does not exist");
        }

        blindBox.setReleaseDate(LocalDate.now());

        BlindBox blindBox1 = blindBoxRepository.findBlindBoxByBlindBoxID(id);

        blindBox1.setName(blindBox.getName());
        blindBox1.setCategory(category);
        blindBox1.setRarity(blindBox.getRarity());
        blindBox1.setPrice(blindBox.getPrice());
        blindBox1.setReleaseDate(LocalDate.now());
        blindBox1.setStock(blindBox.getStock());
        BlindBox savedBlindBox = blindBoxRepository.save(blindBox1);

        syncToMSBrand(savedBlindBox, "UPDATE");

        return savedBlindBox;
    }

    @Override
    @Transactional
    public void delete(Integer id) {
        if(!blindBoxRepository.existsById(id)){
            throw new RuntimeException("BlindBox with ID " + id + " does not exist");
        }
        blindBoxRepository.deleteById(id);

        try {
            restTemplate.delete("http://localhost:8082/api/brand/sync/blindbox/" + id);
        } catch (Exception e) {
            System.err.println("Failed to sync deletion to MSBrand: " + e.getMessage());
        }
    }

    @Override
    public List<BlindBoxCategory> getAllCategories() {
        return categoryRepository.findAll();
    }

    @Override
    public boolean isAdmin(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return false;
        }

        try {
            org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
            headers.set("Authorization", authHeader);

            org.springframework.http.HttpEntity<Void> entity = new org.springframework.http.HttpEntity<>(headers);

            ResponseEntity<Map> response = restTemplate.postForEntity(
                    "http://localhost:8081/api/account/validate",
                    entity,
                    Map.class
            );

            Map<String, Object> body = response.getBody();
            if (body != null && Boolean.TRUE.equals(body.get("valid"))) {
                Integer role = (Integer) body.get("role");
                return role != null && role == 1;
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }

    private boolean isBrandValid(Integer brandId) {
        try {
            ResponseEntity<Boolean> response = restTemplate.getForEntity(
                    "http://localhost:8082/api/brand/validate/" + brandId,
                    Boolean.class
            );
            return Boolean.TRUE.equals(response.getBody());
        } catch (Exception e) {
            return false;
        }
    }

    private void syncToMSBrand(BlindBox blindBox, String operation) {
        try {
            BlindBoxDTO syncDTO = new BlindBoxDTO(
                blindBox.getBlindBoxID(),
                blindBox.getName(),
                blindBox.getPrice(),
                blindBox.getStock(),
                blindBox.getReleaseDate(),
                blindBox.getCategory().getCategoryID(),
                blindBox.getBrandID(),
                blindBox.getRarity()
            );

            if ("CREATE".equals(operation)) {
                restTemplate.postForEntity(
                    "http://localhost:8082/api/brand/sync/blindbox",
                    syncDTO,
                    Void.class
                );
            } else if ("UPDATE".equals(operation)) {
                restTemplate.put(
                    "http://localhost:8082/api/brand/sync/blindbox",
                    syncDTO
                );
            }
        } catch (Exception e) {
            System.err.println("Failed to sync to MSBrand: " + e.getMessage());
        }
    }
}
