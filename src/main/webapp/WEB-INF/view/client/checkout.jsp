<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán - Treeshop</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-shared.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-ai.css'/>">
</head>
<body class="bg-light">

<jsp:include page="/WEB-INF/view/common/client-navbar.jsp"><jsp:param name="active" value="cart"/></jsp:include>

<div class="container">
    <c:if test="${empty currentUser}">
        <div class="alert alert-warning">Bạn cần đăng nhập trước khi thanh toán. <a href="/client/login">Đăng nhập</a></div>
    </c:if>

    <h2 class="mb-4">Thanh toán</h2>
    <div class="row g-4">
        <!-- Thông tin người nhận -->
        <div class="col-lg-7">
            <div class="card">
                <div class="card-header">Thông tin người nhận</div>
                <div class="card-body">
                    <form method="post" action="/client/checkout" id="checkout-form">
                        <div class="mb-3">
                            <label class="form-label">Họ tên</label>
                            <input type="text" name="fullName" class="form-control" required
                                   value="${currentUser.fullName}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" required
                                   value="${currentUser.email}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" required
                                   value="${currentUser.phone}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Địa chỉ nhận hàng</label>
                            <textarea name="address" class="form-control" rows="3" required>${currentUser.address}</textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ghi chú (tuỳ chọn)</label>
                            <textarea name="note" class="form-control" rows="2"></textarea>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Phương thức thanh toán</label>
                            <select name="paymentMethod" class="form-select" required>
                                <option value="COD">Thanh toán khi nhận hàng (COD)</option>
                                <option value="VNPAY">Ví/Thẻ qua VNPAY</option>
                                <option value="MOMO">Ví MoMo</option>
                                <option value="BANK">Chuyển khoản ngân hàng</option>
                            </select>
                        </div>

                        <!-- Tóm tắt nhỏ (hiển thị trên mobile) -->
                        <div class="d-lg-none border rounded p-3 mb-3 bg-light">
                            <div class="d-flex justify-content-between">
                                <span>Tạm tính</span>
                                <strong><fmt:formatNumber value="${subtotal}" pattern="#,###"/>₫</strong>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span>Giảm giá</span>
                                <strong class="text-danger">-<fmt:formatNumber value="${discount}" pattern="#,###"/>₫</strong>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span>Phí vận chuyển</span>
                                <strong><fmt:formatNumber value="${shippingFee}" pattern="#,###"/>₫</strong>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between">
                                <span>Tổng thanh toán</span>
                                <strong class="text-success">
                                    <fmt:formatNumber value="${total}" pattern="#,###"/>₫
                                </strong>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-success btn-lg w-100">Đặt hàng</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Tóm tắt đơn hàng -->
        <div class="col-lg-5">
            <div class="card">
                <div class="card-header">Tóm tắt đơn hàng</div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty cartItems}">
                            <ul class="list-group mb-3">
                                <c:forEach var="item" items="${cartItems}">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <div class="me-2">
                                            <div class="fw-semibold">${item.product.name}</div>
                                            <small class="text-muted">x ${item.quantity}</small>
                                        </div>
                                        <div class="text-end">
                                            <div>
                                                <fmt:formatNumber value="${item.price}" pattern="#,###"/>₫
                                            </div>
                                            <small class="text-muted">
                                                = <fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###"/>₫
                                            </small>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>

                            <div class="d-flex justify-content-between mb-1">
                                <span>Tạm tính:</span>
                                <strong><fmt:formatNumber value="${subtotal}" pattern="#,###"/>₫</strong>
                            </div>
                            <div class="d-flex justify-content-between mb-1">
                                <span>Giảm giá:</span>
                                <strong class="text-danger">-<fmt:formatNumber value="${discount}" pattern="#,###"/>₫</strong>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Phí vận chuyển:</span>
                                <strong><fmt:formatNumber value="${shippingFee}" pattern="#,###"/>₫</strong>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between">
                                <span>Tổng cộng:</span>
                                <strong class="text-success">
                                    <fmt:formatNumber value="${total}" pattern="#,###"/>₫
                                </strong>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-center text-muted">Giỏ hàng của bạn đang trống.</p>
                            <div class="text-center">
                                <a href="/client/categories" class="btn btn-outline-secondary">Tiếp tục mua hàng</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
<script>
    // Chặn submit nếu giỏ hàng trống (phòng khi user truy cập trực tiếp)
    (function(){
        const hasItems = ${not empty cartItems ? "true" : "false"};
        if (!hasItems) {
            const form = document.getElementById('checkout-form');
            if (form) form.addEventListener('submit', function(e){
                e.preventDefault();
                alert('Giỏ hàng của bạn đang trống.');
                window.location.href = '/client/cart';
            });
        }
    })();
</script>
<jsp:include page="/WEB-INF/view/common/client-footer.jsp" />
<jsp:include page="/WEB-INF/view/common/client-assistant.jsp" />
<script src="<c:url value='/resources/client/js/client-shop.js'/>"></script>
<script src="<c:url value='/resources/client/js/client-ai.js'/>"></script>
</body>
</html>
