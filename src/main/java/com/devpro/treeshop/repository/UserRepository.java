package com.devpro.treeshop.repository;

import com.devpro.treeshop.model.Users;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<Users, Integer> {
    long countByRolesId(Integer roleId);
    Page<Users> findByRolesId(Integer roleId, Pageable pageable);
    Page<Users> findByFullNameContainingIgnoreCaseOrEmailContainingIgnoreCase(String fullName, String email, Pageable pageable);
    Optional<Users> findByEmailIgnoreCase(String email);
}
