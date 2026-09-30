package com.devpro.treeshop.service;

import com.devpro.treeshop.model.*;
import com.devpro.treeshop.repository.CartProductRepository;
import com.devpro.treeshop.repository.CartRepository;
import com.devpro.treeshop.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartProductRepository cartProductRepository;

    @Autowired
    private ProductRepository productRepository;

    @Transactional
    public void addToCart(Integer userId, Integer productId, Integer quantity) {
        // Tìm hoặc tạo giỏ hàng
        Cart cart = cartRepository.findByUserId(userId)
                .orElseGet(() -> {
                    Users user = new Users();
                    user.setId(userId);
                    Cart newCart = new Cart();
                    newCart.setUser(user);
                    return cartRepository.save(newCart);
                });

        // Tìm sản phẩm
        Products product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found: " + productId));

        // Kiểm tra sản phẩm đã có trong giỏ chưa (DÙNG THEO QUAN HỆ)
        var existingItem = cartProductRepository.findByCart_IdAndProduct_Id(cart.getId(), productId);

        if (existingItem.isPresent()) {
            // Cập nhật số lượng (tối thiểu 1)
            CartProduct item = existingItem.get();
            int newQty = Math.max(1, item.getQuantity() + (quantity == null ? 0 : quantity));
            item.setQuantity(newQty);
            cartProductRepository.save(item);
        } else {
            // Thêm mới
            CartProduct newItem = new CartProduct();
            newItem.setId(new CartProductId(cart.getId(), productId));
            newItem.setCart(cart);
            newItem.setProduct(product);
            newItem.setQuantity(Math.max(1, quantity == null ? 1 : quantity));
            // DÙNG Double nhất quán (tránh floatValue)
            newItem.setPrice(product.getPrice()); // product.getPrice() là Double theo entity của bạn
            cartProductRepository.save(newItem);
        }

        // Cập nhật tổng giỏ hàng
        updateCartTotal(cart.getId());
    }

    public List<CartProduct> getCartItems(Integer userId) {
        return cartProductRepository.findByUserId(userId);
    }

    public Integer getCartItemCount(Integer userId) {
        return cartRepository.countCartItemsByUserId(userId);
    }

    public Double calculateTotal(Integer userId) {
        return cartRepository.findByUserId(userId)
                .map(cart -> cartProductRepository.calculateCartTotal(cart.getId()))
                .orElse(0D);
    }

    @Transactional
    public void removeFromCart(Integer userId, Integer productId) {
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cart not found"));
        cartProductRepository.deleteByCartIdAndProductId(cart.getId(), productId);
        updateCartTotal(cart.getId());
    }

    @Transactional
    public void updateQuantity(Integer userId, Integer productId, Integer quantity) {
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cart not found"));

        CartProduct item = cartProductRepository.findByCart_IdAndProduct_Id(cart.getId(), productId)
                .orElseThrow(() -> new RuntimeException("Item not found in cart"));

        item.setQuantity(Math.max(1, quantity == null ? 1 : quantity));
        cartProductRepository.save(item);
        updateCartTotal(cart.getId());
    }

    @Transactional
    public void clearCart(Integer userId) {
        cartRepository.findByUserId(userId).ifPresent(cart -> {
            var items = cartProductRepository.findByCart_Id(cart.getId());
            for (var it : items) {
                cartProductRepository.deleteByCartIdAndProductId(cart.getId(), it.getProduct().getId());
            }
            updateCartTotal(cart.getId());
        });
    }

    private void updateCartTotal(Integer cartId) {
        Double total = cartProductRepository.calculateCartTotal(cartId);
        Cart cart = cartRepository.findById(cartId).orElseThrow();
        // Schema của bạn để carts.sum là INT → tạm thời ép về int
        cart.setSum(total != null ? total.intValue() : 0);
        cartRepository.save(cart);
    }
}
