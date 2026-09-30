package com.devpro.treeshop.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "categories")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Category implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "name", length = 120, nullable = false, unique = true)
    private String name;

    @Column(name = "description", length = 500)
    private String description;

    @Column(name = "is_active", nullable = false)
    private Boolean active = true;

    @Column(name = "home_display_limit", nullable = false)
    private Integer homeDisplayLimit = 8;

    @Column(name = "created_date")
    private LocalDateTime createdDate;

    @PrePersist
    public void onCreate() {
        if (createdDate == null) {
            createdDate = LocalDateTime.now();
        }
        if (active == null) {
            active = true;
        }
        if (homeDisplayLimit == null || homeDisplayLimit <= 0) {
            homeDisplayLimit = 8;
        }
    }
}
