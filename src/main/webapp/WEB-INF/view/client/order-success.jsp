<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><title>Đặt hàng thành công</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="<c:url value='/resources/client/css/client-shared.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-ai.css'/>">
</head><body class="bg-light">
<div class="container py-5">
    <div class="card p-4">
        <h3 class="text-success">🎉 Đặt hàng thành công!</h3>
        <p>Mã đơn: <b>#${order.id}</b></p>
        <p>Tổng thanh toán:
            <b class="text-success"><fmt:formatNumber value="${order.totalPrice}" pattern="#,###"/>₫</b>
            — phương thức: <b>${order.paymentMethod}</b>,
            TT: <b>${order.paymentStatus}</b>
        </p>
        <hr/>
        <h5>Sản phẩm</h5>
        <c:forEach var="it" items="${items}">
            <div class="d-flex justify-content-between">
                <div>${it.product.name} (x${it.quantity})</div>
                <div><fmt:formatNumber value="${it.price * it.quantity}" pattern="#,###"/>₫</div>
            </div>
        </c:forEach>
        <hr/>
        <a class="btn btn-primary" href="/client/indexs">Về trang chủ</a>
        <a class="btn btn-outline-secondary" href="/client/categories">Tiếp tục mua sắm</a>
    </div>
</div>
<jsp:include page="/WEB-INF/view/common/client-footer.jsp" />
<jsp:include page="/WEB-INF/view/common/client-assistant.jsp" />
<script src="<c:url value='/resources/client/js/client-ai.js'/>"></script>
</body></html>
