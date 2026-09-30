package com.devpro.treeshop.repository;

import com.devpro.treeshop.model.ContactMessage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ContactMessageRepository extends JpaRepository<ContactMessage, Integer> {
    List<ContactMessage> findAllByOrderByCreatedDateDesc();
    List<ContactMessage> findByUserIdOrderByCreatedDateDesc(Integer userId);
}
