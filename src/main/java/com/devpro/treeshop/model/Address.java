package com.devpro.treeshop.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Table(name = "address")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Address implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private Users user;

    @Column(name = "location", length = 20, nullable = false)
    private String location;

    @Column(name = "short_desc", length = 100)
    private String shortDesc;

    @Column(name = "detail_desc", length = 500, nullable = false)
    private String detailDesc;

    @Column(name = "reciver_name", length = 100, nullable = false)
    private String reciverName;  // Note: giữ nguyên tên trong DB là "reciver_name"

    @Column(name = "reciver_phone", length = 15, nullable = false)
    private String reciverPhone; // Note: giữ nguyên tên trong DB là "reciver_phone"
}