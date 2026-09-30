<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập & Đăng Ký - TREESHOP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/login.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-shared.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-ai.css'/>">
</head>
<body>
<div class="container">
    <div class="auth-container">
        <div class="row g-0">
            <div class="col-md-6 d-none d-md-block">
                <div class="auth-image h-100">
                    <h2>Chào mừng đến với TREESHOP</h2>
                    <p class="text-center">Khám phá thế giới cây cảnh đa dạng và chọn cho mình những loại cây phù hợp nhất.</p>
                    <div class="mt-4 w-100">
                        <div class="d-flex align-items-center mb-3">
                            <i class="fas fa-check-circle me-3"></i>
                            <span>Hơn 1000 loại cây cảnh đa dạng</span>
                        </div>
                        <div class="d-flex align-items-center mb-3">
                            <i class="fas fa-check-circle me-3"></i>
                            <span>Giao hàng nhanh và hỗ trợ toàn quốc</span>
                        </div>
                        <div class="d-flex align-items-center">
                            <i class="fas fa-check-circle me-3"></i>
                            <span>Tư vấn chăm sóc cây cơ bản trọn đời</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="auth-form">
                    <div class="d-flex justify-content-end mb-3">
                        <a href="/client/indexs" class="home-link" title="Về trang chủ"><i class="fas fa-house"></i></a>
                    </div>
                    <ul class="nav nav-tabs justify-content-center" id="authTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="login-tab" data-bs-toggle="tab" data-bs-target="#login" type="button" role="tab">Đăng Nhập</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="register-tab" data-bs-toggle="tab" data-bs-target="#register" type="button" role="tab">Đăng Ký</button>
                        </li>
                    </ul>

                    <div class="tab-content" id="authTabContent">
                        <div class="tab-pane fade show active" id="login" role="tabpanel">
                            <h3 class="form-title">Đăng nhập tài khoản</h3>

                            <c:if test="${not empty error}"><div class="alert alert-danger">Đăng nhập không thành công. Vui lòng kiểm tra lại email hoặc mật khẩu.</div></c:if>
                            <c:if test="${not empty message}"><div class="alert alert-info">${message}</div></c:if>

                            <form action="/client/login" method="post" id="loginForm">
                                <input type="hidden" name="next" value="${next}">
                                <div class="mb-3">
                                    <label for="loginEmail" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="loginEmail" name="email" placeholder="Nhập địa chỉ email" required>
                                </div>

                                <div class="mb-3 password-toggle">
                                    <label for="loginPassword" class="form-label">Mật khẩu</label>
                                    <input type="password" class="form-control" id="loginPassword" name="password" placeholder="Nhập mật khẩu" required>
                                </div>

                                <div class="mb-3 d-flex justify-content-between align-items-center">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" id="rememberMe">
                                        <label class="form-check-label" for="rememberMe">Ghi nhớ đăng nhập</label>
                                    </div>
                                    <a href="/client/indexs" class="text-decoration-none">Về trang chủ</a>
                                </div>

                                <button type="submit" class="btn btn-auth">Đăng Nhập</button>
                            </form>

                            <div class="social-login">
                                <p class="text-center">Hoặc đăng nhập bằng</p>
                                <a href="/client/auth/google" class="social-btn google mb-2">
                                    <i class="fab fa-google me-2"></i> Đăng nhập với Google
                                </a>
                                <a href="/client/auth/facebook" class="social-btn facebook">
                                    <i class="fab fa-facebook-f me-2"></i> Đăng nhập với Facebook
                                </a>
                            </div>

                            <div class="auth-switch">
                                Chưa có tài khoản? <a href="#" id="switchToRegister">Đăng ký ngay</a>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="register" role="tabpanel">
                            <h3 class="form-title">Tạo tài khoản mới</h3>

                            <form id="registerForm">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="firstName" class="form-label">Họ</label>
                                            <input type="text" class="form-control" id="firstName" placeholder="Nhập họ" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="lastName" class="form-label">Tên</label>
                                            <input type="text" class="form-control" id="lastName" placeholder="Nhập tên" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="registerEmail" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="registerEmail" placeholder="Nhập địa chỉ email" required>
                                </div>
                                <div class="mb-3">
                                    <label for="registerPhone" class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" id="registerPhone" placeholder="Nhập số điện thoại" required>
                                </div>

                                <div class="mb-3 password-toggle">
                                    <label for="registerPassword" class="form-label">Mật khẩu</label>
                                    <input type="password" class="form-control" id="registerPassword" placeholder="Tạo mật khẩu" required>
                                    <div class="form-text">Mật khẩu nên có ít nhất 6 ký tự.</div>
                                </div>

                                <div class="mb-3 password-toggle">
                                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                                    <input type="password" class="form-control" id="confirmPassword" placeholder="Xác nhận mật khẩu" required>
                                </div>

                                <div class="mb-3 form-check">
                                    <input type="checkbox" class="form-check-input" id="termsCheck" required>
                                    <label class="form-check-label" for="termsCheck">Tôi đồng ý với điều khoản sử dụng</label>
                                </div>

                                <button type="submit" class="btn btn-auth">Đăng Ký</button>
                            </form>

                            <div class="auth-switch">
                                Đã có tài khoản? <a href="#" id="switchToLogin">Đăng nhập ngay</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/view/common/client-assistant.jsp" />
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/resources/client/js/client-ai.js'/>"></script>
<script>
$('#switchToRegister').on('click', function(e) {
    e.preventDefault();
    $('#register-tab').tab('show');
});
$('#switchToLogin').on('click', function(e) {
    e.preventDefault();
    $('#login-tab').tab('show');
});
$('#registerForm').on('submit', function(e){
  e.preventDefault();
  const password = $('#registerPassword').val();
  const confirmPassword = $('#confirmPassword').val();
  if(password !== confirmPassword){ alert('Mật khẩu xác nhận không khớp.'); return; }
  $.ajax({
    url:'/client/register', type:'POST',
    data:{ firstName:$('#firstName').val(), lastName:$('#lastName').val(), email:$('#registerEmail').val(), phone:$('#registerPhone').val(), password:password },
    success:function(res){ alert(res.message || 'Đăng ký thành công'); $('#registerForm')[0].reset(); $('#login-tab').tab('show'); },
    error:function(xhr){ alert((xhr.responseJSON && xhr.responseJSON.message) ? xhr.responseJSON.message : 'Đã có lỗi xảy ra'); }
  });
});
</script>
</body>
</html>
