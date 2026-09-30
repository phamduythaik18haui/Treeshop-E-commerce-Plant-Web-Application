package com.devpro.treeshop.controller.admin;

import com.devpro.treeshop.model.Category;
import com.devpro.treeshop.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;

import java.util.HashMap;
import java.util.Map;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/categories")
public class AdminCategoriesController {

    @Autowired
    private CategoryService categoryService;

    @GetMapping
    public String adminCategories(@RequestParam(value = "page", defaultValue = "0") int page,
                                  @RequestParam(value = "keyword", required = false) String keyword,
                                  Model model) {
        Page<Category> categoriesPage = categoryService.getPage(page, 8, keyword);
        model.addAttribute("categoriesPage", categoriesPage);
        model.addAttribute("categories", categoriesPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("keyword", keyword);
        Map<String, Long> categoryProductCounts = new HashMap<>();
        for (Category category : categoriesPage.getContent()) {
            categoryProductCounts.put(category.getName(), categoryService.countProductsByCategory(category.getName()));
        }
        Category newCategory = new Category();
        newCategory.setActive(true);
        model.addAttribute("newCategory", newCategory);
        model.addAttribute("categoryProductCounts", categoryProductCounts);
        model.addAttribute("totalCategories", categoryService.countAll());
        model.addAttribute("activeCategories", categoryService.countActive());
        return "admin/categories";
    }

    @PostMapping("/create")
    public String createCategory(@ModelAttribute("newCategory") Category category,
                                 RedirectAttributes redirectAttributes) {
        if (category.getName() == null || category.getName().isBlank()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Tên danh mục không được để trống");
            return "redirect:/admin/categories";
        }
        if (categoryService.existsByName(category.getName())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Danh mục đã tồn tại");
            return "redirect:/admin/categories";
        }
        categoryService.save(category);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm danh mục thành công");
        return "redirect:/admin/categories";
    }

    @PostMapping("/update")
    public String updateCategory(@ModelAttribute Category category,
                                 RedirectAttributes redirectAttributes) {
        if (categoryService.existsByNameAndNotId(category.getName(), category.getId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Tên danh mục đã tồn tại");
            return "redirect:/admin/categories";
        }
        Category current = categoryService.findById(category.getId());
        current.setName(category.getName());
        current.setDescription(category.getDescription());
        current.setHomeDisplayLimit(category.getHomeDisplayLimit());
        current.setActive(Boolean.TRUE.equals(category.getActive()));
        categoryService.save(current);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật danh mục thành công");
        return "redirect:/admin/categories";
    }

    @PostMapping("/delete/{id}")
    public String deleteCategory(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        Category category = categoryService.findById(id);
        if (categoryService.countProductsByCategory(category.getName()) > 0) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể xóa danh mục đang có sản phẩm");
            return "redirect:/admin/categories";
        }
        categoryService.delete(id);
        redirectAttributes.addFlashAttribute("successMessage", "Xóa danh mục thành công");
        return "redirect:/admin/categories";
    }
}
