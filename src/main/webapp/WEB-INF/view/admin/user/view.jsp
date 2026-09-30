<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
    <style>
        .user-avatar { width: 120px; height: 120px; object-fit: cover; border-radius: 50%; border: 4px solid #e2e8f0; }
        .info-label { color: #64748b; font-weight: 600; margin-bottom: 6px; }
        .info-value { font-size: 1.05rem; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="users"/></jsp:include>
<div class="main-content">
    <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
            <h3 class="fw-bold mb-1">Chi tiết người dùng</h3>
            <p class="text-muted mb-0">Xem hồ sơ và trạng thái tài khoản của người dùng.</p>
        </div>
        <a href="/admin/users" class="btn btn-outline-secondary"><i class="fas fa-arrow-left me-2"></i>Quay lại danh sách</a>
    </div>

    <div class="card p-4">
        <div class="row g-4 align-items-center">
            <div class="col-lg-3 text-center">
                <c:choose>
                    <c:when test="${not empty user.avatar}">
                        <img src="/uploads/${user.avatar}" alt="${user.fullName}" class="user-avatar">
                    </c:when>
                    <c:otherwise>
                        <div class="user-avatar bg-light d-inline-flex align-items-center justify-content-center text-muted">
                            <i class="fas fa-user fa-2x"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="col-lg-9">
                <div class="row g-4">
                    <div class="col-md-6"><div class="info-label">Họ và tên</div><div class="info-value">${user.fullName}</div></div>
                    <div class="col-md-6"><div class="info-label">Email</div><div class="info-value">${user.email}</div></div>
                    <div class="col-md-6"><div class="info-label">Số điện thoại</div><div class="info-value">${user.phone}</div></div>
                    <div class="col-md-6"><div class="info-label">Vai trò</div><div class="info-value"><span class="badge bg-secondary">${user.roles.name}</span></div></div>
                    <div class="col-md-6"><div class="info-label">Provider</div><div class="info-value">${empty user.provider ? 'LOCAL' : user.provider}</div></div>
                    <div class="col-md-6"><div class="info-label">Ngày tạo</div><div class="info-value">${user.createdDate}</div></div>
                    <div class="col-12"><div class="info-label">Địa chỉ</div><div class="info-value">${user.address}</div></div>
                </div>
                <div class="mt-4 d-flex gap-2 flex-wrap">
                    <a href="/admin/users/update/${user.id}" class="btn btn-success"><i class="fas fa-pen me-2"></i>Chỉnh sửa</a>
                    <a href="/admin/users/delete/${user.id}" class="btn btn-outline-danger" onclick="return confirm('Xóa người dùng ${user.fullName}?')"><i class="fas fa-trash me-2"></i>Xóa</a>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
