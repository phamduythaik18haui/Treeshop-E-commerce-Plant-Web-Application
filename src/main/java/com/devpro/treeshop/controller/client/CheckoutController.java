package com.devpro.treeshop.controller.client;

import com.devpro.treeshop.dto.CheckoutRequest;
import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.service.CartService;
import com.devpro.treeshop.service.OrderService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/client/checkout")
public class CheckoutController {

    private final CartService cartService;
    private final OrderService orderService;

    @GetMapping
    public String checkoutPage(Model model, HttpSession session) {
        Users user = (Users) session.getAttribute("user");
        if (user == null) return "redirect:/client/login";

        var cartItems   = cartService.getCartItems(user.getId());
        Double subtotal = cartService.calculateTotal(user.getId());
        double shippingFee = 30000D;
        double discount    = 0D;
        double total       = (subtotal == null ? 0D : subtotal) - discount + shippingFee;

        model.addAttribute("currentUser", user);
        model.addAttribute("cartItems", cartItems);
        model.addAttribute("subtotal", subtotal);
        model.addAttribute("shippingFee", shippingFee);
        model.addAttribute("discount", discount);
        model.addAttribute("total", total);

        return "client/checkout";
    }

    @PostMapping
    public String submitOrder(@ModelAttribute CheckoutRequest req, HttpSession session) {
        Users user = (Users) session.getAttribute("user");
        if (user == null) return "redirect:/client/login";

        // Tạo order (pending), trừ tồn kho & tăng sold ngay tại đây
        var order = orderService.createOrderFromCart(req, user, 30000D, 0D, true, true);

        switch (req.getPaymentMethod()) {
            case "VNPAY":
                return "redirect:/client/payment/vnpay/create?orderId=" + order.getId();
            case "MOMO":
                return "redirect:/client/payment/momo/create?orderId=" + order.getId();
            default: // COD / BANK
                cartService.clearCart(user.getId()); // dọn giỏ vì đã đặt COD
                return "redirect:/client/order/success?id=" + order.getId();
        }
    }
}
