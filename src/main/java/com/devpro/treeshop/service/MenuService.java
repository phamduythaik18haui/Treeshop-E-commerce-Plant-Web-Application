package com.devpro.treeshop.service;

import com.devpro.treeshop.model.Menu;
import com.devpro.treeshop.repository.MenuRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class MenuService {

    @Autowired
    private MenuRepository menuRepository;

    public List<Menu> getActiveRootMenus(String menuType) {
        return menuRepository.findByMenuTypeIgnoreCaseAndActiveTrueAndParentIsNullOrderBySortOrderAscIdAsc(normalizeType(menuType));
    }

    public List<Menu> getRootMenus(String menuType) {
        return menuRepository.findByMenuTypeIgnoreCaseAndParentIsNullOrderBySortOrderAscIdAsc(normalizeType(menuType));
    }

    public List<Menu> getAllByType(String menuType) {
        return menuRepository.findByMenuTypeIgnoreCaseOrderBySortOrderAscIdAsc(normalizeType(menuType));
    }

    public List<Menu> getAllMenus() {
        return menuRepository.findAllByOrderByMenuTypeAscSortOrderAscIdAsc();
    }

    public Page<Menu> getPage(int page, int size, String keyword) {
        return menuRepository.search(keyword == null ? "" : keyword.trim(), PageRequest.of(page, size));
    }

    public Menu findById(Integer id) {
        return menuRepository.findById(id).orElseThrow();
    }

    @Transactional
    public Menu save(Menu menu, Integer parentId) {
        normalize(menu);
        if (parentId != null) {
            Menu parent = findById(parentId);
            // Không cho chọn chính nó làm menu cha khi sửa.
            if (menu.getId() == null || !parent.getId().equals(menu.getId())) {
                menu.setParent(parent);
            }
        } else {
            menu.setParent(null);
        }
        return menuRepository.save(menu);
    }

    @Transactional
    public void delete(Integer id) {
        Menu menu = findById(id);
        for (Menu child : menu.getChildren()) {
            child.setParent(null);
            menuRepository.save(child);
        }
        menuRepository.delete(menu);
    }

    private void normalize(Menu menu) {
        menu.setName(menu.getName() == null ? "" : menu.getName().trim());
        menu.setUrl(menu.getUrl() == null ? "#" : menu.getUrl().trim());
        menu.setIcon(menu.getIcon() == null ? "fa-solid fa-circle" : menu.getIcon().trim());
        menu.setMenuType(normalizeType(menu.getMenuType()));
        if (menu.getSortOrder() == null) {
            menu.setSortOrder(0);
        }
        if (menu.getActive() == null) {
            menu.setActive(false);
        }
    }

    private String normalizeType(String menuType) {
        return StringUtils.hasText(menuType) ? menuType.trim().toLowerCase() : "main";
    }
}
