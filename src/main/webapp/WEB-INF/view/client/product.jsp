<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giới thiệu | Treeshop</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-shared.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-ai.css'/>">
    <style>
        .about-hero{background:linear-gradient(135deg,#1f7a4c 0%,#78c58a 100%);color:#fff;padding:72px 0 56px}
        .hero-img{border-radius:24px;box-shadow:0 20px 40px rgba(0,0,0,.18);object-fit:cover;height:340px;width:100%}
        .icon-pill{width:48px;height:48px;border-radius:16px;display:inline-flex;align-items:center;justify-content:center;background:#e8f5ee;color:#198754}
        .feature{border:1px solid #eef2ee;border-radius:18px;padding:18px;height:100%;background:#fff;box-shadow:0 18px 38px rgba(15,23,42,.05)}
        .stat{border-radius:20px;background:#f8fff9;box-shadow:0 18px 38px rgba(15,23,42,.05)}
        .step{border-left:4px solid #198754;padding-left:14px;background:#fff;border-radius:12px;padding-top:6px;padding-bottom:6px}
        .quote{border-left:4px solid #ddd;padding-left:14px;font-style:italic;background:#fff;border-radius:12px;padding-top:14px;padding-bottom:14px;box-shadow:0 18px 38px rgba(15,23,42,.05)}
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/view/common/client-navbar.jsp"><jsp:param name="active" value="about"/></jsp:include>

<section class="about-hero">
    <div class="container">
        <div class="row g-4 align-items-center">
            <div class="col-lg-6">
                <div class="product-mini-tag text-white mb-3"><i class="fa-solid fa-circle-info"></i> Câu chuyện thương hiệu</div>
                <h1 class="fw-bold mb-3">Treeshop — Cây xanh cho mọi không gian</h1>
                <p class="mb-4">Chúng tôi mang đến cây cảnh chất lượng, dễ chăm, giao nhanh tận nơi và tư vấn chọn cây phù hợp với không gian sống, văn phòng và cửa hàng của bạn.</p>
                <a href="<c:url value='/client/categories'/>" class="btn btn-light text-success fw-semibold me-2 rounded-pill px-4">
                    <i class="fa-solid fa-bag-shopping me-2"></i>Xem sản phẩm
                </a>
                <a href="<c:url value='/client/contact'/>" class="btn btn-outline-light rounded-pill px-4"><i class="fa-regular fa-paper-plane me-2"></i>Liên hệ nhanh</a>
            </div>
            <div class="col-lg-6">
                <img class="hero-img" src="<c:url value='/resources/client/img/banner6.jpg'/>" alt="Treeshop">
            </div>
        </div>
    </div>
</section>

<section class="py-5">
    <div class="container">
        <div class="row g-4 align-items-center">
            <div class="col-lg-6">
                <img class="w-100 rounded-4 shadow-sm" style="object-fit:cover;height:500px" src="<c:url value='/resources/client/img/luoi%20ho.jpg'/>" alt="Cây nội thất">
            </div>
            <div class="col-lg-6">
                <div class="product-mini-tag mb-3"><i class="fa-solid fa-seedling"></i> Về Treeshop</div>
                <h3 class="fw-bold mb-3">Chúng tôi chọn cây kỹ ngay từ đầu</h3>
                <p>Treeshop là cửa hàng cây cảnh tại Lập Thạch, Vĩnh Phúc. Chúng tôi chọn lọc từng chậu cây khỏe, rễ tốt và đóng gói cẩn thận, đảm bảo cây đến tay bạn luôn tươi xanh.</p>
                <ul class="list-unstyled mt-3">
                    <li class="mb-2"><span class="icon-pill me-2"><i class="fa-solid fa-spray-can-sparkles"></i></span> Cây khỏe – rễ chắc – đã qua dưỡng</li>
                    <li class="mb-2"><span class="icon-pill me-2"><i class="fa-solid fa-truck-fast"></i></span> Giao nhanh nội tỉnh, COD toàn quốc</li>
                    <li class="mb-2"><span class="icon-pill me-2"><i class="fa-solid fa-shield-heart"></i></span> Bảo hành sinh trưởng 7–14 ngày</li>
                    <li><span class="icon-pill me-2"><i class="fa-solid fa-headset"></i></span> Tư vấn chăm sóc trọn đời qua Zalo/Facebook</li>
                </ul>
            </div>
        </div>
    </div>
</section>

<section class="py-4">
    <div class="container">
        <h4 class="fw-bold mb-3">Vì sao chọn Treeshop?</h4>
        <div class="row g-3">
            <div class="col-6 col-lg-4"><div class="feature"><i class="fa-solid fa-star me-2 text-warning"></i> Cây loại A, tuyển vườn</div></div>
            <div class="col-6 col-lg-4"><div class="feature"><i class="fa-solid fa-tags me-2 text-success"></i> Giá hợp lý – minh bạch</div></div>
            <div class="col-6 col-lg-4"><div class="feature"><i class="fa-solid fa-rotate me-2 text-primary"></i> Đổi trả 7 ngày nếu lỗi</div></div>
            <div class="col-6 col-lg-4"><div class="feature"><i class="fa-solid fa-leaf me-2 text-success"></i> Combo, gói quà tặng theo yêu cầu</div></div>
            <div class="col-6 col-lg-4"><div class="feature"><i class="fa-solid fa-building me-2 text-secondary"></i> Ưu đãi cho doanh nghiệp/văn phòng</div></div>
            <div class="col-6 col-lg-4"><div class="feature"><i class="fa-solid fa-recycle me-2 text-success"></i> Tái sử dụng chậu & vật tư – xanh hơn</div></div>
        </div>
    </div>
</section>

<section class="py-4">
    <div class="container">
        <div class="row text-center g-3">
            <div class="col-4"><div class="stat p-3"><div class="fs-4 fw-bold">120+</div><div>Sản phẩm</div></div></div>
            <div class="col-4"><div class="stat p-3"><div class="fs-4 fw-bold">2.000+</div><div>Khách hàng hài lòng</div></div></div>
            <div class="col-4"><div class="stat p-3"><div class="fs-4 fw-bold">5+</div><div>Năm đồng hành</div></div></div>
        </div>
    </div>
</section>

<section class="py-5">
    <div class="container">
        <h4 class="fw-bold mb-3">Mua cây tại Treeshop chỉ với 3 bước</h4>
        <div class="row g-3">
            <div class="col-lg-4"><div class="step"><b>1. Chọn cây</b><div>Vào danh mục, lọc theo nhu cầu: để bàn, nội thất, phong thủy…</div></div></div>
            <div class="col-lg-4"><div class="step"><b>2. Xác nhận đơn</b><div>Đặt hàng trên web hoặc inbox để nhận tư vấn nhanh.</div></div></div>
            <div class="col-lg-4"><div class="step"><b>3. Nhận cây</b><div>Giao tận nơi trong 2–24h nội tỉnh, kèm hướng dẫn chăm sóc.</div></div></div>
        </div>
    </div>
</section>

<section class="py-4">
    <div class="container">
        <div class="row g-3">
            <div class="col-lg-6"><div class="quote">“Cây nhận được rất tươi, đóng gói chắc chắn. Bạn tư vấn nhiệt tình, văn phòng mình ai cũng khen.” — <b>Minh Anh</b></div></div>
            <div class="col-lg-6"><div class="quote">“Lần đầu mua cây online mà yên tâm vậy. Có bảo hành và hướng dẫn chăm rất chi tiết.” — <b>Quốc Huy</b></div></div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/view/common/client-footer.jsp" />
<jsp:include page="/WEB-INF/view/common/client-assistant.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/resources/client/js/client-shop.js'/>"></script>
<script src="<c:url value='/resources/client/js/client-ai.js'/>"></script>
</body>
</html>
