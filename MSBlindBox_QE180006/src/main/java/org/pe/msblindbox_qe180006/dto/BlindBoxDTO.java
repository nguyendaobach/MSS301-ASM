package org.pe.msblindbox_qe180006.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BlindBoxDTO {
    private Integer id;
    private String name;
    private Double price;
    private Integer stock;
    private LocalDate releaseDate;
    private Integer categoryId;
    private Integer brandId;
    private String rarity;
}

