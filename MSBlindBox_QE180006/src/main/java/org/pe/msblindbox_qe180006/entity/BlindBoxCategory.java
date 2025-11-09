package org.pe.msblindbox_qe180006.entity;
import jakarta.persistence.*;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name="BlindBoxCategories")
public class BlindBoxCategory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="CategoryID")
    private Integer categoryID;

    @Column(name="CategoryName")
    private String categoryName;

    @Column(name="Description")
    private String description;

    @Column(name="RarityLevel")
    private String rarityLevel;

    @Column(name="PriceRange")
    private String priceRange;

}
