package com.devpro.treeshop.controller.client;

import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.model.WishlistItem;
import com.devpro.treeshop.service.CartService;
import com.devpro.treeshop.service.WishlistService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/client/wishlist")
public class WishlistController {

    private final WishlistService wishlistService;
    private final CartService cartService;

    public WishlistController(WishlistService wishlistService, CartService cartService) {
        this.wishlistService = wishlistService;
        this.cartService = cartService;
    }

    @GetMapping
    public String wishlist(Model model, HttpSession session) {
        Users user = (Users) session.getAttribute("user");
        model.addAttribute("currentUser", user);
        if (user == null) {
            return "redirect:/client/login?next=/client/wishlist";
        }
        List<WishlistItem> wishlistItems = wishlistService.getWishlistItems(user.getId());
        model.addAttribute("wishlistItems", wishlistItems);
        return "client/wishlist";
    }

    @PostMapping("/toggle")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggle(@RequestParam Integer productId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.put("success", false);
            response.put("redirect", "/client/login?next=/client/wishlist");
            response.put("message", "Vui lòng đăng nhập để dùng wishlist.");
            return ResponseEntity.status(401).body(response);
        }
        boolean liked = wishlistService.toggleWishlist(user.getId(), productId);
        response.put("success", true);
        response.put("liked", liked);
        response.put("message", liked ? "Đã thêm vào wishlist." : "Đã xóa khỏi wishlist.");
        response.put("wishlistCount", wishlistService.getWishlistCount(user.getId()));
        return ResponseEntity.ok(response);
    }

    @PostMapping("/move-to-cart")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> moveToCart(@RequestParam Integer productId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.put("success", false);
            response.put("redirect", "/client/login?next=/client/wishlist");
            response.put("message", "Vui lòng đăng nhập.");
            return ResponseEntity.status(401).body(response);
        }
        cartService.addToCart(user.getId(), productId, 1);
        wishlistService.removeFromWishlist(user.getId(), productId);
        response.put("success", true);
        response.put("message", "Đã chuyển sản phẩm sang giỏ hàng.");
        response.put("cartItemCount", cartService.getCartItemCount(user.getId()));
        response.put("wishlistCount", wishlistService.getWishlistCount(user.getId()));
        return ResponseEntity.ok(response);
    }

    @GetMapping("/count")
    @ResponseBody
    public ResponseEntity<Long> count(HttpSession session) {
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.ok(0L);
        }
        return ResponseEntity.ok(wishlistService.getWishlistCount(user.getId()));
    }
}
