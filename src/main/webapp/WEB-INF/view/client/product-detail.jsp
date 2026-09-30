<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-shared.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-ai.css'/>">
    <style>
        .detail-card{border:none;border-radius:32px;box-shadow:0 22px 48px rgba(15,23,42,.08)}
        .detail-image{width:100%;border-radius:28px;object-fit:cover;height:520px}
        .related-thumb{width:100%;height:240px;border-radius:24px;object-fit:cover}
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/view/common/client-navbar.jsp"><jsp:param name="active" value="categories"/></jsp:include>
<main class="container py-5">
    <div class="mb-4"><a href="/client/categories" class="text-decoration-none fw-semibold"><i class="fas fa-arrow-left me-2"></i>Quay lại danh mục</a></div>
    <div class="card detail-card">
        <div class="card-body p-4 p-lg-5">
            <div class="row g-4 align-items-start">
                <div class="col-lg-6"><img src="/uploads/${product.image}" class="detail-image" alt="${product.name}"></div>
                <div class="col-lg-6">
                    <span class="badge bg-success-subtle text-success mb-3 rounded-pill px-3 py-2">${product.categories}</span>
                    <h1 class="fw-bold mb-3">${product.name}</h1>
                    <div class="display-6 text-success fw-bold mb-3"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0"/> ₫</div>
                    <p class="lead text-muted">${product.shortDesc}</p>
                    <p class="mb-4">${product.detailDesc}</p>
                    <div class="d-flex gap-3 flex-wrap mb-4">
                        <button class="btn btn-success btn-lg rounded-pill add-to-cart-btn" data-product-id="${product.id}"><i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ</button>
                        <button class="btn btn-outline-dark btn-lg rounded-pill wishlist-toggle-btn" data-product-id="${product.id}"><i class="fa-regular fa-heart me-2"></i>Wishlist</button>
                        <a href="/client/categories?category=${product.categories}" class="btn btn-outline-success btn-lg rounded-pill">Xem cùng danh mục</a>
                    </div>
                    <div class="row g-3 text-center">
                        <div class="col-4"><div class="border rounded-4 p-3 bg-light"><strong>${product.quantity}</strong><div class="small text-muted">Tồn kho</div></div></div>
                        <div class="col-4"><div class="border rounded-4 p-3 bg-light"><strong>${product.sold}</strong><div class="small text-muted">Đã bán</div></div></div>
                        <div class="col-4"><div class="border rounded-4 p-3 bg-light"><strong>${product.isHot ? 'Hot' : 'Ổn định'}</strong><div class="small text-muted">Trạng thái</div></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty relatedProducts}">
        <section class="mt-5">
            <h3 class="fw-bold mb-4">Sản phẩm liên quan</h3>
            <div class="row g-4">
                <c:forEach var="item" items="${relatedProducts}">
                    <c:if test="${item.id != product.id}">
                        <div class="col-lg-3 col-md-6">
                            <div class="product-showcase">
                                <div class="product-media"><img src="/uploads/${item.image}" class="related-thumb" alt="${item.name}"></div>
                                <div class="product-caption">
                                    <div><a href="/client/products/${item.id}" class="product-name">${item.name}</a></div>
                                    <div class="product-price"><fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0"/> ₫</div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </section>
    </c:if>
</main>
<jsp:include page="/WEB-INF/view/common/client-footer.jsp" />
<jsp:include page="/WEB-INF/view/common/client-assistant.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/resources/client/js/client-shop.js'/>"></script>
<script src="<c:url value='/resources/client/js/client-ai.js'/>"></script>
</body>
</html>
