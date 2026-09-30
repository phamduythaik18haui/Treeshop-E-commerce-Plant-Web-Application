package com.devpro.treeshop.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Table(name = "orders")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Orders implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private Users user;

    @Column(name = "total_price")
    private Double totalPrice;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "address_id")
    private Address address;

    @Column(name = "total_product")
    private Integer totalProduct;

    @Column(name = "status", length = 50)
    private String status; // pending, confirmed, shipping, delivered, cancelled

    @Column(name = "payment_ref", length = 50)
    private String paymentRef;

    @Column(name = "payment_status", length = 50)
    private String paymentStatus; // pending, paid, failed, refunded

    @Column(name = "payment_method", length = 50)
    private String paymentMethod; // cod, bank_transfer, momo, vnpay
}