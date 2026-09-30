package com.devpro.treeshop.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class OrderProductId implements Serializable {
    @Column(name = "order_id")
    private Integer orderId;

    @Column(name = "product_id")
    private Integer productId;

    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof OrderProductId)) return false;
        OrderProductId that = (OrderProductId) o;
        return Objects.equals(orderId, that.orderId) &&
                Objects.equals(productId, that.productId);
    }
    @Override public int hashCode() {
        return Objects.hash(orderId, productId);
    }
}
