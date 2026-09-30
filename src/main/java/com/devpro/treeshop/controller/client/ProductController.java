package com.devpro.treeshop.controller.client;

import com.devpro.treeshop.model.Products;
import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.service.ProductService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/client/products")
public class ProductController {
    @Autowired
    private ProductService productService;

    @GetMapping
    public String getProducts(Model model, HttpSession session) {
        Users user = (Users) session.getAttribute("user");
        model.addAttribute("currentUser", user);

        List<Products> featuredProducts = productService.findFeaturedProducts();
        List<Products> bestSellingProducts = productService.findBestSellingProducts();

        model.addAttribute("featuredProducts", featuredProducts);
        model.addAttribute("bestSellingProducts", bestSellingProducts);

        return "client/product";
    }

    @GetMapping("/{id}")
    public String productDetail(@PathVariable Integer id, Model model, HttpSession session) {
        Users user = (Users) session.getAttribute("user");
        Products product = productService.findById(id);
        model.addAttribute("currentUser", user);
        model.addAttribute("product", product);
        model.addAttribute("relatedProducts", productService.findByCategoriesContaining(product.getCategories()));
        return "client/product-detail";
    }
}
