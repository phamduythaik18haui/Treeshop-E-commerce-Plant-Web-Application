<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/categories.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="categories"/></jsp:include>

<div class="main-content">
    <div class="page-header">
        <div class="row align-items-center g-3">
            <div class="col"><h3 class="fw-bold mb-1">Quản lý danh mục</h3><p class="text-muted mb-0">Danh mục giờ được quản lý riêng, không còn là trang tĩnh.</p></div>
            <div class="col-auto"><button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addCategoryModal"><i class="fas fa-plus me-2"></i>Thêm danh mục</button></div>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-4"><div class="card-custom p-4 text-center"><div class="fs-3 fw-bold text-success">${totalCategories}</div><div class="text-muted">Tổng danh mục</div></div></div>
        <div class="col-md-4"><div class="card-custom p-4 text-center"><div class="fs-3 fw-bold text-primary">${activeCategories}</div><div class="text-muted">Đang hoạt động</div></div></div>
        <div class="col-md-4"><div class="card-custom p-4 text-center"><div class="fs-3 fw-bold text-warning">${categoriesPage.totalElements}</div><div class="text-muted">Kết quả hiện tại</div></div></div>
    </div>

    <c:if test="${not empty successMessage}"><div class="alert alert-success">${successMessage}</div></c:if>
    <c:if test="${not empty errorMessage}"><div class="alert alert-danger">${errorMessage}</div></c:if>

    <div class="card-custom mb-4">
        <div class="card-body">
            <form class="row g-3" method="get" action="/admin/categories">
                <div class="col-md-10"><input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="Tìm theo tên danh mục..."></div>
                <div class="col-md-2 d-grid"><button class="btn btn-outline-success">Tìm kiếm</button></div>
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
                        <th>Tên danh mục</th>
                        <th>Mô tả</th>
                        <th>Sản phẩm</th>
                        <th>Hiển thị trang chủ</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${categories}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1 + currentPage * categoriesPage.size}</td>
                            <td class="fw-semibold">${item.name}</td>
                            <td>${item.description}</td>
                            <td><span class="badge bg-light text-dark">${categoryProductCounts[item.name]}</span></td>
                            <td><span class="badge bg-info text-dark">${item.homeDisplayLimit} sản phẩm</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.active}"><span class="badge bg-success">Hoạt động</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">Ẩn</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editCategoryModal"
                                        data-id="${item.id}" data-name="${item.name}" data-description="${item.description}" data-limit="${item.homeDisplayLimit}" data-active="${item.active}">
                                    <i class="fas fa-pen"></i>
                                </button>
                                <form action="/admin/categories/delete/${item.id}" method="post" class="d-inline">
                                    <button class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa danh mục ${item.name}?')"><i class="fas fa-trash"></i></button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty categories}"><tr><td colspan="7" class="text-center py-4 text-muted">Chưa có danh mục phù hợp.</td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item ${categoriesPage.first ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}">Trước</a></li>
            <c:forEach begin="0" end="${categoriesPage.totalPages - 1}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}"><a class="page-link" href="?page=${i}&keyword=${keyword}">${i + 1}</a></li>
            </c:forEach>
            <li class="page-item ${categoriesPage.last ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}">Sau</a></li>
        </ul>
    </nav>
</div>

<div class="modal fade" id="addCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Thêm danh mục</h5><button class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form:form method="post" action="/admin/categories/create" modelAttribute="newCategory">
                    <div class="mb-3"><label class="form-label">Tên danh mục</label><form:input path="name" class="form-control"/></div>
                    <div class="mb-3"><label class="form-label">Mô tả</label><form:textarea path="description" class="form-control" rows="3"/></div>
                    <div class="mb-3"><label class="form-label">Số sản phẩm hiển thị ở trang chủ</label><form:input path="homeDisplayLimit" type="number" min="1" max="24" class="form-control"/></div>
                    <div class="form-check mb-3"><form:checkbox path="active" class="form-check-input"/><label class="form-check-label">Hiển thị danh mục</label></div>
                    <button class="btn btn-success w-100">Lưu danh mục</button>
                </form:form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Cập nhật danh mục</h5><button class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form action="/admin/categories/update" method="post">
                    <input type="hidden" name="id" id="editCategoryId">
                    <div class="mb-3"><label class="form-label">Tên danh mục</label><input type="text" class="form-control" name="name" id="editCategoryName"></div>
                    <div class="mb-3"><label class="form-label">Mô tả</label><textarea class="form-control" rows="3" name="description" id="editCategoryDescription"></textarea></div>
                    <div class="mb-3"><label class="form-label">Số sản phẩm hiển thị ở trang chủ</label><input type="number" min="1" max="24" class="form-control" name="homeDisplayLimit" id="editCategoryLimit"></div>
                    <input type="hidden" name="active" value="false"><div class="form-check mb-3"><input class="form-check-input" type="checkbox" name="active" value="true" id="editCategoryActive"><label class="form-check-label">Hiển thị danh mục</label></div>
                    <button class="btn btn-success w-100">Cập nhật</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('editCategoryModal').addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        document.getElementById('editCategoryId').value = button.getAttribute('data-id');
        document.getElementById('editCategoryName').value = button.getAttribute('data-name');
        document.getElementById('editCategoryDescription').value = button.getAttribute('data-description');
        document.getElementById('editCategoryLimit').value = button.getAttribute('data-limit') || 8;
        document.getElementById('editCategoryActive').checked = button.getAttribute('data-active') === 'true';
    });
</script>
</body>
</html>
