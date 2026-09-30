package com.devpro.treeshop.controller.admin;

import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/users")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping
    public String userPage(@RequestParam(value = "page", defaultValue = "0") int page,
                           @RequestParam(value = "keyword", required = false) String keyword,
                           @RequestParam(value = "roleId", required = false) Integer roleId,
                           Model model) {
        Page<Users> usersPage = this.userService.getAdminUsers(keyword, roleId, page, 8);
        model.addAttribute("usersList", usersPage.getContent());
        model.addAttribute("usersPage", usersPage);
        model.addAttribute("newUser", new Users());
        model.addAttribute("currentPage", page);
        model.addAttribute("keyword", keyword);
        model.addAttribute("roleId", roleId);
        model.addAttribute("totalUser", this.userService.findAll().size());
        model.addAttribute("adminCount", this.userService.countUsersByRolesId(1));
        model.addAttribute("staffCount", this.userService.countUsersByRolesId(2));
        model.addAttribute("clientCount", this.userService.countUsersByRolesId(3));
        return "admin/user/users";
    }

    @PostMapping("/create")
    public String createUser(@ModelAttribute("newUser") Users user) {
        this.userService.saveUser(user);
        return "redirect:/admin/users";
    }

    @GetMapping("/delete/{id}")
    public String deleteUser(@PathVariable int id) {
        this.userService.deleteUser(id);
        return "redirect:/admin/users";
    }

    @GetMapping("/views/{id}")
    public String viewUser(@PathVariable int id, Model model) {
        model.addAttribute("user", this.userService.findUserById(id));
        return "admin/user/view";
    }

    @GetMapping("/update/{id}")
    public String editUser(@PathVariable int id, Model model) {
        model.addAttribute("user", userService.findUserById(id));
        return "admin/user/update";
    }

    @PostMapping("/update")
    public String updateUser(@ModelAttribute("user") Users user) {
        Users user1 = this.userService.findUserById(user.getId());
        user1.setAddress(user.getAddress());
        user1.setFullName(user.getFullName());
        user1.setPhone(user.getPhone());
        user1.setRoles(user.getRoles());
        this.userService.saveUser(user1);
        return "redirect:/admin/users";
    }
}
