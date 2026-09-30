package com.devpro.treeshop.repository;

import com.devpro.treeshop.model.CartProduct;
import com.devpro.treeshop.model.CartProductId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartProductRepository extends JpaRepository<CartProduct, CartProductId> {
   Optional<CartProduct> findByCart_IdAndProduct_Id(Integer cartId, Integer productId);
    List<CartProduct> findByCart_Id(Integer cartId);

    @Query("SELECT cp FROM CartProduct cp WHERE cp.cart.user.id = :userId")
    List<CartProduct> findByUserId(@Param("userId") Integer userId);

    @Modifying
    @Query("DELETE FROM CartProduct cp WHERE cp.cart.id = :cartId AND cp.product.id = :productId")
    void deleteByCartIdAndProductId(@Param("cartId") Integer cartId, @Param("productId") Integer productId);

    @Query("SELECT COALESCE(SUM(cp.quantity * cp.price), 0) FROM CartProduct cp WHERE cp.cart.id = :cartId")
    Double calculateCartTotal(@Param("cartId") Integer cartId);
}