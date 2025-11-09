package org.pe.msbrand_qe180006.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name="BlindBoxes")
public class BlindBox {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="BlindBoxID")
    private Integer blindBoxID;

    @Column(name="Name")
    private String name;

    @ManyToOne
    @JoinColumn(name="BrandId", nullable=false)
    private Brand brand;

    @Column(name="Rarity")
    private String rarity;

    @Column(name = "CategoryID", nullable = false)
    private Integer categoryID;

    @Column(name="Price")
    private Double price;

    @Column(name="ReleaseDate")
    private LocalDate releaseDate;

    @Column(name="Stock")
    private Integer stock;

}