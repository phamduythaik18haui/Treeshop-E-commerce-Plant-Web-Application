<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
</head>
<body class="bg-light">
<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="products"/></jsp:include>
<div class="main-content">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div><h3 class="fw-bold mb-1">Cập nhật sản phẩm</h3><p class="text-muted mb-0">Chỉnh sửa nhanh thông tin và ảnh sản phẩm.</p></div>
        <a href="/admin/products" class="btn btn-outline-secondary"><i class="fas fa-arrow-left me-2"></i>Quay lại</a>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-4">
            <form:form method="post" action="/admin/products/update" modelAttribute="product" enctype="multipart/form-data">
                <form:hidden path="id"/>
                <div class="row g-3">
                    <div class="col-md-6"><label class="form-label">Tên sản phẩm</label><form:input path="name" class="form-control"/></div>
                    <div class="col-md-6"><label class="form-label">Danh mục</label><form:select path="categories" class="form-select"><c:forEach var="item" items="${categoryOptions}"><form:option value="${item.name}">${item.name}</form:option></c:forEach></form:select></div>
                    <div class="col-md-4"><label class="form-label">Giá</label><form:input path="price" type="number" class="form-control"/></div>
                    <div class="col-md-4"><label class="form-label">Số lượng</label><form:input path="quantity" type="number" class="form-control"/></div>
                    <div class="col-md-2 form-check ms-3 mt-5"><form:checkbox path="isHot" class="form-check-input"/><label class="form-check-label">Hot</label></div>
                    <div class="col-md-2 form-check ms-3 mt-5"><form:checkbox path="isNew" class="form-check-input"/><label class="form-check-label">Mới</label></div>
                    <div class="col-md-6"><label class="form-label">Ảnh hiện tại</label><div><img src="/uploads/${product.image}" alt="${product.name}" style="width:140px;height:140px;object-fit:cover;border-radius:18px;"></div></div>
                    <div class="col-md-6"><label class="form-label">Ảnh chi tiết hiện tại</label><div><img src="/uploads/${product.imageDetail}" alt="${product.name}" style="width:140px;height:140px;object-fit:cover;border-radius:18px;"></div></div>
                    <div class="col-md-6"><label class="form-label">Đổi ảnh chính</label><input type="file" class="form-control" name="imageFile"></div>
                    <div class="col-md-6"><label class="form-label">Đổi ảnh chi tiết</label><input type="file" class="form-control" name="imageDetailFile"></div>
                    <div class="col-12"><label class="form-label">Mô tả ngắn</label><form:textarea path="shortDesc" rows="3" class="form-control"/></div>
                    <div class="col-12"><label class="form-label">Mô tả chi tiết</label><form:textarea path="detailDesc" rows="6" class="form-control"/></div>
                </div>
                <button class="btn btn-success mt-4 px-4">Lưu thay đổi</button>
            </form:form>
        </div>
    </div>
</div>
</div>
</body>
</html>
