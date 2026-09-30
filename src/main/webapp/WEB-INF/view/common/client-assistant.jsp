<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<button type="button" id="scrollTopBtn" class="scroll-top-btn" aria-label="Lên đầu trang">
    <i class="fas fa-arrow-up"></i>
</button>

<div class="contact-fab" id="contactFab">
    <button type="button" class="contact-fab-toggle" id="contactFabToggle" aria-label="Mở liên hệ nhanh">
        <i class="fa-brands fa-facebook-messenger"></i>
    </button>
    <div class="contact-fab-menu" id="contactFabMenu">
        <a href="sms:+84978917562" class="contact-fab-item sms" title="SMS">
            <i class="fas fa-sms"></i>
            <span>SMS</span>
        </a>
        <a href="https://zalo.me" target="_blank" rel="noopener" class="contact-fab-item zalo" title="Zalo">
            <i class="fas fa-comment-dots"></i>
            <span>Zalo</span>
        </a>
        <a href="https://facebook.com" target="_blank" rel="noopener" class="contact-fab-item facebook" title="Facebook">
            <i class="fa-brands fa-facebook-messenger"></i>
            <span>Facebook</span>
        </a>
    </div>
</div>

<div class="assistant-widget" id="assistantWidget">
    <button type="button" class="assistant-trigger" id="assistantTrigger">
        <span class="assistant-dot"></span>
        <i class="fas fa-robot"></i>
        <span>AI trợ lý</span>
    </button>

    <div class="assistant-panel" id="assistantPanel">
        <div class="assistant-header">
            <div>
                <strong>Treeshop AI</strong>
                <div class="assistant-subtitle">Tư vấn cây cảnh và mua hàng cơ bản</div>
            </div>
            <button type="button" class="assistant-close" id="assistantClose" aria-label="Đóng trợ lý">
                <i class="fas fa-times"></i>
            </button>
        </div>

        <div class="assistant-messages" id="assistantMessages">
            <div class="assistant-message assistant-message-bot">
                Xin chào, mình có thể gợi ý cây để bàn, cây phong thủy, cách chăm sóc, giá sản phẩm hoặc hướng dẫn đặt hàng cho bạn.
            </div>
        </div>

        <div class="assistant-quick-replies" id="assistantQuickReplies">
            <button type="button" class="assistant-chip">Gợi ý cây để bàn</button>
            <button type="button" class="assistant-chip">Cây phong thủy</button>
            <button type="button" class="assistant-chip">Cách chăm cây</button>
            <button type="button" class="assistant-chip">Hướng dẫn mua hàng</button>
        </div>

        <form id="assistantForm" class="assistant-form">
            <input type="text" id="assistantInput" placeholder="Nhập câu hỏi của bạn..." autocomplete="off">
            <button type="submit" aria-label="Gửi tin nhắn"><i class="fas fa-paper-plane"></i></button>
        </form>
    </div>
</div>
