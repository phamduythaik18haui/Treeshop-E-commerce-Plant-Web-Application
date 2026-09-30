<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
    <style>
        .product-image { width: 100%; height: 420px; object-fit: cover; border-radius: 18px; }
        .detail-label { color: #64748b; font-weight: 600; margin-bottom: 6px; }
        .detail-value { font-size: 1.05rem; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="products"/></jsp:include>
<div class="main-content">
    <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
            <h3 class="fw-bold mb-1">Chi tiết sản phẩm</h3>
            <p class="text-muted mb-0">Xem nhanh hình ảnh và thông tin đầy đủ của sản phẩm.</p>
        </div>
        <a href="/admin/products" class="btn btn-outline-secondary"><i class="fas fa-arrow-left me-2"></i>Quay lại danh sách</a>
    </div>

    <div class="row g-4">
        <div class="col-lg-5">
            <div class="card p-3">
                <c:choose>
                    <c:when test="${not empty product.image}">
                        <img src="/uploads/${product.image}" class="product-image" alt="${product.name}">
                    </c:when>
                    <c:otherwise>
                        <div class="product-image bg-light d-flex align-items-center justify-content-center text-muted">
                            <i class="fas fa-image fa-3x"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <c:if test="${not empty product.imageDetail}">
                <div class="card p-3 mt-4">
                    <img src="/uploads/${product.imageDetail}" class="product-image" alt="${product.name}">
                </div>
            </c:if>
        </div>
        <div class="col-lg-7">
            <div class="card p-4">
                <div class="d-flex justify-content-between align-items-start gap-3 mb-4 flex-wrap">
                    <div>
                        <h2 class="fw-bold mb-2">${product.name}</h2>
                        <span class="badge bg-secondary">${product.categories}</span>
                    </div>
                    <div class="text-end">
                        <div class="fs-4 fw-bold text-success"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0"/> ₫</div>
                        <div class="text-muted">Kho: ${product.quantity} · Đã bán: ${product.sold}</div>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="detail-label">Trạng thái</div>
                        <div class="detail-value">
                            <span class="badge ${product.isHot ? 'bg-danger' : 'bg-secondary'}">${product.isHot ? 'Nổi bật' : 'Thường'}</span>
                            <span class="badge ${product.isNew ? 'bg-success' : 'bg-secondary'}">${product.isNew ? 'Mới' : 'Ổn định'}</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">ID sản phẩm</div>
                        <div class="detail-value">#${product.id}</div>
                    </div>
                    <div class="col-12">
                        <div class="detail-label">Mô tả ngắn</div>
                        <div class="detail-value">${product.shortDesc}</div>
                    </div>
                    <div class="col-12">
                        <div class="detail-label">Mô tả chi tiết</div>
                        <div class="detail-value">${product.detailDesc}</div>
                    </div>
                </div>

                <div class="mt-4 d-flex gap-2 flex-wrap">
                    <a href="/admin/products/update/${product.id}" class="btn btn-success"><i class="fas fa-pen me-2"></i>Chỉnh sửa</a>
                    <a href="/admin/products/delete/${product.id}" class="btn btn-outline-danger" onclick="return confirm('Xóa sản phẩm ${product.name}?')"><i class="fas fa-trash me-2"></i>Xóa</a>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
