package com.devpro.treeshop.service;

import com.devpro.treeshop.model.Products;
import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.model.WishlistItem;
import com.devpro.treeshop.repository.ProductRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class WishlistService {

    private static final String SESSION_PREFIX = "wishlist_product_ids_";

    private final ProductRepository productRepository;

    public WishlistService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<WishlistItem> getWishlistItems(Integer userId) {
        LinkedHashSet<Integer> productIds = getWishlistProductIds(userId);
        if (productIds.isEmpty()) {
            return Collections.emptyList();
        }

        Map<Integer, Products> productMap = productRepository.findAllById(productIds)
                .stream()
                .collect(Collectors.toMap(Products::getId, product -> product));

        Users user = new Users();
        user.setId(userId);

        List<WishlistItem> items = new ArrayList<>();
        for (Integer productId : productIds) {
            Products product = productMap.get(productId);
            if (product != null) {
                WishlistItem item = new WishlistItem();
                item.setUser(user);
                item.setProduct(product);
                items.add(item);
            }
        }
        return items;
    }

    public long getWishlistCount(Integer userId) {
        return getWishlistProductIds(userId).size();
    }

    public boolean isInWishlist(Integer userId, Integer productId) {
        return getWishlistProductIds(userId).contains(productId);
    }

    public void addToWishlist(Integer userId, Integer productId) {
        LinkedHashSet<Integer> productIds = getWishlistProductIds(userId);
        productIds.add(productId);
        saveWishlistProductIds(userId, productIds);
    }

    public void removeFromWishlist(Integer userId, Integer productId) {
        LinkedHashSet<Integer> productIds = getWishlistProductIds(userId);
        productIds.remove(productId);
        saveWishlistProductIds(userId, productIds);
    }

    public boolean toggleWishlist(Integer userId, Integer productId) {
        LinkedHashSet<Integer> productIds = getWishlistProductIds(userId);
        boolean liked;
        if (productIds.contains(productId)) {
            productIds.remove(productId);
            liked = false;
        } else {
            productIds.add(productId);
            liked = true;
        }
        saveWishlistProductIds(userId, productIds);
        return liked;
    }

    @SuppressWarnings("unchecked")
    private LinkedHashSet<Integer> getWishlistProductIds(Integer userId) {
        HttpSession session = currentSession();
        if (session == null || userId == null) {
            return new LinkedHashSet<>();
        }
        Object value = session.getAttribute(sessionKey(userId));
        if (value instanceof LinkedHashSet<?>) {
            return (LinkedHashSet<Integer>) value;
        }
        LinkedHashSet<Integer> ids = new LinkedHashSet<>();
        session.setAttribute(sessionKey(userId), ids);
        return ids;
    }

    private void saveWishlistProductIds(Integer userId, LinkedHashSet<Integer> productIds) {
        HttpSession session = currentSession();
        if (session != null && userId != null) {
            session.setAttribute(sessionKey(userId), productIds);
        }
    }

    private HttpSession currentSession() {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        return attributes != null ? attributes.getRequest().getSession() : null;
    }

    private String sessionKey(Integer userId) {
        return SESSION_PREFIX + userId;
    }
}
