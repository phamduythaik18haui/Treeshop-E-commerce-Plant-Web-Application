<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/orders.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="orders"/></jsp:include>

<div class="main-content">
    <div class="page-header">
        <div class="row align-items-center g-3">
            <div class="col"><h3 class="mb-1 fw-bold">Quản lý đơn hàng</h3><p class="text-muted mb-0">Đã có lọc trạng thái và phân trang thật.</p></div>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-2"><div class="card-custom text-center p-3"><div class="fw-bold fs-4 text-primary">${totalOrders}</div><small>Tổng đơn</small></div></div>
        <div class="col-md-2"><div class="card-custom text-center p-3"><div class="fw-bold fs-4 text-warning">${pendingOrders}</div><small>Chờ xử lý</small></div></div>
        <div class="col-md-2"><div class="card-custom text-center p-3"><div class="fw-bold fs-4 text-info">${shippingOrders}</div><small>Đang giao</small></div></div>
        <div class="col-md-2"><div class="card-custom text-center p-3"><div class="fw-bold fs-4 text-success">${deliveredOrders}</div><small>Đã giao</small></div></div>
        <div class="col-md-2"><div class="card-custom text-center p-3"><div class="fw-bold fs-4 text-danger">${cancelledOrders}</div><small>Đã hủy</small></div></div>
        <div class="col-md-2"><div class="card-custom text-center p-3"><div class="fw-bold fs-6 text-success"><fmt:formatNumber value='${paidRevenue}' type='number' maxFractionDigits='0'/> ₫</div><small>Doanh thu</small></div></div>
    </div>

    <div class="card-custom mb-4">
        <div class="card-body">
            <form class="row g-3" method="get" action="/admin/orders">
                <div class="col-md-5">
                    <select class="form-select" name="status">
                        <option value="">Tất cả trạng thái đơn</option>
                        <option value="pending" ${currentStatus == 'pending' ? 'selected' : ''}>Pending</option>
                        <option value="confirmed" ${currentStatus == 'confirmed' ? 'selected' : ''}>Confirmed</option>
                        <option value="shipping" ${currentStatus == 'shipping' ? 'selected' : ''}>Shipping</option>
                        <option value="delivered" ${currentStatus == 'delivered' ? 'selected' : ''}>Delivered</option>
                        <option value="cancelled" ${currentStatus == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                    </select>
                </div>
                <div class="col-md-5">
                    <select class="form-select" name="paymentStatus">
                        <option value="">Tất cả trạng thái thanh toán</option>
                        <option value="pending" ${currentPaymentStatus == 'pending' ? 'selected' : ''}>Pending</option>
                        <option value="paid" ${currentPaymentStatus == 'paid' ? 'selected' : ''}>Paid</option>
                        <option value="failed" ${currentPaymentStatus == 'failed' ? 'selected' : ''}>Failed</option>
                    </select>
                </div>
                <div class="col-md-2 d-grid"><button class="btn btn-outline-success">Lọc</button></div>
            </form>
        </div>
    </div>

    <div class="card-custom">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Khách hàng</th>
                        <th>Tổng tiền</th>
                        <th>Sản phẩm</th>
                        <th>Trạng thái đơn</th>
                        <th>Thanh toán</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${orders}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1 + currentPage * ordersPage.size}</td>
                            <td>${order.user.fullName}</td>
                            <td class="text-success fw-bold"><fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0"/> ₫</td>
                            <td>${order.totalProduct}</td>
                            <td><span class="badge bg-light text-dark">${order.status}</span></td>
                            <td><span class="badge ${order.paymentStatus == 'paid' ? 'bg-success' : (order.paymentStatus == 'failed' ? 'bg-danger' : 'bg-warning text-dark')}">${order.paymentStatus}</span></td>
                            <td class="text-center">
                                <a href="/admin/orders/${order.id}" class="btn btn-sm btn-outline-primary"><i class="fa-regular fa-eye"></i></a>
                                <a href="/admin/orders/edit/${order.id}" class="btn btn-sm btn-outline-warning"><i class="fa-regular fa-pen-to-square"></i></a>
                                <a href="/admin/orders/delete/${order.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa đơn hàng #${order.id}?')"><i class="fa-regular fa-trash-can"></i></a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orders}"><tr><td colspan="7" class="text-center py-4 text-muted">Không có đơn hàng phù hợp.</td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item ${ordersPage.first ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage - 1}&status=${currentStatus}&paymentStatus=${currentPaymentStatus}">Trước</a></li>
            <c:forEach begin="0" end="${ordersPage.totalPages - 1}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}"><a class="page-link" href="?page=${i}&status=${currentStatus}&paymentStatus=${currentPaymentStatus}">${i + 1}</a></li>
            </c:forEach>
            <li class="page-item ${ordersPage.last ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage + 1}&status=${currentStatus}&paymentStatus=${currentPaymentStatus}">Sau</a></li>
        </ul>
    </nav>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
