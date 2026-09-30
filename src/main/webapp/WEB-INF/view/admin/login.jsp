<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Treeshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { min-height: 100vh; display: grid; place-items: center; background: linear-gradient(135deg,#0f172a,#14532d); }
        .login-card { width: min(430px, 92vw); border: none; border-radius: 24px; overflow: hidden; box-shadow: 0 30px 60px rgba(0,0,0,.25); }
        .login-card .card-body { padding: 34px; }
        .brand-badge { width: 72px; height: 72px; border-radius: 22px; display:flex; align-items:center; justify-content:center; background:#e9f9ef; color:#166534; font-size:28px; margin:0 auto 18px; }
        .btn-success { padding: 12px 16px; border-radius: 14px; }
    </style>
</head>
<body>
<div class="card login-card">
    <div class="card-body">
        <div class="brand-badge"><i class="fas fa-leaf"></i></div>
        <h3 class="text-center fw-bold">Đăng nhập quản trị</h3>
        <p class="text-center text-muted mb-4">Đăng nhập đúng tài khoản admin để vào trang quản lý Treeshop.</p>

        <c:if test="${error}">
            <div class="alert alert-danger">Email hoặc mật khẩu admin chưa đúng.</div>
        </c:if>

        <form action="<c:url value='/admin/login'/>" method="post">
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control form-control-lg" required>
            </div>
            <div class="mb-4">
                <label class="form-label">Mật khẩu</label>
                <input type="password" name="password" class="form-control form-control-lg" required>
            </div>
            <button class="btn btn-success w-100">Đăng nhập admin</button>
        </form>

        <div class="text-center mt-4">
            <a href="<c:url value='/client/indexs'/>" class="text-decoration-none">Quay lại trang khách hàng</a>
        </div>
    </div>
</div>
</body>
</html>
