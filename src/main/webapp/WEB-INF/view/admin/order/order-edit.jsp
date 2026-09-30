<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sửa đơn hàng #${order.id}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
</head>
<body class="bg-light">
<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="orders"/></jsp:include>
<div class="main-content">

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>Sửa đơn hàng #${order.id}</h3>
        <div>
            <a href="/admin/orders/${order.id}" class="btn btn-secondary">← Xem chi tiết</a>
            <a href="/admin/orders" class="btn btn-outline-secondary">Danh sách</a>
        </div>
    </div>

    <div class="row g-3">
        <!-- Thông tin chính -->
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header">Thông tin đơn</div>
                <div class="card-body">
                    <form action="/admin/orders/update" method="post" class="row g-3">
                        <!-- Nếu dùng Spring Security, mở comment dòng dưới -->
                        <%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> --%>

                        <input type="hidden" name="id" value="${order.id}"/>

                        <div class="col-md-6">
                            <label class="form-label">Trạng thái đơn</label>
                            <select name="status" class="form-select" required>
                                <option value="pending"   ${order.status == 'pending' ? 'selected' : ''}>pending</option>
                                <option value="confirmed" ${order.status == 'confirmed' ? 'selected' : ''}>confirmed</option>
                                <option value="shipping"  ${order.status == 'shipping' ? 'selected' : ''}>shipping</option>
                                <option value="delivered" ${order.status == 'delivered' ? 'selected' : ''}>delivered</option>
                                <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>cancelled</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Trạng thái thanh toán</label>
                            <select name="paymentStatus" class="form-select" required>
                                <option value="pending"  ${order.paymentStatus == 'pending' ? 'selected' : ''}>pending</option>
                                <option value="paid"     ${order.paymentStatus == 'paid' ? 'selected' : ''}>paid</option>
                                <option value="failed"   ${order.paymentStatus == 'failed' ? 'selected' : ''}>failed</option>
                                <option value="refunded" ${order.paymentStatus == 'refunded' ? 'selected' : ''}>refunded</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Phương thức thanh toán</label>
                            <select name="paymentMethod" class="form-select" required>
                                <option value="COD"   ${order.paymentMethod == 'COD' ? 'selected' : ''}>COD</option>
                                <option value="VNPAY" ${order.paymentMethod == 'VNPAY' ? 'selected' : ''}>VNPAY</option>
                                <option value="MOMO"  ${order.paymentMethod == 'MOMO' ? 'selected' : ''}>MoMo</option>
                                <option value="BANK"  ${order.paymentMethod == 'BANK' ? 'selected' : ''}>Chuyển khoản</option>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Tổng sản phẩm</label>
                            <input type="number" min="0" name="totalProduct" class="form-control"
                                   value="${order.totalProduct}" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Tổng tiền (₫)</label>
                            <input type="number" min="0" step="1" name="totalPrice" class="form-control"
                                   value="${order.totalPrice}" required>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                            <a href="/admin/orders" class="btn btn-outline-secondary">Huỷ</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Thông tin phụ -->
        <div class="col-lg-4">
            <div class="card mb-3">
                <div class="card-header">Khách hàng</div>
                <div class="card-body">
                    <p class="mb-1"><b>Họ tên:</b> ${order.user.fullName}</p>
                    <p class="mb-1"><b>Email:</b> ${order.user.email}</p>
                    <p class="mb-0"><b>SĐT:</b> ${order.user.phone}</p>
                </div>
            </div>

            <div class="card">
                <div class="card-header">Địa chỉ giao hàng</div>
                <div class="card-body">
                    <p class="mb-1"><b>Người nhận:</b> ${order.address.reciverName}</p>
                    <p class="mb-1"><b>Điện thoại:</b> ${order.address.reciverPhone}</p>
                    <p class="mb-0"><b>Địa chỉ:</b> ${order.address.detailDesc}</p>
                </div>
            </div>
        </div>
    </div>
</div>

</div>
</body>
</html>
