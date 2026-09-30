package com.devpro.treeshop.service;

import com.devpro.treeshop.model.Category;
import com.devpro.treeshop.model.Products;
import com.devpro.treeshop.repository.CategoryRepository;
import com.devpro.treeshop.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

@Service
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private ProductRepository productRepository;

    public Page<Category> getPage(int page, int size, String keyword) {
        syncFromProductsIfEmpty();
        Pageable pageable = PageRequest.of(page, size, Sort.by("id").descending());
        if (StringUtils.hasText(keyword)) {
            return categoryRepository.findByNameContainingIgnoreCase(keyword.trim(), pageable);
        }
        return categoryRepository.findAll(pageable);
    }

    public List<Category> getActiveCategories() {
        syncFromProductsIfEmpty();
        return categoryRepository.findByActiveTrueOrderByNameAsc();
    }

    public List<Category> getAllCategories() {
        syncFromProductsIfEmpty();
        return categoryRepository.findAllByOrderByNameAsc();
    }

    public Category findById(Integer id) {
        return categoryRepository.findById(id).orElseThrow();
    }

    public long countAll() {
        syncFromProductsIfEmpty();
        return categoryRepository.count();
    }

    public long countActive() {
        syncFromProductsIfEmpty();
        return categoryRepository.findByActiveTrueOrderByNameAsc().size();
    }

    public long countProductsByCategory(String categoryName) {
        return productRepository.countByCategoriesIgnoreCase(categoryName);
    }

    public List<String> getCategoryNames() {
        List<String> names = new ArrayList<>();
        for (Category category : getActiveCategories()) {
            names.add(category.getName());
        }
        return names;
    }

    @Transactional
    public Category save(Category category) {
        String normalizedName = category.getName() == null ? "" : category.getName().trim();
        category.setName(normalizedName);
        if (!StringUtils.hasText(category.getDescription())) {
            category.setDescription("Danh mục " + normalizedName);
        } else {
            category.setDescription(category.getDescription().trim());
        }
        if (category.getActive() == null) {
            category.setActive(true);
        }
        if (category.getHomeDisplayLimit() == null || category.getHomeDisplayLimit() <= 0) {
            category.setHomeDisplayLimit(8);
        }
        return categoryRepository.save(category);
    }

    @Transactional
    public void delete(Integer id) {
        Category category = findById(id);
        categoryRepository.delete(category);
    }

    public boolean existsByName(String name) {
        return categoryRepository.existsByNameIgnoreCase(name == null ? "" : name.trim());
    }

    public boolean existsByNameAndNotId(String name, Integer id) {
        return categoryRepository.existsByNameIgnoreCaseAndIdNot(name == null ? "" : name.trim(), id);
    }

    @Transactional
    public void syncFromProductsIfEmpty() {
        if (categoryRepository.count() > 0) {
            return;
        }
        List<String> rawCategories = productRepository.findDistinctCategories();
        for (String rawCategory : rawCategories) {
            if (!StringUtils.hasText(rawCategory)) {
                continue;
            }
            Category category = new Category();
            category.setName(rawCategory.trim());
            category.setDescription("Đồng bộ từ sản phẩm hiện có");
            category.setActive(true);
            category.setHomeDisplayLimit(8);
            categoryRepository.save(category);
        }
    }

    @Transactional
    public void ensureCategoryExistsForProduct(Products product) {
        if (product == null || !StringUtils.hasText(product.getCategories())) {
            return;
        }
        String categoryName = product.getCategories().trim();
        if (categoryRepository.findByNameIgnoreCase(categoryName).isEmpty()) {
            Category category = new Category();
            category.setName(categoryName);
            category.setDescription("Tạo tự động từ sản phẩm");
            category.setActive(true);
            category.setHomeDisplayLimit(8);
            categoryRepository.save(category);
        }
    }
}
