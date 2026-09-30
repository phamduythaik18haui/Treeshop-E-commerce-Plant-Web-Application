package com.devpro.treeshop.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name="users")
@Getter
@Setter
@NoArgsConstructor
@RequiredArgsConstructor
public class Users implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "username", length = 100, nullable = true)
    @NonNull
    private String username;
    @Column(name="email", length = 100 , nullable = false)
    @NonNull
    private String email;
    @Column(name="password" ,length = 50)
    private String password;
    @Column(name="full_name", length=100 ,nullable = false)
    @NonNull
    private String fullName;
    @Column(name="address", length = 100 )
    private String address;
    @Column(name="phone", length = 15, nullable = true)
    private String phone;
    @Column(name = "avatar", length = 100)
    private String avatar;
    @Column(name="provider" , length = 100)
    private String provider;

    @ManyToOne
    @JoinColumn(name="role_id")
    private Roles roles;
    @Column(name = "created_date")
    private LocalDateTime createdDate;


    @PrePersist
    public void defaults(){
        if (createdDate == null){
            createdDate = LocalDateTime.now();
        }
    }





}
