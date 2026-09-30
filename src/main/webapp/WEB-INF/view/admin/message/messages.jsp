<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tin nhắn khách hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="messages"/></jsp:include>
<div class="main-content">
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center gap-3 flex-wrap">
            <div>
                <h3 class="mb-1 fw-bold">Hộp thư khách hàng</h3>
                <p class="text-muted mb-0">Admin có thể xem nội dung khách gửi và phản hồi trực tiếp trong hệ thống.</p>
            </div>
            <div class="badge bg-success-subtle text-success px-3 py-2 rounded-pill">${messages.size()} tin nhắn</div>
        </div>
    </div>

    <c:if test="${not empty successMessage}"><div class="alert alert-success">${successMessage}</div></c:if>

    <div class="row g-4">
        <c:forEach var="item" items="${messages}">
            <div class="col-12">
                <div class="card card-custom">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 mb-3">
                            <div>
                                <div class="d-flex align-items-center gap-2 flex-wrap">
                                    <h5 class="mb-0 fw-bold">${item.subject}</h5>
                                    <span class="badge ${item.status == 'REPLIED' ? 'bg-success' : 'bg-warning text-dark'}">${item.status == 'REPLIED' ? 'Đã phản hồi' : 'Mới'}</span>
                                </div>
                                <div class="text-muted mt-2">
                                    <i class="fa-regular fa-user me-1"></i>${item.fullName}
                                    <span class="mx-2">•</span>
                                    <i class="fa-regular fa-envelope me-1"></i>${item.email}
                                    <c:if test="${not empty item.phone}"><span class="mx-2">•</span><i class="fa-solid fa-phone me-1"></i>${item.phone}</c:if>
                                </div>
                            </div>
                            <div class="text-muted small">${item.createdDate}</div>
                        </div>

                        <div class="p-3 rounded-4 bg-light mb-3">${item.message}</div>

                        <c:if test="${not empty item.adminReply}">
                            <div class="p-3 rounded-4 border border-success-subtle bg-success-subtle mb-3">
                                <div class="fw-semibold text-success mb-2"><i class="fa-solid fa-reply me-2"></i>Phản hồi của admin</div>
                                <div>${item.adminReply}</div>
                            </div>
                        </c:if>

                        <form method="post" action="/admin/messages/${item.id}/reply">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Phản hồi nhanh</label>
                                <textarea class="form-control" name="adminReply" rows="4" placeholder="Nhập phản hồi cho khách hàng...">${item.adminReply}</textarea>
                            </div>
                            <div class="d-flex justify-content-end">
                                <button class="btn btn-success px-4"><i class="fa-regular fa-paper-plane me-2"></i>${empty item.adminReply ? 'Gửi phản hồi' : 'Cập nhật phản hồi'}</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty messages}">
            <div class="col-12"><div class="alert alert-light border">Chưa có tin nhắn nào từ khách hàng.</div></div>
        </c:if>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
