package org.pe.msaccount_qe180006.entity;

import jakarta.persistence.*;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name="SystemAccounts")
public class SystemAccount {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="AccountID")
    private Integer accountID;

    @Column(name="Username", nullable = false)
    private String username;

    @Column(name="Email", nullable = false)
    private String email;

    @Column(name="Password", nullable = false)
    private String password;

    @Column(name="Role")
    private Integer role;

    @Column(name="IsActive")
    private Boolean isActive;

}
