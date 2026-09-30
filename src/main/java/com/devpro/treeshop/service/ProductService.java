package com.devpro.treeshop.service;

import com.devpro.treeshop.model.Products;
import com.devpro.treeshop.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class ProductService {
    @Autowired
    private ProductRepository productRepository;

    public List<Products> findAll() {
        return productRepository.findAll();
    }

    public void deleteProduct(int id) {
        productRepository.deleteById(id);
    }

    public Products findById(int id) {
        return productRepository.findById(id).orElseThrow();
    }

    public void save(Products product) {
        productRepository.save(product);
    }

    public List<Products> findFeaturedProducts() {
        return productRepository.findByIsHotTrue();
    }

    public List<Products> findBestSellingProducts() {
        return productRepository.findTop8ByOrderBySoldDesc();
    }

    public List<Products> findByCategoriesContaining(String category) {
        return productRepository.findByCategoriesContaining(category);
    }

    public Page<Products> getAllProducts(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("id").descending());
        return productRepository.findAll(pageable);
    }

    public Page<Products> getProductsByCategory(String category, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("id").descending());
        return productRepository.findByCategoriesIgnoreCase(category, pageable);
    }

    public Page<Products> searchProducts(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("id").descending());
        return productRepository.findByNameContainingIgnoreCase(keyword, pageable);
    }

    public Page<Products> findByFilter(String category, String keyword, Pageable pageable) {
        if (StringUtils.hasText(category)) {
            return productRepository.findByCategoriesContainingIgnoreCase(category.trim(), pageable);
        }
        if (StringUtils.hasText(keyword)) {
            return productRepository.findByNameContainingIgnoreCase(keyword.trim(), pageable);
        }
        return productRepository.findAll(pageable);
    }

    public Page<Products> getAdminProducts(String keyword, String category, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("id").descending());
        if (StringUtils.hasText(keyword)) {
            return productRepository.findByNameContainingIgnoreCase(keyword.trim(), pageable);
        }
        if (StringUtils.hasText(category)) {
            return productRepository.findByCategoriesContainingIgnoreCase(category.trim(), pageable);
        }
        return productRepository.findAll(pageable);
    }

    public List<String> getDistinctCategoryNames() {
        return productRepository.findDistinctCategories();
    }

    public List<Products> findHomeProductsByCategory(String category, int limit) {
        int safeLimit = Math.max(1, Math.min(limit, 24));
        Pageable pageable = PageRequest.of(0, safeLimit, Sort.by("id").descending());
        return productRepository.findByCategoriesContainingIgnoreCase(category, pageable).getContent();
    }

    public List<Products> findNewestProducts(int limit) {
        int safeLimit = Math.max(1, Math.min(limit, 24));
        Pageable pageable = PageRequest.of(0, safeLimit, Sort.by("id").descending());
        return productRepository.findAll(pageable).getContent();
    }

}
