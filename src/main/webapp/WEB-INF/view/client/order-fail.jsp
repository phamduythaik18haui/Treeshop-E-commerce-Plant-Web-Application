<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><title>Thanh toán thất bại</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="<c:url value='/resources/client/css/client-shared.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-ai.css'/>">
</head><body class="bg-light">
<div class="container py-5">
  <div class="card p-4">
    <h3 class="text-danger">Thanh toán thất bại</h3>
    <p>Mã đơn: <b>#${order.id}</b></p>
    <p>Phương thức: <b>${order.paymentMethod}</b> | Trạng thái: <b>${order.paymentStatus}</b></p>
    <c:if test="${not empty reason}">
      <p class="text-muted">Lý do: ${reason}</p>
    </c:if>
    <div class="mt-3">
      <a class="btn btn-warning" href="/client/payment/vnpay/create?orderId=${order.id}">Thanh toán lại VNPAY</a>
      <a class="btn btn-warning" href="/client/payment/momo/create?orderId=${order.id}">Thanh toán lại MoMo</a>
      <a class="btn btn-outline-secondary" href="/client/indexs">Về trang chủ</a>
    </div>
  </div>
</div>
<jsp:include page="/WEB-INF/view/common/client-footer.jsp" />
<jsp:include page="/WEB-INF/view/common/client-assistant.jsp" />
<script src="<c:url value='/resources/client/js/client-ai.js'/>"></script>
</body></html>
