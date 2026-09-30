package com.devpro.treeshop.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "cart_product")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class CartProduct {

    @EmbeddedId
    private CartProductId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("cartId")
    @JoinColumn(name = "cart_id", nullable = false)
    private Cart cart;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("productId")
    @JoinColumn(name = "product_id", nullable = false)
    private Products product;

    @Column(name = "quantity", nullable = false)
    private Integer quantity = 1;

    // Khuyên dùng Double cho nhất quán với Products.price (DOUBLE)
    @Column(name = "price")
    private Double price;
}
