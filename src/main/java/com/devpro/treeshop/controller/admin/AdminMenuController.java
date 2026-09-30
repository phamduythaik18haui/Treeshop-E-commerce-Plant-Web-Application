package com.devpro.treeshop.controller.admin;

import com.devpro.treeshop.model.Menu;
import com.devpro.treeshop.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/menus")
public class AdminMenuController {

    @Autowired
    private MenuService menuService;

    @GetMapping
    public String menuPage(@RequestParam(value = "page", defaultValue = "0") int page,
                           @RequestParam(value = "keyword", required = false) String keyword,
                           Model model) {
        Page<Menu> menusPage = menuService.getPage(page, 10, keyword);
        Menu newMenu = new Menu();
        newMenu.setActive(true);
        newMenu.setMenuType("main");
        newMenu.setSortOrder(0);

        model.addAttribute("menusPage", menusPage);
        model.addAttribute("menus", menusPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("keyword", keyword);
        model.addAttribute("newMenu", newMenu);
        model.addAttribute("parentOptions", menuService.getAllMenus());
        return "admin/menus";
    }

    @PostMapping("/create")
    public String create(@ModelAttribute("newMenu") Menu menu,
                         @RequestParam(value = "parentId", required = false) Integer parentId,
                         RedirectAttributes redirectAttributes) {
        if (menu.getName() == null || menu.getName().isBlank()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Tên menu không được để trống");
            return "redirect:/admin/menus";
        }
        menuService.save(menu, parentId);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm menu thành công");
        return "redirect:/admin/menus";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute Menu form,
                         @RequestParam(value = "parentId", required = false) Integer parentId,
                         RedirectAttributes redirectAttributes) {
        Menu current = menuService.findById(form.getId());
        current.setName(form.getName());
        current.setUrl(form.getUrl());
        current.setIcon(form.getIcon());
        current.setSortOrder(form.getSortOrder());
        current.setMenuType(form.getMenuType());
        current.setActive(Boolean.TRUE.equals(form.getActive()));
        menuService.save(current, parentId);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật menu thành công");
        return "redirect:/admin/menus";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        menuService.delete(id);
        redirectAttributes.addFlashAttribute("successMessage", "Xóa menu thành công");
        return "redirect:/admin/menus";
    }
}
