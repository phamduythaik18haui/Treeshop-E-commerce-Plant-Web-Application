package com.devpro.treeshop.controller.admin;

import com.devpro.treeshop.model.Orders;
import com.devpro.treeshop.service.OrderService;
import com.devpro.treeshop.service.ProductService;
import com.devpro.treeshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class DashboardController {

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @Autowired
    private OrderService orderService;

    @GetMapping("/admin")
    public String adminDashboard(Model model) {
        System.out.println("=== ADMIN DASHBOARD CONTROLLER TRIGGERED ===");

        // === Thống kê tổng quan ===
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalProducts", productService.findAll().size());
        stats.put("totalUsers", userService.findAll().size());
        stats.put("totalOrders", orderService.findAll().size());

        Double totalRevenue = orderService.findAll()
                .stream()
                .mapToDouble(o -> o.getTotalPrice() != null ? o.getTotalPrice() : 0.0)
                .sum();
        stats.put("totalRevenue", totalRevenue);

        long pendingOrders = orderService.findByStatus("pending").size();
        stats.put("pendingOrders", pendingOrders);

        // === Lấy 5 đơn hàng mới nhất (theo ID giảm dần) ===
        List<Orders> recentOrders = orderService.findTop5ByOrderByIdDesc();

        // === Gửi dữ liệu sang JSP ===
        model.addAttribute("stats", stats);
        model.addAttribute("recentOrders", recentOrders);

        return "admin/dashboard/view";
    }
}
