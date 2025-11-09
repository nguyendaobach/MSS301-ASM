package org.pe.msblindbox_qe180006.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
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
    @JoinColumn(name="CategoryID", nullable=false)
    @JsonIgnoreProperties({"description", "rarityLevel", "priceRange"})
    private BlindBoxCategory category;

    @Column(name = "BrandID", nullable = false)
     private Integer brandID;

    @Column(name="Rarity")
    private String rarity;

    @Column(name="Price")
    private Double price;

    @Column(name="ReleaseDate")
    private LocalDate releaseDate;

    @Column(name="Stock")
    private Integer stock;

}