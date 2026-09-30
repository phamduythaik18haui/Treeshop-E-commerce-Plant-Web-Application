package com.devpro.treeshop.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Table(name = "order_product")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Orders_Product implements Serializable {
    @EmbeddedId
    private OrderProductId id;

    @ManyToOne(fetch = FetchType.EAGER)
    @MapsId("orderId")
    @JoinColumn(name = "order_id", nullable = false)
    private Orders order;

    @ManyToOne(fetch = FetchType.EAGER)
    @MapsId("productId")
    @JoinColumn(name = "product_id", nullable = false)
    private Products product;

    @Column(name = "quantity", nullable = false)
    private Integer quantity;

    @Column(name = "price", nullable = false)
    private Double price; // dùng Double cho nhất quán
}
