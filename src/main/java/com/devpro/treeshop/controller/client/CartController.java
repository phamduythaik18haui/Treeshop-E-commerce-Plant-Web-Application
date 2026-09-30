package com.devpro.treeshop.controller.client;

import com.devpro.treeshop.model.CartProduct;
import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/client/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping
    public String getCart(Model model, HttpSession session) {
        Users user = (Users) session.getAttribute("user");
        model.addAttribute("currentUser", user);
        if (user == null) {
            return "redirect:/client/login";
        }

        List<CartProduct> cartItems = cartService.getCartItems(user.getId());
        Double total = cartService.calculateTotal(user.getId());

        model.addAttribute("cartItems", cartItems);
        model.addAttribute("total", total);
        model.addAttribute("subtotal", total);
        model.addAttribute("shippingFee", 30000); // Phí vận chuyển
        model.addAttribute("discount", 0); // Giảm giá

        return "client/cart";
    }

    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addToCart(
            @RequestParam("productId") Integer productId,
            @RequestParam(value = "quantity", defaultValue = "1") Integer quantity,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Users user = (Users) session.getAttribute("user");
            if (user == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                response.put("redirect", "/client/login");
                return ResponseEntity.status(401).body(response);
            }

            cartService.addToCart(user.getId(), productId, quantity);
            Integer cartItemCount = cartService.getCartItemCount(user.getId());

            response.put("success", true);
            response.put("message", "Đã thêm vào giỏ hàng!");
            response.put("cartItemCount", cartItemCount);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateQuantity(
            @RequestParam("productId") Integer productId,
            @RequestParam("quantity") Integer quantity,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Users user = (Users) session.getAttribute("user");
            if (user == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.status(401).body(response);
            }

            cartService.updateQuantity(user.getId(), productId, quantity);
            Double total = cartService.calculateTotal(user.getId());

            response.put("success", true);
            response.put("total", total);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @PostMapping("/remove")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> removeFromCart(
            @RequestParam("productId") Integer productId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Users user = (Users) session.getAttribute("user");
            if (user == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.status(401).body(response);
            }

            cartService.removeFromCart(user.getId(), productId);
            Integer cartItemCount = cartService.getCartItemCount(user.getId());
            Double total = cartService.calculateTotal(user.getId());

            response.put("success", true);
            response.put("message", "Đã xóa sản phẩm khỏi giỏ hàng");
            response.put("cartItemCount", cartItemCount);
            response.put("total", total);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @GetMapping("/count")
    @ResponseBody
    public ResponseEntity<Integer> getCartCount(HttpSession session) {
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.ok(0);
        }

        Integer count = cartService.getCartItemCount(user.getId());
        return ResponseEntity.ok(count);
    }
}