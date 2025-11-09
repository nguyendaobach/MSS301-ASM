package org.pe.msbrand_qe180006.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BlindBoxSyncDTO {
    private Integer id;
    private String name;
    private LocalDate releaseDate;
    private Integer stock;
    private String rarity;
    private Double price;
    private Integer brandId;
    private Integer categoryId;
}

