package com.devpro.treeshop.controller.admin;

import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/admin")
public class AdminLoginController {

    @Autowired
    private UserService userService;

    @GetMapping("/login")
    public String adminLoginPage(HttpSession session, Model model,
                                 @RequestParam(value = "error", required = false) String error) {
        Users currentUser = (Users) session.getAttribute("user");
        if (currentUser != null && currentUser.getRoles() != null
                && "ADMIN".equalsIgnoreCase(currentUser.getRoles().getName())) {
            return "redirect:/admin";
        }
        model.addAttribute("error", error != null);
        return "admin/login";
    }

    @PostMapping("/login")
    public String adminLogin(@RequestParam String email,
                             @RequestParam String password,
                             HttpSession session) {
        Users user = userService.findAll().stream()
                .filter(u -> u.getEmail() != null && u.getPassword() != null)
                .filter(u -> u.getEmail().equalsIgnoreCase(email) && u.getPassword().equals(password))
                .filter(u -> u.getRoles() != null && "ADMIN".equalsIgnoreCase(u.getRoles().getName()))
                .findFirst()
                .orElse(null);

        if (user == null) {
            return "redirect:/admin/login?error=true";
        }

        session.setAttribute("user", user);
        return "redirect:/admin";
    }
}
