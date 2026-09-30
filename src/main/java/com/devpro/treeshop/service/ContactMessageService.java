package com.devpro.treeshop.service;

import com.devpro.treeshop.model.ContactMessage;
import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.repository.ContactMessageRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ContactMessageService {

    private final ContactMessageRepository contactMessageRepository;

    public ContactMessageService(ContactMessageRepository contactMessageRepository) {
        this.contactMessageRepository = contactMessageRepository;
    }

    @Transactional
    public ContactMessage saveMessage(Users user,
                                      String fullName,
                                      String email,
                                      String phone,
                                      String subject,
                                      String message) {
        ContactMessage item = new ContactMessage();
        item.setUser(user);
        item.setFullName(fullName);
        item.setEmail(email);
        item.setPhone(phone);
        item.setSubject(subject);
        item.setMessage(message);
        item.setStatus("NEW");
        return contactMessageRepository.save(item);
    }

    public List<ContactMessage> getMessagesForUser(Integer userId) {
        return contactMessageRepository.findByUserIdOrderByCreatedDateDesc(userId);
    }

    public List<ContactMessage> getAllMessages() {
        return contactMessageRepository.findAllByOrderByCreatedDateDesc();
    }

    public ContactMessage findById(Integer id) {
        return contactMessageRepository.findById(id).orElseThrow();
    }

    @Transactional
    public void reply(Integer id, String adminReply) {
        ContactMessage message = findById(id);
        message.setAdminReply(adminReply);
        message.setRepliedDate(LocalDateTime.now());
        message.setStatus(StringUtils.hasText(adminReply) ? "REPLIED" : "NEW");
        contactMessageRepository.save(message);
    }
}
