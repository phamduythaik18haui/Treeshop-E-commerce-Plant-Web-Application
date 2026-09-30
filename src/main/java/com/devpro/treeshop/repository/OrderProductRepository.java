package com.devpro.treeshop.repository;

import com.devpro.treeshop.model.OrderProductId;
import com.devpro.treeshop.model.Orders_Product;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface OrderProductRepository extends JpaRepository<Orders_Product, OrderProductId> {
    List<Orders_Product> findByOrder_Id(Integer orderId);
}
