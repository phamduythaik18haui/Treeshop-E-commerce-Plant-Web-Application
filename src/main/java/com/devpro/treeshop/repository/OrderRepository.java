package com.devpro.treeshop.repository;

import com.devpro.treeshop.model.Orders;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderRepository extends JpaRepository<Orders, Integer> {
    List<Orders> findByStatus(String status);
    List<Orders> findByPaymentStatus(String paymentStatus);
    List<Orders> findTop5ByOrderByIdDesc();

    Page<Orders> findByStatusIgnoreCase(String status, Pageable pageable);
    Page<Orders> findByPaymentStatusIgnoreCase(String paymentStatus, Pageable pageable);
    Page<Orders> findByStatusIgnoreCaseAndPaymentStatusIgnoreCase(String status, String paymentStatus, Pageable pageable);
}
