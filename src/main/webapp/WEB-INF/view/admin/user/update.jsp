<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="users"/></jsp:include>
<div class="main-content">
    <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
            <h3 class="fw-bold mb-1">Cập nhật người dùng</h3>
            <p class="text-muted mb-0">Chỉnh sửa hồ sơ và quyền của người dùng trong hệ thống.</p>
        </div>
        <a href="/admin/users" class="btn btn-outline-secondary"><i class="fas fa-arrow-left me-2"></i>Quay lại</a>
    </div>

    <div class="card p-4">
        <form:form action="/admin/users/update" method="post" modelAttribute="user" enctype="multipart/form-data">
            <form:hidden path="id"/>
            <div class="row g-4">
                <div class="col-md-6">
                    <label class="form-label">Họ và tên</label>
                    <form:input path="fullName" class="form-control"/>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Tên đăng nhập</label>
                    <form:input path="username" class="form-control"/>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Email</label>
                    <form:input path="email" type="email" class="form-control"/>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Số điện thoại</label>
                    <form:input path="phone" class="form-control"/>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Mật khẩu</label>
                    <form:input path="password" type="text" class="form-control"/>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Provider</label>
                    <form:input path="provider" class="form-control"/>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Vai trò</label>
                    <form:select path="roles.id" class="form-select">
                        <form:option value="1">ADMIN</form:option>
                        <form:option value="2">MANAGER</form:option>
                        <form:option value="3">USER</form:option>
                    </form:select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Ảnh đại diện</label>
                    <input type="file" class="form-control" name="avatarFile">
                </div>
                <div class="col-12">
                    <label class="form-label">Địa chỉ</label>
                    <form:textarea path="address" rows="3" class="form-control"/>
                </div>
                <div class="col-12 d-flex gap-2 flex-wrap">
                    <button type="submit" class="btn btn-success"><i class="fas fa-save me-2"></i>Lưu thay đổi</button>
                    <a href="/admin/users/views/${user.id}" class="btn btn-outline-primary">Xem chi tiết</a>
                </div>
            </div>
        </form:form>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
