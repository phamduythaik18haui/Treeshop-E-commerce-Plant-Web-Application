<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/product.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="products"/></jsp:include>

<div class="main-content">
    <div class="page-header">
        <div class="row align-items-center g-3">
            <div class="col"><h3 class="mb-1 fw-bold">Quản lý sản phẩm</h3><p class="text-muted mb-0">Đã thêm phân trang thật và lọc theo danh mục/từ khóa.</p></div>
            <div class="col-auto"><button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addProductModal"><i class="fas fa-plus me-2"></i>Thêm sản phẩm</button></div>
        </div>
    </div>

    <c:if test="${not empty successMessage}"><div class="alert alert-success">${successMessage}</div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

    <div class="card-custom mb-4">
        <div class="card-body">
            <form class="row g-3" method="get" action="/admin/products">
                <div class="col-lg-5"><input class="form-control" name="keyword" value="${keyword}" placeholder="Tìm theo tên sản phẩm"></div>
                <div class="col-lg-5">
                    <select class="form-select" name="category">
                        <option value="">Tất cả danh mục</option>
                        <c:forEach var="item" items="${categoryOptions}">
                            <option value="${item.name}" ${item.name == category ? 'selected' : ''}>${item.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-lg-2 d-grid"><button class="btn btn-outline-success">Lọc</button></div>
            </form>
        </div>
    </div>

    <div class="card-custom">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Sản phẩm</th>
                        <th>Danh mục</th>
                        <th>Giá</th>
                        <th>Tồn kho</th>
                        <th>Đã bán</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="product" items="${productsList}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1 + currentPage * productsPage.size}</td>
                            <td>
                                <div class="d-flex align-items-center gap-3">
                                    <img src="/uploads/${product.image}" style="width:52px;height:52px;object-fit:cover;border-radius:12px;" alt="${product.name}">
                                    <div>
                                        <div class="fw-bold">${product.name}</div>
                                        <small class="text-muted">${product.isHot ? 'Hot' : 'Thường'} · ${product.isNew ? 'Mới' : 'Ổn định'}</small>
                                    </div>
                                </div>
                            </td>
                            <td><span class="badge bg-secondary">${product.categories}</span></td>
                            <td class="text-success fw-bold"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0"/> ₫</td>
                            <td><span class="badge ${product.quantity > 0 ? 'bg-success' : 'bg-danger'}">${product.quantity}</span></td>
                            <td>${product.sold}</td>
                            <td class="text-center">
                                <a href="/admin/products/view/${product.id}" class="btn btn-sm btn-outline-primary"><i class="fa-regular fa-eye"></i></a>
                                <a href="/admin/products/update/${product.id}" class="btn btn-sm btn-outline-warning"><i class="fa-regular fa-pen-to-square"></i></a>
                                <a href="/admin/products/delete/${product.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa sản phẩm ${product.name}?')"><i class="fa-regular fa-trash-can"></i></a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty productsList}"><tr><td colspan="7" class="text-center py-4 text-muted">Không có sản phẩm phù hợp.</td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item ${productsPage.first ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}&category=${category}">Trước</a></li>
            <c:forEach begin="0" end="${productsPage.totalPages - 1}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}"><a class="page-link" href="?page=${i}&keyword=${keyword}&category=${category}">${i + 1}</a></li>
            </c:forEach>
            <li class="page-item ${productsPage.last ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}&category=${category}">Sau</a></li>
        </ul>
    </nav>
</div>

<div class="modal fade" id="addProductModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Thêm sản phẩm mới</h5><button class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form:form method="post" action="/admin/products/create" modelAttribute="newProduct" enctype="multipart/form-data">
                    <div class="row g-3">
                        <div class="col-md-6"><label class="form-label">Tên sản phẩm</label><form:input path="name" class="form-control"/></div>
                        <div class="col-md-6"><label class="form-label">Danh mục</label><form:select path="categories" class="form-select"><form:option value="">Chọn danh mục</form:option><c:forEach var="item" items="${categoryOptions}"><form:option value="${item.name}">${item.name}</form:option></c:forEach></form:select></div>
                        <div class="col-md-6"><label class="form-label">Giá</label><form:input path="price" type="number" class="form-control"/></div>
                        <div class="col-md-6"><label class="form-label">Số lượng</label><form:input path="quantity" type="number" class="form-control"/></div>
                        <div class="col-md-6"><label class="form-label">Ảnh chính</label><input type="file" name="imageFile" class="form-control"></div>
                        <div class="col-md-6"><label class="form-label">Ảnh chi tiết</label><input type="file" name="imageDetailFile" class="form-control"></div>
                        <div class="col-md-6 form-check ms-2"><form:checkbox path="isHot" class="form-check-input"/><label class="form-check-label">Sản phẩm nổi bật</label></div>
                        <div class="col-md-6 form-check ms-2"><form:checkbox path="isNew" class="form-check-input"/><label class="form-check-label">Sản phẩm mới</label></div>
                        <div class="col-12"><label class="form-label">Mô tả ngắn</label><form:textarea path="shortDesc" class="form-control" rows="2"/></div>
                        <div class="col-12"><label class="form-label">Mô tả chi tiết</label><form:textarea path="detailDesc" class="form-control" rows="4"/></div>
                    </div>
                    <button class="btn btn-success w-100 mt-4">Lưu sản phẩm</button>
                </form:form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
