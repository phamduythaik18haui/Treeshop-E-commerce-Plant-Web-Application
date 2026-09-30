package com.devpro.treeshop.controller.admin;

import com.devpro.treeshop.service.ContactMessageService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/messages")
public class AdminMessageController {

    private final ContactMessageService contactMessageService;

    public AdminMessageController(ContactMessageService contactMessageService) {
        this.contactMessageService = contactMessageService;
    }

    @GetMapping
    public String index(Model model) {
        model.addAttribute("messages", contactMessageService.getAllMessages());
        return "admin/message/messages";
    }

    @PostMapping("/{id}/reply")
    public String reply(@PathVariable Integer id,
                        @RequestParam String adminReply,
                        RedirectAttributes redirectAttributes) {
        contactMessageService.reply(id, adminReply);
        redirectAttributes.addFlashAttribute("successMessage", "Đã gửi phản hồi cho khách hàng.");
        return "redirect:/admin/messages";
    }
}
