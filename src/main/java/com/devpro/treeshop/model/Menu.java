package com.devpro.treeshop.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "menus")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Menu implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Menu parent;

    @OneToMany(mappedBy = "parent", fetch = FetchType.EAGER)
    @OrderBy("sortOrder ASC, id ASC")
    private List<Menu> children = new ArrayList<>();

    @Column(name = "name", length = 160, nullable = false)
    private String name;

    @Column(name = "url", length = 500)
    private String url;

    @Column(name = "icon", length = 80)
    private String icon;

    @Column(name = "sort_order")
    private Integer sortOrder = 0;

    @Column(name = "is_active")
    private Boolean active = true;

    @Column(name = "menu_type", length = 50)
    private String menuType = "main";

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    public void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (sortOrder == null) {
            sortOrder = 0;
        }
        if (active == null) {
            active = true;
        }
        if (menuType == null || menuType.isBlank()) {
            menuType = "main";
        }
    }
}
