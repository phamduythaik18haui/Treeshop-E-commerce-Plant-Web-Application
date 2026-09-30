<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wishlist | Treeshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-shared.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-ai.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/view/common/client-navbar.jsp"><jsp:param name="active" value="wishlist"/></jsp:include>
<section class="page-heading">
    <div class="container">
        <div class="product-mini-tag"><i class="fa-regular fa-heart"></i> Bộ sưu tập yêu thích</div>
        <h1 class="section-title mb-2">Wishlist của bạn</h1>
        <p class="text-muted mb-0">Lưu sản phẩm yêu thích và chuyển nhanh sang giỏ hàng bất cứ lúc nào.</p>
    </div>
</section>
<main class="container pb-5">
    <div class="row g-4">
        <c:forEach var="item" items="${wishlistItems}">
            <div class="col-lg-4 col-md-6 wishlist-row">
                <div class="product-showcase">
                    <div class="product-media">
                        <img src="/uploads/${item.product.image}" alt="${item.product.name}">
                        <div class="product-floating-actions" style="opacity:1;transform:none;">
                            <button type="button" class="floating-icon-btn wishlist-toggle-btn is-active" data-product-id="${item.product.id}"><i class="fa-solid fa-heart"></i></button>
                            <a href="/client/products/${item.product.id}" class="floating-icon-btn"><i class="fa-solid fa-eye"></i></a>
                        </div>
                    </div>
                    <div class="product-caption flex-column align-items-start">
                        <a href="/client/products/${item.product.id}" class="product-name">${item.product.name}</a>
                        <div class="d-flex justify-content-between align-items-center w-100 flex-wrap gap-2 mt-2">
                            <div class="product-price"><fmt:formatNumber value="${item.product.price}" pattern="#,###"/>₫</div>
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-success rounded-pill move-to-cart-btn" data-product-id="${item.product.id}"><i class="fa-solid fa-bag-shopping me-2"></i>Thêm giỏ</button>
                                <a href="/client/products/${item.product.id}" class="btn btn-outline-dark rounded-pill"><i class="fa-solid fa-arrow-up-right-from-square me-2"></i>Chi tiết</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty wishlistItems}">
            <div class="col-12">
                <div class="client-card p-5 text-center">
                    <div class="display-6 mb-3 text-muted"><i class="fa-regular fa-heart"></i></div>
                    <h3 class="fw-bold">Wishlist của bạn đang trống</h3>
                    <p class="text-muted">Hãy lưu vài chậu cây đẹp để xem lại sau nhé.</p>
                    <a href="/client/categories" class="btn btn-success rounded-pill px-4"><i class="fa-solid fa-leaf me-2"></i>Khám phá sản phẩm</a>
                </div>
            </div>
        </c:if>
    </div>
</main>
<jsp:include page="/WEB-INF/view/common/client-footer.jsp" />
<jsp:include page="/WEB-INF/view/common/client-assistant.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/resources/client/js/client-shop.js'/>"></script>
<script src="<c:url value='/resources/client/js/client-ai.js'/>"></script>
</body>
</html>
