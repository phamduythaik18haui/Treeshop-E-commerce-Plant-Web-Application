package com.devpro.treeshop.controller.client;

import com.devpro.treeshop.model.Roles;
import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/client")
public class LoginController {

    @Autowired
    private UserService userService;

    @Value("${social.google.client-id:}")
    private String googleClientId;

    @Value("${social.google.client-secret:}")
    private String googleClientSecret;

    @Value("${social.facebook.client-id:}")
    private String facebookClientId;

    @Value("${social.facebook.client-secret:}")
    private String facebookClientSecret;

    @GetMapping("/login")
    public String loginPage(HttpSession session,
                            Model model,
                            @RequestParam(value = "next", required = false) String next,
                            @RequestParam(value = "message", required = false) String message,
                            @RequestParam(value = "error", required = false) String error) {
        Users currentUser = (Users) session.getAttribute("user");
        if (currentUser != null) {
            boolean isAdmin = currentUser.getRoles() != null
                    && "ADMIN".equalsIgnoreCase(currentUser.getRoles().getName());
            return isAdmin ? "redirect:/admin" : "redirect:/client/indexs";
        }
        model.addAttribute("next", next);
        model.addAttribute("message", message);
        model.addAttribute("error", error);
        model.addAttribute("googleReady", googleClientId != null && !googleClientId.isBlank() && googleClientSecret != null && !googleClientSecret.isBlank());
        model.addAttribute("facebookReady", facebookClientId != null && !facebookClientId.isBlank() && facebookClientSecret != null && !facebookClientSecret.isBlank());
        return "client/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        @RequestParam(value = "next", required = false) String next,
                        HttpSession session) {

        Users user = userService.findAll().stream()
                .filter(u -> u.getEmail() != null && u.getPassword() != null)
                .filter(u -> u.getEmail().equalsIgnoreCase(email) && u.getPassword().equals(password))
                .findFirst()
                .orElse(null);

        if (user == null) {
            return "redirect:/client/login?error=invalid";
        }

        session.setAttribute("user", user);

        if (user.getRoles() != null && "ADMIN".equalsIgnoreCase(user.getRoles().getName())) {
            return "redirect:/admin";
        }

        if (next != null && !next.isBlank()) {
            return "redirect:" + next;
        }
        return "redirect:/client/indexs";
    }

    @PostMapping("/register")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> register(@RequestParam String firstName,
                                                        @RequestParam String lastName,
                                                        @RequestParam String email,
                                                        @RequestParam String phone,
                                                        @RequestParam String password) {
        Map<String, Object> response = new HashMap<>();
        try {
            boolean emailExists = userService.findByEmailIgnoreCase(email).isPresent();
            if (emailExists) {
                response.put("success", false);
                response.put("message", "Email đã được sử dụng");
                return ResponseEntity.status(409).body(response);
            }

            Roles defaultRole = new Roles();
            defaultRole.setId(3);

            Users newUser = new Users();
            newUser.setUsername(email);
            newUser.setEmail(email);
            newUser.setPhone(phone);
            newUser.setPassword(password);
            newUser.setFullName((firstName + " " + lastName).trim());
            newUser.setRoles(defaultRole);
            newUser.setProvider("LOCAL");
            userService.saveUser(newUser);

            response.put("success", true);
            response.put("message", "Đăng ký thành công");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi hệ thống: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/client/indexs";
    }
}
