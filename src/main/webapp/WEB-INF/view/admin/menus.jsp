<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý menu động</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="menus"/></jsp:include>

<div class="main-content">
    <div class="page-header">
        <div class="row align-items-center g-3">
            <div class="col">
                <h3 class="fw-bold mb-1">Quản lý menu động</h3>
                <p class="text-muted mb-0">Thêm/sửa/ẩn menu cho navbar client và sidebar admin từ bảng <strong>menus</strong>.</p>
            </div>
            <div class="col-auto">
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addMenuModal">
                    <i class="fas fa-plus me-2"></i>Thêm menu
                </button>
            </div>
        </div>
    </div>

    <c:if test="${not empty successMessage}"><div class="alert alert-success">${successMessage}</div></c:if>
    <c:if test="${not empty errorMessage}"><div class="alert alert-danger">${errorMessage}</div></c:if>

    <div class="card-custom mb-4">
        <div class="card-body">
            <form class="row g-3" method="get" action="/admin/menus">
                <div class="col-md-10"><input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="Tìm theo tên hoặc URL menu..."></div>
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
                        <th>Menu</th>
                        <th>URL</th>
                        <th>Loại</th>
                        <th>Menu cha</th>
                        <th>Thứ tự</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${menus}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1 + currentPage * menusPage.size}</td>
                            <td>
                                <div class="fw-semibold"><i class="${empty item.icon ? 'fa-solid fa-circle' : item.icon} me-2 text-success"></i>${item.name}</div>
                                <small class="text-muted">ID: ${item.id}</small>
                            </td>
                            <td><code>${item.url}</code></td>
                            <td><span class="badge ${item.menuType eq 'admin' ? 'bg-dark' : 'bg-success'}">${item.menuType}</span></td>
                            <td><c:choose><c:when test="${not empty item.parent}">${item.parent.name}</c:when><c:otherwise><span class="text-muted">Menu gốc</span></c:otherwise></c:choose></td>
                            <td>${item.sortOrder}</td>
                            <td><c:choose><c:when test="${item.active}"><span class="badge bg-success">Hiển thị</span></c:when><c:otherwise><span class="badge bg-secondary">Ẩn</span></c:otherwise></c:choose></td>
                            <td class="text-center">
                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editMenuModal"
                                        data-id="${item.id}"
                                        data-name="${item.name}"
                                        data-url="${item.url}"
                                        data-icon="${item.icon}"
                                        data-sort="${item.sortOrder}"
                                        data-type="${item.menuType}"
                                        data-parent="${not empty item.parent ? item.parent.id : ''}"
                                        data-active="${item.active}">
                                    <i class="fas fa-pen"></i>
                                </button>
                                <form action="/admin/menus/delete/${item.id}" method="post" class="d-inline">
                                    <button class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa menu ${item.name}? Menu con sẽ được đưa về menu gốc.')"><i class="fas fa-trash"></i></button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty menus}"><tr><td colspan="8" class="text-center py-4 text-muted">Chưa có menu phù hợp.</td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <c:if test="${menusPage.totalPages > 0}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item ${menusPage.first ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}">Trước</a></li>
                <c:forEach begin="0" end="${menusPage.totalPages - 1}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}"><a class="page-link" href="?page=${i}&keyword=${keyword}">${i + 1}</a></li>
                </c:forEach>
                <li class="page-item ${menusPage.last ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}">Sau</a></li>
            </ul>
        </nav>
    </c:if>
</div>

<div class="modal fade" id="addMenuModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Thêm menu</h5><button class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form:form method="post" action="/admin/menus/create" modelAttribute="newMenu">
                    <div class="row g-3">
                        <div class="col-md-6"><label class="form-label">Tên menu</label><form:input path="name" class="form-control" placeholder="VD: Sản phẩm"/></div>
                        <div class="col-md-6"><label class="form-label">URL</label><form:input path="url" class="form-control" placeholder="VD: /client/categories"/></div>
                        <div class="col-md-4"><label class="form-label">Icon FontAwesome</label><form:input path="icon" class="form-control" placeholder="fa-solid fa-seedling"/></div>
                        <div class="col-md-4"><label class="form-label">Loại menu</label><form:select path="menuType" class="form-select"><form:option value="main">main - Navbar client</form:option><form:option value="admin">admin - Sidebar admin</form:option></form:select></div>
                        <div class="col-md-4"><label class="form-label">Thứ tự</label><form:input path="sortOrder" type="number" class="form-control"/></div>
                        <div class="col-md-8">
                            <label class="form-label">Menu cha</label>
                            <select name="parentId" class="form-select">
                                <option value="">Menu gốc</option>
                                <c:forEach var="parent" items="${parentOptions}">
                                    <option value="${parent.id}">${parent.menuType} / ${parent.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4 d-flex align-items-end">
                            <div class="form-check mb-2"><form:checkbox path="active" class="form-check-input"/><label class="form-check-label">Hiển thị</label></div>
                        </div>
                    </div>
                    <button class="btn btn-success w-100 mt-4">Lưu menu</button>
                </form:form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editMenuModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Cập nhật menu</h5><button class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form action="/admin/menus/update" method="post">
                    <input type="hidden" name="id" id="editMenuId">
                    <div class="row g-3">
                        <div class="col-md-6"><label class="form-label">Tên menu</label><input name="name" id="editMenuName" class="form-control"></div>
                        <div class="col-md-6"><label class="form-label">URL</label><input name="url" id="editMenuUrl" class="form-control"></div>
                        <div class="col-md-4"><label class="form-label">Icon FontAwesome</label><input name="icon" id="editMenuIcon" class="form-control"></div>
                        <div class="col-md-4"><label class="form-label">Loại menu</label><select name="menuType" id="editMenuType" class="form-select"><option value="main">main - Navbar client</option><option value="admin">admin - Sidebar admin</option></select></div>
                        <div class="col-md-4"><label class="form-label">Thứ tự</label><input name="sortOrder" id="editMenuSort" type="number" class="form-control"></div>
                        <div class="col-md-8">
                            <label class="form-label">Menu cha</label>
                            <select name="parentId" id="editMenuParent" class="form-select">
                                <option value="">Menu gốc</option>
                                <c:forEach var="parent" items="${parentOptions}">
                                    <option value="${parent.id}">${parent.menuType} / ${parent.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4 d-flex align-items-end">
                            <input type="hidden" name="active" value="false">
                            <div class="form-check mb-2"><input class="form-check-input" type="checkbox" name="active" value="true" id="editMenuActive"><label class="form-check-label">Hiển thị</label></div>
                        </div>
                    </div>
                    <button class="btn btn-success w-100 mt-4">Cập nhật menu</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('editMenuModal').addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        document.getElementById('editMenuId').value = button.getAttribute('data-id') || '';
        document.getElementById('editMenuName').value = button.getAttribute('data-name') || '';
        document.getElementById('editMenuUrl').value = button.getAttribute('data-url') || '';
        document.getElementById('editMenuIcon').value = button.getAttribute('data-icon') || '';
        document.getElementById('editMenuSort').value = button.getAttribute('data-sort') || 0;
        document.getElementById('editMenuType').value = button.getAttribute('data-type') || 'main';
        document.getElementById('editMenuParent').value = button.getAttribute('data-parent') || '';
        document.getElementById('editMenuActive').checked = button.getAttribute('data-active') === 'true';
    });
</script>
</body>
</html>
