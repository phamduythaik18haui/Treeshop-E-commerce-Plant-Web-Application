<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chi tiết đơn hàng</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
</head>
<body class="bg-light">
<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="orders"/></jsp:include>
<div class="main-content">

<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h3>Đơn hàng #${order.id}</h3>
    <a class="btn btn-secondary" href="/admin/orders">← Về danh sách</a>
  </div>

  <!-- Tổng quan -->
  <div class="row g-3">
    <div class="col-lg-7">
      <div class="card">
        <div class="card-header">Sản phẩm</div>
        <div class="card-body p-0">
          <c:choose>
            <c:when test="${not empty orderItems}">
              <table class="table table-striped mb-0">
                <thead class="table-light">
                <tr>
                  <th>#</th>
                  <th>Tên</th>
                  <th class="text-end">SL</th>
                  <th class="text-end">Đơn giá (₫)</th>
                  <th class="text-end">Tạm tính (₫)</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="it" items="${orderItems}" varStatus="st">
                  <tr>
                    <td>${st.index + 1}</td>
                    <td>${it.product.name}</td>
                    <td class="text-end">${it.quantity}</td>
                    <td class="text-end"><fmt:formatNumber value="${it.price}" pattern="#,###"/></td>
                    <td class="text-end"><fmt:formatNumber value="${it.price * it.quantity}" pattern="#,###"/></td>
                  </tr>
                </c:forEach>
                </tbody>
              </table>
            </c:when>
            <c:otherwise>
              <div class="p-3 text-muted">Chưa có dòng hàng.</div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <div class="col-lg-5">
      <!-- Khách và địa chỉ -->
      <div class="card mb-3">
        <div class="card-header">Khách hàng & giao hàng</div>
        <div class="card-body">
          <p class="mb-1"><b>Họ tên:</b> ${order.user.fullName}</p>
          <p class="mb-1"><b>Email:</b> ${order.user.email}</p>
          <p class="mb-1"><b>SĐT:</b> ${order.user.phone}</p>
          <p class="mb-0"><b>Địa chỉ:</b> ${order.address.detailDesc}</p>
        </div>
      </div>

      <!-- Tóm tắt tiền -->
      <div class="card mb-3">
        <div class="card-header">Thanh toán</div>
        <div class="card-body">
          <div class="d-flex justify-content-between mb-2">
            <span>Tổng sản phẩm:</span>
            <span>${order.totalProduct}</span>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <span>Tổng thanh toán:</span>
            <strong class="text-success"><fmt:formatNumber value="${order.totalPrice}" pattern="#,###"/>₫</strong>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <span>Phương thức:</span>
            <span>${order.paymentMethod}</span>
          </div>
          <div class="d-flex justify-content-between mb-0">
            <span>Trạng thái TT:</span>
            <span class="${order.paymentStatus == 'paid' ? 'text-success' : (order.paymentStatus == 'failed' ? 'text-danger' : 'text-muted')}">
              ${order.paymentStatus}
            </span>
          </div>
        </div>
      </div>

      <!-- Cập nhật trạng thái nhanh -->
      <div class="card">
        <div class="card-header">Trạng thái đơn</div>
        <div class="card-body">
          <form class="row g-2" method="post" action="/admin/orders/update-status">
            <input type="hidden" name="orderId" value="${order.id}">
            <div class="col-8">
              <select class="form-select" name="status">
                <option value="pending"   ${order.status == 'pending' ? 'selected' : ''}>pending</option>
                <option value="confirmed" ${order.status == 'confirmed' ? 'selected' : ''}>confirmed</option>
                <option value="shipping"  ${order.status == 'shipping' ? 'selected' : ''}>shipping</option>
                <option value="delivered" ${order.status == 'delivered' ? 'selected' : ''}>delivered</option>
                <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>cancelled</option>
              </select>
            </div>
            <div class="col-4">
              <button class="btn btn-primary w-100" type="submit">Cập nhật</button>
            </div>
          </form>

          <hr>
          <form class="row g-2" method="post" action="/admin/orders/update-payment-status">
            <input type="hidden" name="orderId" value="${order.id}">
            <div class="col-8">
              <select class="form-select" name="paymentStatus">
                <option value="pending"  ${order.paymentStatus == 'pending' ? 'selected' : ''}>pending</option>
                <option value="paid"     ${order.paymentStatus == 'paid' ? 'selected' : ''}>paid</option>
                <option value="failed"   ${order.paymentStatus == 'failed' ? 'selected' : ''}>failed</option>
                <option value="refunded" ${order.paymentStatus == 'refunded' ? 'selected' : ''}>refunded</option>
              </select>
            </div>
            <div class="col-4">
              <button class="btn btn-outline-primary w-100" type="submit">Cập nhật</button>
            </div>
          </form>
        </div>
      </div>

    </div>
  </div>
</div>
</div>
</body>
</html>
