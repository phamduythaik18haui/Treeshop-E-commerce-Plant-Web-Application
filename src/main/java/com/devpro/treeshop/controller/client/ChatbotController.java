package com.devpro.treeshop.controller.client;

import com.devpro.treeshop.model.Products;
import com.devpro.treeshop.service.CategoryService;
import com.devpro.treeshop.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.text.Normalizer;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/client/chatbot")
public class ChatbotController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    @PostMapping(value = "/message", produces = "application/json;charset=UTF-8")
    public ResponseEntity<Map<String, Object>> message(@RequestParam("message") String message) {
        String normalized = normalize(message);
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("reply", buildReply(message, normalized));
        response.put("quickReplies", quickRepliesFor(normalized));
        response.put("products", productMatches(normalized));
        return ResponseEntity.ok(response);
    }

    private String buildReply(String rawMessage, String normalized) {
        if (normalized.isBlank()) {
            return "Bạn có thể hỏi mình về cây để bàn, cây phong thủy, cách chăm sóc, giá sản phẩm, đơn hàng hoặc cách đăng nhập nhanh nhé.";
        }
        if (containsAny(normalized, "xin chao", "chao", "hello", "hi")) {
            return "Xin chào, mình là trợ lý Treeshop. Mình có thể gợi ý cây theo không gian, ngân sách hoặc nhu cầu phong thủy cho bạn.";
        }
        if (containsAny(normalized, "gia", "bao nhieu tien", "chi phi")) {
            return "Bạn có thể hỏi theo tên cây hoặc danh mục, ví dụ: giá cây kim tiền, cây để bàn, cây nội thất. Mình sẽ gợi ý sản phẩm phù hợp ngay trong khung chat.";
        }
        if (containsAny(normalized, "phong thuy", "may man", "tai loc")) {
            return "Nếu bạn thích cây phong thủy, mình gợi ý ưu tiên các nhóm cây mang ý nghĩa tài lộc như kim tiền, ngọc ngân hoặc trầu bà. Bạn có thể bấm vào gợi ý sản phẩm để xem chi tiết.";
        }
        if (containsAny(normalized, "de ban", "van phong", "lam viec")) {
            return "Với bàn làm việc hoặc văn phòng, bạn nên chọn cây nhỏ gọn, dễ chăm như lưỡi hổ mini, sen đá hoặc kim tiền mini. Các gợi ý liên quan sẽ hiện ngay bên dưới.";
        }
        if (containsAny(normalized, "cham soc", "tuoi", "anh sang", "phan bon")) {
            return "Nguyên tắc cơ bản: tưới vừa đủ, tránh úng, đặt nơi có ánh sáng tán xạ và lau lá định kỳ. Nếu bạn nói tên cây cụ thể, mình sẽ hướng dẫn chăm sóc sát hơn.";
        }
        if (containsAny(normalized, "giao hang", "ship", "van chuyen")) {
            return "Treeshop có hỗ trợ giao hàng. Bạn thêm cây vào giỏ, vào checkout rồi chọn phương thức thanh toán. Nếu cần, mình có thể hướng dẫn từng bước.";
        }
        if (containsAny(normalized, "dang nhap", "google", "facebook")) {
            return "Bạn có thể đăng nhập bằng tài khoản thường, Google hoặc Facebook. Nếu nút social chưa chạy, hãy kiểm tra lại client id, client secret và redirect URI trong application.properties.";
        }
        if (containsAny(normalized, "don hang", "cart", "gio hang", "thanh toan")) {
            return "Để mua hàng: chọn sản phẩm -> thêm vào giỏ -> mở giỏ hàng -> checkout. Nếu bạn đang phân vân, mình sẽ gợi ý vài cây phù hợp trước.";
        }
        List<Map<String, Object>> products = productMatches(normalized);
        if (!products.isEmpty()) {
            return "Mình đã tìm thấy vài sản phẩm gần với yêu cầu của bạn. Bạn có thể bấm xem chi tiết hoặc thêm vào giỏ ngay từ danh sách gợi ý.";
        }
        if (!categoryService.getCategoryNames().isEmpty()) {
            return "Mình chưa hiểu trọn ý đó, nhưng bạn có thể hỏi theo danh mục như: " + String.join(", ", categoryService.getCategoryNames().stream().limit(4).collect(Collectors.toList())) + ".";
        }
        return "Mình chưa hiểu rõ. Bạn thử hỏi theo tên cây, danh mục, giá, chăm sóc, đơn hàng hoặc đăng nhập nhé.";
    }

    private List<String> quickRepliesFor(String normalized) {
        if (containsAny(normalized, "cham soc", "tuoi", "anh sang")) {
            return List.of("Cây để bàn dễ chăm", "Cây phong thủy", "Giá cây hot", "Cách tưới cây");
        }
        return List.of("Gợi ý cây để bàn", "Cây phong thủy", "Cách chăm cây", "Hướng dẫn mua hàng");
    }

    private List<Map<String, Object>> productMatches(String normalized) {
        if (normalized.isBlank()) {
            return Collections.emptyList();
        }
        List<Products> allProducts = productService.findAll();
        return allProducts.stream()
                .filter(p -> matches(normalized, p))
                .limit(4)
                .map(p -> {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("id", p.getId());
                    item.put("name", p.getName());
                    item.put("category", p.getCategories());
                    item.put("price", p.getPrice());
                    item.put("image", p.getImage());
                    return item;
                })
                .collect(Collectors.toList());
    }

    private boolean matches(String normalized, Products product) {
        String productName = normalize(product.getName());
        String categoryName = normalize(product.getCategories());
        return productName.contains(normalized)
                || categoryName.contains(normalized)
                || normalized.contains(productName)
                || normalized.contains(categoryName)
                || Arrays.stream(normalized.split("\\s+")).anyMatch(token -> token.length() > 2 && (productName.contains(token) || categoryName.contains(token)));
    }

    private boolean containsAny(String source, String... values) {
        for (String value : values) {
            if (source.contains(value)) {
                return true;
            }
        }
        return false;
    }

    private String normalize(String value) {
        if (value == null) {
            return "";
        }
        String noAccent = Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "")
                .replace('đ', 'd')
                .replace('Đ', 'D');
        return noAccent.toLowerCase(Locale.ROOT).trim();
    }
}
