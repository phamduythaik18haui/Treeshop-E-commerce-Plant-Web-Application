package com.devpro.treeshop.controller.admin;

import com.devpro.treeshop.model.Orders;
import com.devpro.treeshop.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class OrderController {

    @Autowired
    private OrderService orderService;

    @GetMapping("/admin/orders")
    public String orders(@RequestParam(value = "status", required = false) String status,
                         @RequestParam(value = "paymentStatus", required = false) String paymentStatus,
                         @RequestParam(value = "page", defaultValue = "0") int page,
                         Model model) {
        Page<Orders> ordersPage = orderService.getAdminOrders(status, paymentStatus, page, 8);
        List<Orders> all = orderService.findAll();

        long totalOrders = all.size();
        long pendingOrders = all.stream().filter(o -> "pending".equalsIgnoreCase(o.getStatus())).count();
        long confirmedOrders = all.stream().filter(o -> "confirmed".equalsIgnoreCase(o.getStatus())).count();
        long shippingOrders = all.stream().filter(o -> "shipping".equalsIgnoreCase(o.getStatus())).count();
        long deliveredOrders = all.stream().filter(o -> "delivered".equalsIgnoreCase(o.getStatus())).count();
        long cancelledOrders = all.stream().filter(o -> "cancelled".equalsIgnoreCase(o.getStatus())).count();

        double grossAmount = all.stream().mapToDouble(o -> o.getTotalPrice() == null ? 0D : o.getTotalPrice()).sum();
        double paidRevenue = all.stream()
                .filter(o -> "paid".equalsIgnoreCase(o.getPaymentStatus()) || "COD".equalsIgnoreCase(o.getPaymentMethod()))
                .mapToDouble(o -> o.getTotalPrice() == null ? 0D : o.getTotalPrice())
                .sum();

        model.addAttribute("orders", ordersPage.getContent());
        model.addAttribute("ordersPage", ordersPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("currentStatus", status);
        model.addAttribute("currentPaymentStatus", paymentStatus);
        model.addAttribute("totalOrders", totalOrders);
        model.addAttribute("pendingOrders", pendingOrders);
        model.addAttribute("confirmedOrders", confirmedOrders);
        model.addAttribute("shippingOrders", shippingOrders);
        model.addAttribute("deliveredOrders", deliveredOrders);
        model.addAttribute("cancelledOrders", cancelledOrders);
        model.addAttribute("grossAmount", grossAmount);
        model.addAttribute("paidRevenue", paidRevenue);
        return "admin/order/orders";
    }

    @GetMapping("/admin/orders/{id}")
    public String orderDetail(@PathVariable int id, Model model) {
        Orders order = orderService.findById(id);
        model.addAttribute("order", order);
        model.addAttribute("items", orderService.findItemsByOrderId(id));
        return "admin/order/order-detail";
    }

    @PostMapping("/admin/orders/update-status")
    public String updateOrderStatus(@RequestParam("orderId") int orderId,
                                    @RequestParam("status") String status) {
        Orders order = orderService.findById(orderId);
        order.setStatus(status);
        orderService.save(order);
        return "redirect:/admin/orders/" + orderId;
    }

    @PostMapping("/admin/orders/update-payment-status")
    public String updatePaymentStatus(@RequestParam("orderId") int orderId,
                                      @RequestParam("paymentStatus") String paymentStatus) {
        Orders order = orderService.findById(orderId);
        order.setPaymentStatus(paymentStatus);
        orderService.save(order);
        return "redirect:/admin/orders/" + orderId;
    }

    @GetMapping("/admin/orders/delete/{id}")
    public String deleteOrder(@PathVariable int id) {
        orderService.deleteOrder(id);
        return "redirect:/admin/orders";
    }

    @GetMapping("/admin/orders/edit/{id}")
    public String editOrder(@PathVariable int id, Model model) {
        model.addAttribute("order", orderService.findById(id));
        return "admin/order/order-edit";
    }

    @PostMapping("/admin/orders/update")
    public String updateOrder(@ModelAttribute Orders order) {
        Orders existingOrder = orderService.findById(order.getId());
        existingOrder.setStatus(order.getStatus());
        existingOrder.setPaymentStatus(order.getPaymentStatus());
        existingOrder.setPaymentMethod(order.getPaymentMethod());
        existingOrder.setTotalPrice(order.getTotalPrice());
        existingOrder.setTotalProduct(order.getTotalProduct());
        orderService.save(existingOrder);
        return "redirect:/admin/orders/" + existingOrder.getId();
    }
}
