package com.devpro.treeshop.repository;

import com.devpro.treeshop.model.Products;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ProductRepository extends JpaRepository<Products, Integer> {
    List<Products> findByIsHotTrue();
    List<Products> findByIsNewTrue();
    List<Products> findTop8ByOrderBySoldDesc();
    List<Products> findByCategoriesContaining(String category);
    Page<Products> findByCategoriesIgnoreCase(String category, Pageable pageable);
    Page<Products> findByNameContainingIgnoreCase(String keyword, Pageable pageable);
    Page<Products> findByCategoriesContainingIgnoreCase(String category, Pageable pageable);
    long countByCategoriesIgnoreCase(String category);

    @Query("select distinct p.categories from Products p where p.categories is not null and trim(p.categories) <> '' order by p.categories asc")
    List<String> findDistinctCategories();
}
