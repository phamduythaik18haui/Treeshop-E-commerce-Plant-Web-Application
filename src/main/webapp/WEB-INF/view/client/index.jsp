<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Treeshop | Cây xanh cho không gian sống</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/index.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-shared.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-ai.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/view/common/client-navbar.jsp"><jsp:param name="active" value="home"/></jsp:include>

<div id="heroCarousel" class="carousel slide hero-carousel" data-bs-ride="carousel">
    <div class="carousel-indicators">
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
    </div>
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="<c:url value='/resources/client/img/banner1.png'/>" class="d-block w-100" alt="Treeshop banner">
            <div class="carousel-caption d-none d-md-block">
                <h2>Không gian xanh, sống tinh tế</h2>
                <p>Chọn cây đẹp, dễ chăm và phù hợp từng góc nhà hoặc văn phòng của bạn.</p>
                <a href="/client/categories" class="btn btn-success rounded-pill px-4"><i class="fa-solid fa-leaf me-2"></i>Mua ngay</a>
            </div>
        </div>
        <div class="carousel-item">
            <img src="<c:url value='/resources/client/img/banner6.jpg'/>" class="d-block w-100" alt="Cây văn phòng">
            <div class="carousel-caption d-none d-md-block">
                <h2>Bộ sưu tập cây văn phòng</h2>
                <p>Thiết kế hiện đại, xanh mắt và tạo cảm giác thư thái khi làm việc.</p>
                <a href="/client/categories" class="btn btn-success rounded-pill px-4"><i class="fa-solid fa-seedling me-2"></i>Khám phá</a>
            </div>
        </div>
        <div class="carousel-item">
            <img src="<c:url value='/resources/client/img/banner4.jpg'/>" class="d-block w-100" alt="Cây nội thất">
            <div class="carousel-caption d-none d-md-block">
                <h2>Cây nội thất sang và đẹp</h2>
                <p>Hình ảnh thật, phối cảnh đẹp và dễ chọn đúng cây theo phong cách của bạn.</p>
                <a href="/client/categories" class="btn btn-success rounded-pill px-4"><i class="fa-solid fa-bag-shopping me-2"></i>Xem sản phẩm</a>
            </div>
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev"><span class="carousel-control-prev-icon"></span></button>
    <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next"><span class="carousel-control-next-icon"></span></button>
</div>

<main class="container py-5">
    <section class="mb-5">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
            <div>
                <div class="product-mini-tag"><i class="fa-solid fa-sparkles"></i> Danh mục từ CSDL</div>
                <h2 class="section-title mb-0 text-start">Khám phá nhanh theo nhu cầu</h2>
            </div>
            <a href="/client/categories" class="btn btn-outline-success rounded-pill px-4">Xem toàn bộ</a>
        </div>
        <div class="category-chip-grid">
            <c:forEach var="item" items="${categoryNames}">
                <a class="category-chip" href="/client/categories?category=${item}"><i class="fa-solid fa-leaf"></i>${item}</a>
            </c:forEach>
        </div>
    </section>

    <section class="mb-5">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
            <div>
                <div class="product-mini-tag"><i class="fa-solid fa-fire"></i> Hot trend</div>
                <h2 class="section-title mb-0 text-start">Sản phẩm nổi bật</h2>
            </div>
            <a href="/client/categories" class="btn btn-success rounded-pill px-4">Mua sắm ngay</a>
        </div>
        <div class="row g-4">
            <c:forEach var="product" items="${featuredProducts}">
                <div class="col-lg-3 col-md-4 col-sm-6">
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
                                <div class="product-mini-tag"><i class="fa-solid fa-fire"></i> Sản phẩm hot</div>
                            </div>
                            <div class="product-price"><fmt:formatNumber value="${product.price}" pattern="#,###"/>₫</div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <c:forEach var="section" items="${homeCategorySections}" varStatus="status">
        <section class="category-product-section mb-5">
            <div class="category-section-head">
                <div>
                    <div class="product-mini-tag"><i class="fa-solid fa-layer-group"></i> Phân tầng sản phẩm</div>
                    <h2 class="section-title mb-1 text-start">${section.category.name}</h2>
                    <p class="text-muted mb-0">${section.category.description}</p>
                </div>
                <a href="/client/categories?category=${section.category.name}" class="btn btn-outline-success rounded-pill px-4">Xem danh mục</a>
            </div>

            <div class="product-rail" aria-label="Sản phẩm ${section.category.name} chuyển động ngang">
                <div class="product-rail-track rail-delay-${status.index % 3}">
                    <c:forEach var="product" items="${section.products}">
                        <article class="rail-product-card">
                            <a href="/client/products/${product.id}" class="rail-product-img">
                                <img src="/uploads/${product.image}" alt="${product.name}">
                            </a>
                            <div class="rail-product-body">
                                <div class="product-mini-tag"><i class="fa-solid fa-tag"></i>${product.categories}</div>
                                <a href="/client/products/${product.id}" class="rail-product-name">${product.name}</a>
                                <div class="d-flex justify-content-between align-items-center gap-2 mt-2">
                                    <span class="product-price"><fmt:formatNumber value="${product.price}" pattern="#,###"/>₫</span>
                                    <button type="button" class="rail-cart-btn add-to-cart-btn" data-product-id="${product.id}"><i class="fa-solid fa-bag-shopping"></i></button>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </div>
        </section>
    </c:forEach>

    <section>
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
            <div>
                <div class="product-mini-tag"><i class="fa-solid fa-award"></i> Được yêu thích</div>
                <h2 class="section-title mb-0 text-start">Sản phẩm bán chạy</h2>
            </div>
        </div>
        <div class="row g-4">
            <c:forEach var="product" items="${bestSellingProducts}">
                <div class="col-lg-3 col-md-4 col-sm-6">
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
                                <div class="product-mini-tag"><i class="fa-solid fa-star"></i> Best seller</div>
                            </div>
                            <div class="product-price"><fmt:formatNumber value="${product.price}" pattern="#,###"/>₫</div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>
</main>

<jsp:include page="/WEB-INF/view/common/client-footer.jsp" />
<jsp:include page="/WEB-INF/view/common/client-assistant.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/resources/client/js/client-shop.js'/>"></script>
<script src="<c:url value='/resources/client/js/client-ai.js'/>"></script>
</body>
</html>
