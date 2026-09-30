package com.devpro.treeshop.service;

import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public List<Users> findAll() {
        return userRepository.findAll();
    }

    public Users saveUser(Users user) {
        return userRepository.save(user);
    }

    public long countUsersByRolesId(Integer roleId) {
        return userRepository.countByRolesId(roleId);
    }

    public void deleteUser(int id) {
        userRepository.deleteById(id);
    }

    public Users findUserById(int id) {
        return userRepository.findById(id).orElseThrow();
    }

    public Optional<Users> findByEmailIgnoreCase(String email) {
        return userRepository.findByEmailIgnoreCase(email);
    }

    public Page<Users> getAdminUsers(String keyword, Integer roleId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("id").descending());
        if (roleId != null) {
            return userRepository.findByRolesId(roleId, pageable);
        }
        if (StringUtils.hasText(keyword)) {
            return userRepository.findByFullNameContainingIgnoreCaseOrEmailContainingIgnoreCase(keyword.trim(), keyword.trim(), pageable);
        }
        return userRepository.findAll(pageable);
    }
}
