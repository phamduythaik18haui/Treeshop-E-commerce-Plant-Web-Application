package com.devpro.treeshop.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.util.List;

@Entity
@Table(name="roles")
@Getter
@Setter
@NoArgsConstructor
@RequiredArgsConstructor
public class Roles implements Serializable {

private static final long serialVersionUID = 1L;

@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private int id;
@Column(name="name",length = 20, nullable = false)
@NonNull
private String name;

@Column(name="description")
private String description;
@OneToMany(mappedBy = "roles")
    private List<Users> users;

    @PrePersist
    public void defaults(){
        if (name == null){
            name = "Khách hàng";
        }
    }

}
