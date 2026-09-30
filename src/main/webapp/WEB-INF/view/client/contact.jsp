<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên hệ | Treeshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-shared.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-ai.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/view/common/client-navbar.jsp"><jsp:param name="active" value="contact"/></jsp:include>
<section class="page-heading">
    <div class="container">
        <div class="product-mini-tag"><i class="fa-regular fa-envelope"></i> Hỗ trợ khách hàng</div>
        <h1 class="section-title mb-2">Gửi tin nhắn cho Treeshop</h1>
        <p class="text-muted mb-0">Tin nhắn của bạn sẽ hiện ở admin để shop phản hồi trực tiếp ngay trong hệ thống.</p>
    </div>
</section>
<main class="container pb-5">
    <div class="row g-4">
        <div class="col-lg-5">
            <div class="client-card p-4 h-100">
                <h4 class="fw-bold mb-3">Thông tin liên hệ</h4>
                <div class="message-bubble mb-3"><i class="fa-solid fa-location-dot text-success me-2"></i>Lập Thạch, Vĩnh Phúc</div>
                <div class="message-bubble mb-3"><i class="fa-solid fa-phone text-success me-2"></i>0978 917 562</div>
                <div class="message-bubble mb-3"><i class="fa-solid fa-envelope text-success me-2"></i>caodozett@gmail.com</div>
                <div class="message-bubble"><i class="fa-solid fa-clock text-success me-2"></i>08:00 - 20:00 mỗi ngày</div>
            </div>
        </div>
        <div class="col-lg-7">
            <div class="client-card p-4">
                <c:if test="${not empty success}"><div class="alert alert-success rounded-4">${success}</div></c:if>
                <form method="post" action="<c:url value='/client/contact'/>">
                    <div class="row g-3">
                        <div class="col-md-6"><label class="form-label">Họ và tên</label><input class="form-control rounded-4" name="fullName" value="${not empty currentUser ? currentUser.fullName : ''}" required></div>
                        <div class="col-md-6"><label class="form-label">Email</label><input type="email" class="form-control rounded-4" name="email" value="${not empty currentUser ? currentUser.email : ''}" required></div>
                        <div class="col-md-6"><label class="form-label">Số điện thoại</label><input class="form-control rounded-4" name="phone" value="${not empty currentUser ? currentUser.phone : ''}"></div>
                        <div class="col-md-6"><label class="form-label">Chủ đề</label>
                            <select name="subject" class="form-select rounded-4">
                                <option value="Tư vấn chọn cây">Tư vấn chọn cây</option>
                                <option value="Đơn hàng & Vận chuyển">Đơn hàng & Vận chuyển</option>
                                <option value="Bảo hành & Chăm sóc">Bảo hành & Chăm sóc</option>
                                <option value="Khác">Khác</option>
                            </select>
                        </div>
                        <div class="col-12"><label class="form-label">Nội dung</label><textarea class="form-control rounded-4" name="message" rows="5" required placeholder="Mô tả nhu cầu của bạn..."></textarea></div>
                    </div>
                    <button class="btn btn-success rounded-pill px-4 mt-4"><i class="fa-regular fa-paper-plane me-2"></i>Gửi tin nhắn</button>
                </form>
            </div>
        </div>
    </div>

    <c:if test="${not empty currentUser}">
        <section class="mt-5">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                <h3 class="fw-bold mb-0">Lịch sử phản hồi</h3>
                <span class="text-muted">Admin có thể xem và trả lời các tin nhắn này.</span>
            </div>
            <div class="row g-3">
                <c:forEach var="msg" items="${messageHistory}">
                    <div class="col-12">
                        <div class="thread-card p-4">
                            <div class="d-flex justify-content-between flex-wrap gap-2 mb-3">
                                <div>
                                    <div class="fw-bold">${msg.subject}</div>
                                    <div class="small text-muted">${msg.createdDate}</div>
                                </div>
                                <span class="badge ${msg.status == 'REPLIED' ? 'bg-success' : 'bg-warning text-dark'} rounded-pill px-3 py-2">${msg.status == 'REPLIED' ? 'Đã phản hồi' : 'Đang chờ phản hồi'}</span>
                            </div>
                            <div class="message-bubble mb-3">${msg.message}</div>
                            <c:if test="${not empty msg.adminReply}">
                                <div class="message-bubble message-reply"><div class="fw-semibold text-success mb-2"><i class="fa-solid fa-reply me-2"></i>Phản hồi từ Treeshop</div>${msg.adminReply}</div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty messageHistory}">
                    <div class="col-12"><div class="alert alert-light border rounded-4">Bạn chưa có tin nhắn nào trước đó.</div></div>
                </c:if>
            </div>
        </section>
    </c:if>
</main>
<jsp:include page="/WEB-INF/view/common/client-footer.jsp" />
<jsp:include page="/WEB-INF/view/common/client-assistant.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/resources/client/js/client-shop.js'/>"></script>
<script src="<c:url value='/resources/client/js/client-ai.js'/>"></script>
</body>
</html>
