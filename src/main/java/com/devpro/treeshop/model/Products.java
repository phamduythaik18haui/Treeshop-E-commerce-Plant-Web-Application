package com.devpro.treeshop.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Table(name = "products")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Products implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "name", length = 100, nullable = false)
    private String name;

    @Column(name = "categories", length = 100, nullable = false)
    private String categories;

    @Column(name = "price", nullable = false)
    private Double price;

    @Column(name = "detail_desc", columnDefinition = "TEXT", nullable = false)
    private String detailDesc;

    @Column(name = "short_desc", length = 600, nullable = false)
    private String shortDesc;

    @Column(name = "quantity", nullable = false)
    private Integer quantity = 0;

    @Column(name = "sold")
    private Integer sold = 0;

    @Column(name = "image", length = 1000)
    private String image;

    @Column(name = "is_new")
    private Boolean isNew = false;

    @Column(name = "is_hot")
    private Boolean isHot = false;

    @Column(name = "image_detail", length = 1000)
    private String imageDetail;
}