package org.pe.msbrand_qe180006.entity;

import jakarta.persistence.*;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name="Brand")
public class Brand {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="BrandID")
    private Integer brandID;

    @Column(name="BrandName")
    private String brandName;

    @Column(name="CountryOfOrigin")
    private String countryOfOrigin;

}
