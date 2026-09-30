package com.devpro.treeshop.dto;

import com.devpro.treeshop.model.Category;
import com.devpro.treeshop.model.Products;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class HomeCategorySection {
    private Category category;
    private List<Products> products;
}
