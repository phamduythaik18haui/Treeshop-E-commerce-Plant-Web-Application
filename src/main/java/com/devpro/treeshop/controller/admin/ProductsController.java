package com.devpro.treeshop.controller.admin;

import com.devpro.treeshop.model.Products;
import com.devpro.treeshop.service.CategoryService;
import com.devpro.treeshop.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Controller
@RequestMapping("/admin/products")
public class ProductsController {
    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    @Value("${file.upload-dir:src/main/resources/static/uploads/}")
    private String uploadDir;

    @GetMapping
    public String productList(@RequestParam(value = "page", defaultValue = "0") int page,
                              @RequestParam(value = "keyword", required = false) String keyword,
                              @RequestParam(value = "category", required = false) String category,
                              Model model) {
        Page<Products> productsPage = productService.getAdminProducts(keyword, category, page, 8);
        model.addAttribute("newProduct", new Products());
        model.addAttribute("productsPage", productsPage);
        model.addAttribute("productsList", productsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("keyword", keyword);
        model.addAttribute("category", category);
        model.addAttribute("categoryOptions", categoryService.getAllCategories());
        return "admin/product/products";
    }

    @PostMapping("/create")
    public String createProduct(@ModelAttribute("newProduct") Products product,
                                BindingResult result,
                                @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                @RequestParam(value = "imageDetailFile", required = false) MultipartFile imageDetailFile,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("categoryOptions", categoryService.getAllCategories());
            return "admin/product/products";
        }

        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                product.setImage(saveImage(imageFile));
            }
            if (imageDetailFile != null && !imageDetailFile.isEmpty()) {
                product.setImageDetail(saveImage(imageDetailFile));
            }
            productService.save(product);
            categoryService.ensureCategoryExistsForProduct(product);
            redirectAttributes.addFlashAttribute("successMessage", "Thêm sản phẩm thành công!");
            return "redirect:/admin/products";
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi thêm sản phẩm: " + e.getMessage());
            model.addAttribute("categoryOptions", categoryService.getAllCategories());
            return "admin/product/products";
        }
    }

    private String saveImage(MultipartFile file) throws IOException {
        Path path = Paths.get(uploadDir);
        if (!Files.exists(path)) {
            Files.createDirectories(path);
        }
        String originalFileName = file.getOriginalFilename();
        String extension = "";
        if (originalFileName != null && originalFileName.contains(".")) {
            extension = originalFileName.substring(originalFileName.lastIndexOf('.'));
        }
        String fileName = UUID.randomUUID() + extension;
        file.transferTo(path.resolve(fileName).toFile());
        return fileName;
    }

    @GetMapping("/delete/{id}")
    public String deleteProduct(@PathVariable int id) {
        this.productService.deleteProduct(id);
        return "redirect:/admin/products";
    }

    @GetMapping("/view/{id}")
    public String viewProduct(@PathVariable int id, Model model) {
        model.addAttribute("product", this.productService.findById(id));
        return "admin/product/view";
    }

    @GetMapping("/update/{id}")
    public String editProduct(@PathVariable int id, Model model) {
        model.addAttribute("product", this.productService.findById(id));
        model.addAttribute("categoryOptions", categoryService.getAllCategories());
        return "admin/product/update";
    }

    @PostMapping("/update")
    public String updateProduct(@ModelAttribute("product") Products product,
                                @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                @RequestParam(value = "imageDetailFile", required = false) MultipartFile imageDetailFile) throws IOException {
        Products oldProduct = this.productService.findById(product.getId());
        oldProduct.setName(product.getName());
        oldProduct.setPrice(product.getPrice());
        oldProduct.setQuantity(product.getQuantity());
        oldProduct.setShortDesc(product.getShortDesc());
        oldProduct.setDetailDesc(product.getDetailDesc());
        oldProduct.setCategories(product.getCategories());
        oldProduct.setIsHot(product.getIsHot());
        oldProduct.setIsNew(product.getIsNew());
        if (imageFile != null && !imageFile.isEmpty()) {
            oldProduct.setImage(saveImage(imageFile));
        }
        if (imageDetailFile != null && !imageDetailFile.isEmpty()) {
            oldProduct.setImageDetail(saveImage(imageDetailFile));
        }
        this.productService.save(oldProduct);
        categoryService.ensureCategoryExistsForProduct(oldProduct);
        return "redirect:/admin/products";
    }
}
