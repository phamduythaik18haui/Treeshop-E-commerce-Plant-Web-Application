package com.devpro.treeshop.controller.client;

import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.service.ContactMessageService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/client/contact")
public class ContactController {

    private final ContactMessageService contactMessageService;

    public ContactController(ContactMessageService contactMessageService) {
        this.contactMessageService = contactMessageService;
    }

    @GetMapping
    public String showForm(Model model, HttpSession session) {
        Users user = (Users) session.getAttribute("user");
        model.addAttribute("currentUser", user);
        if (user != null) {
            model.addAttribute("messageHistory", contactMessageService.getMessagesForUser(user.getId()));
        }
        return "client/contact";
    }

    @PostMapping
    public String submit(@RequestParam String fullName,
                         @RequestParam String email,
                         @RequestParam(required = false) String phone,
                         @RequestParam String subject,
                         @RequestParam String message,
                         HttpSession session,
                         RedirectAttributes ra) {
        Users user = (Users) session.getAttribute("user");
        contactMessageService.saveMessage(user, fullName, email, phone, subject, message);
        ra.addFlashAttribute("success", "Treeshop đã nhận được tin nhắn của bạn. Admin sẽ phản hồi ngay khi xử lý xong.");
        return "redirect:/client/contact";
    }
}
