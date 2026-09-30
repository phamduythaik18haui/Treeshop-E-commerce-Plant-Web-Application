package com.devpro.treeshop.repository;

import com.devpro.treeshop.model.Cart;
import com.devpro.treeshop.model.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository<Cart, Integer> {

    /** Tìm giỏ theo Users */
    Optional<Cart> findByUser(Users user);

    /** Tìm giỏ theo userId */
    Optional<Cart> findByUserId(Integer userId);

    /** Đếm số dòng CartProduct (tổng số mặt hàng trong giỏ) */
    @Query("SELECT COUNT(cp) FROM CartProduct cp WHERE cp.cart.user.id = :userId")
    Integer countCartItemsByUserId(@Param("userId") Integer userId);

    /** Kiểm tra đã có giỏ chưa (user_id UNIQUE trong schema) */
    boolean existsByUserId(Integer userId);
}
