<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh mục sản phẩm | Treeshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/danhmuc.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-shared.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-ai.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/view/common/client-navbar.jsp"><jsp:param name="active" value="categories"/></jsp:include>

<section class="page-heading">
    <div class="container">
        <div class="d-flex justify-content-between align-items-end flex-wrap gap-3">
            <div>
                <div class="product-mini-tag"><i class="fa-solid fa-compass"></i> Browse catalogue</div>
                <h1 class="section-title mb-2">Danh mục sản phẩm</h1>
                <p class="text-muted mb-0">Hãy lựa chọn cây cho không gian nhà bạn.</p>
            </div>
            <div class="text-muted fw-semibold">Tổng sản phẩm: ${productsPage.totalElements}</div>
        </div>
    </div>
</section>

<main class="container pb-5">
    <div class="row g-4">
        <div class="col-lg-3">
            <div class="filter-shell p-4 mb-4">
                <h5 class="fw-bold mb-3"><i class="fa-solid fa-filter me-2 text-success"></i>Bộ lọc</h5>
                <div class="list-group list-group-flush">
                    <a href="/client/categories" class="list-group-item list-group-item-action rounded-4 mb-2 ${empty category ? 'active bg-success border-success' : ''}">Tất cả</a>
                    <c:forEach var="item" items="${categoryNames}">
                        <a href="/client/categories?category=${item}&keyword=${keyword}" class="list-group-item list-group-item-action rounded-4 mb-2 ${item == category ? 'active bg-success border-success' : ''}">${item}</a>
                    </c:forEach>
                </div>
            </div>
            <div class="filter-shell p-4">
                <h5 class="fw-bold mb-2"><i class="fa-solid fa-magnifying-glass me-2 text-success"></i>Tìm kiếm</h5>
                <p class="text-muted small mb-0">Ô tìm kiếm sản phẩm đã được đưa lên navbar để dùng ở mọi trang.</p>
            </div>
        </div>
        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-4">
                <h5 class="mb-0 fw-bold text-success">
                    <c:choose>
                        <c:when test="${not empty category}"><i class="fa-solid fa-leaf me-2"></i>${category}</c:when>
                        <c:when test="${not empty keyword}"><i class="fa-solid fa-magnifying-glass me-2"></i>Kết quả cho “${keyword}”</c:when>
                        <c:otherwise><i class="fa-solid fa-seedling me-2"></i>Tất cả sản phẩm</c:otherwise>
                    </c:choose>
                </h5>
                <a href="/client/wishlist" class="btn btn-outline-dark rounded-pill"><i class="fa-regular fa-heart me-2"></i>Xem wishlist</a>
            </div>

            <div class="row g-4">
                <c:forEach var="product" items="${productsPage.content}">
                    <div class="col-lg-4 col-md-6">
                        <div class="product-showcase">
                            <div class="product-media">
                                <img src="/uploads/${product.image}" alt="${product.name}">
                                <div class="product-floating-actions">
                                    <button type="button" class="floating-icon-btn wishlist-toggle-btn" data-product-id="${product.id}" aria-label="Wishlist"><i class="fa-regular fa-heart"></i></button>
                                    <a href="/client/products/${product.id}" class="floating-icon-btn" aria-label="Xem chi tiết"><i class="fa-solid fa-eye"></i></a>
                                </div>
                                <div class="product-hover-panel">
                                    <div class="small opacity-75 mb-2">${product.categories}</div>
                                    <div class="fw-bold fs-5 mb-2">${product.name}</div>
                                    <div class="mb-3 fw-semibold"><fmt:formatNumber value="${product.price}" pattern="#,###"/>₫</div>
                                    <div class="d-flex gap-2">
                                        <a href="/client/products/${product.id}" class="btn-soft-light flex-fill"><i class="fa-solid fa-arrow-up-right-from-square"></i>Chi tiết</a>
                                        <button type="button" class="btn-soft-success flex-fill add-to-cart-btn" data-product-id="${product.id}"><i class="fa-solid fa-bag-shopping"></i>Thêm</button>
                                    </div>
                                </div>
                            </div>
                            <div class="product-caption">
                                <div>
                                    <a href="/client/products/${product.id}" class="product-name">${product.name}</a>
                                    <div class="product-mini-tag"><i class="fa-solid fa-camera-retro"></i> </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty productsPage.content}">
                    <div class="col-12"><div class="alert alert-light border rounded-4">Không tìm thấy sản phẩm phù hợp.</div></div>
                </c:if>
            </div>

            <c:if test="${totalPages > 0}">
                <nav class="mt-5">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${productsPage.first ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage - 1}&category=${category}&keyword=${keyword}">Trước</a></li>
                        <c:forEach begin="0" end="${totalPages - 1}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}"><a class="page-link" href="?page=${i}&category=${category}&keyword=${keyword}">${i + 1}</a></li>
                        </c:forEach>
                        <li class="page-item ${productsPage.last ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage + 1}&category=${category}&keyword=${keyword}">Sau</a></li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/view/common/client-footer.jsp" />
<jsp:include page="/WEB-INF/view/common/client-assistant.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/resources/client/js/client-shop.js'/>"></script>
<script src="<c:url value='/resources/client/js/client-ai.js'/>"></script>
</body>
</html>
