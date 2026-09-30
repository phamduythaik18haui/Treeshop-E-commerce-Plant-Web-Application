package com.devpro.treeshop.repository;

import com.devpro.treeshop.model.Menu;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface MenuRepository extends JpaRepository<Menu, Integer> {
    List<Menu> findByMenuTypeIgnoreCaseAndActiveTrueAndParentIsNullOrderBySortOrderAscIdAsc(String menuType);
    List<Menu> findByMenuTypeIgnoreCaseAndParentIsNullOrderBySortOrderAscIdAsc(String menuType);
    List<Menu> findByMenuTypeIgnoreCaseOrderBySortOrderAscIdAsc(String menuType);
    List<Menu> findAllByOrderByMenuTypeAscSortOrderAscIdAsc();

    @Query("select m from Menu m where (:keyword is null or :keyword = '' or lower(m.name) like lower(concat('%', :keyword, '%')) or lower(m.url) like lower(concat('%', :keyword, '%'))) order by m.menuType asc, m.sortOrder asc, m.id asc")
    Page<Menu> search(@Param("keyword") String keyword, Pageable pageable);
}
