package com.devpro.treeshop.controller.client;

import com.devpro.treeshop.model.Products;
import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.service.CategoryService;
import com.devpro.treeshop.service.ProductService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/client/categories")
public class CategoriesController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    @GetMapping
    public String getCategories(Model model,
                                HttpSession session,
                                @RequestParam(name = "category", required = false) String category,
                                @RequestParam(name = "keyword", required = false) String keyword,
                                @RequestParam(name = "page", required = false, defaultValue = "0") int page) {
        Users user = (Users) session.getAttribute("user");
        model.addAttribute("currentUser", user);

        Pageable pageable = PageRequest.of(page, 9);
        Page<Products> productsPage = productService.findByFilter(category, keyword, pageable);
        model.addAttribute("productsPage", productsPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", productsPage.getTotalPages());
        model.addAttribute("category", category);
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryNames", categoryService.getCategoryNames());

        return "client/categories";
    }
}
