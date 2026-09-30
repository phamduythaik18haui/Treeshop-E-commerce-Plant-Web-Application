package com.devpro.treeshop.repository;

import com.devpro.treeshop.model.WishlistItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface WishlistRepository extends JpaRepository<WishlistItem, Integer> {
    List<WishlistItem> findByUserIdOrderByCreatedDateDesc(Integer userId);
    long countByUserId(Integer userId);
    boolean existsByUserIdAndProductId(Integer userId, Integer productId);
    Optional<WishlistItem> findByUserIdAndProductId(Integer userId, Integer productId);
    void deleteByUserIdAndProductId(Integer userId, Integer productId);
}
