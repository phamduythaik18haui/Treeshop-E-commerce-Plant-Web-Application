package com.devpro.treeshop.configurer.config;

import com.devpro.treeshop.model.Menu;
import com.devpro.treeshop.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.Collections;
import java.util.List;

@ControllerAdvice
public class GlobalModelAttribute {

    @Autowired(required = false)
    private MenuService menuService;

    @ModelAttribute("mainMenus")
    public List<Menu> mainMenus() {
        if (menuService == null) {
            return Collections.emptyList();
        }
        return menuService.getActiveRootMenus("main");
    }

    @ModelAttribute("adminMenus")
    public List<Menu> adminMenus() {
        if (menuService == null) {
            return Collections.emptyList();
        }
        return menuService.getActiveRootMenus("admin");
    }
}
