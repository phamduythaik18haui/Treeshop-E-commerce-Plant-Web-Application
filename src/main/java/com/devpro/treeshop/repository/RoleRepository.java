package com.devpro.treeshop.repository;

import com.devpro.treeshop.model.Roles;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RoleRepository extends JpaRepository<Roles, Integer> {
}
