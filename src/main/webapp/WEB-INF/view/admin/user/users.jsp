<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/user.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="users"/></jsp:include>

<div class="main-content">
    <div class="page-header">
        <div class="row align-items-center g-3">
            <div class="col"><h3 class="mb-1 fw-bold">Quản lý người dùng</h3><p class="text-muted mb-0">Đã thêm lọc vai trò, tìm kiếm và phân trang thật.</p></div>
            <div class="col-auto"><button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addUserModal"><i class="fas fa-plus me-2"></i>Thêm người dùng</button></div>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-xl-3 col-md-6"><div class="card-custom text-center p-4"><div class="text-primary fw-bold fs-3">${totalUser}</div><div class="text-muted">Tổng người dùng</div></div></div>
        <div class="col-xl-3 col-md-6"><div class="card-custom text-center p-4"><div class="text-success fw-bold fs-3">${clientCount}</div><div class="text-muted">Khách hàng</div></div></div>
        <div class="col-xl-3 col-md-6"><div class="card-custom text-center p-4"><div class="text-warning fw-bold fs-3">${staffCount}</div><div class="text-muted">Nhân viên</div></div></div>
        <div class="col-xl-3 col-md-6"><div class="card-custom text-center p-4"><div class="text-danger fw-bold fs-3">${adminCount}</div><div class="text-muted">Quản trị viên</div></div></div>
    </div>

    <div class="card-custom mb-4">
        <div class="card-body">
            <form class="row g-3" method="get" action="/admin/users">
                <div class="col-lg-6"><input class="form-control" name="keyword" value="${keyword}" placeholder="Tìm tên hoặc email"></div>
                <div class="col-lg-4">
                    <select class="form-select" name="roleId">
                        <option value="">Tất cả vai trò</option>
                        <option value="1" ${roleId == 1 ? 'selected' : ''}>Quản trị viên</option>
                        <option value="2" ${roleId == 2 ? 'selected' : ''}>Nhân viên</option>
                        <option value="3" ${roleId == 3 ? 'selected' : ''}>Khách hàng</option>
                    </select>
                </div>
                <div class="col-lg-2 d-grid"><button class="btn btn-outline-success">Lọc</button></div>
            </form>
        </div>
    </div>

    <div class="card-custom">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Tên người dùng</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Vai trò</th>
                        <th>Ngày đăng ký</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${usersList}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1 + currentPage * usersPage.size}</td>
                            <td>${user.fullName}</td>
                            <td>${user.email}</td>
                            <td>${user.phone}</td>
                            <td><span class="badge bg-light text-dark">${user.roles.name}</span></td>
                            <td>${user.createdDate}</td>
                            <td class="text-center">
                                <a href="/admin/users/views/${user.id}" class="btn btn-sm btn-outline-primary"><i class="fa-regular fa-eye"></i></a>
                                <a href="/admin/users/update/${user.id}" class="btn btn-sm btn-outline-warning"><i class="fa-regular fa-pen-to-square"></i></a>
                                <a href="/admin/users/delete/${user.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa người dùng ${user.fullName}?')"><i class="fa-regular fa-trash-can"></i></a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty usersList}"><tr><td colspan="7" class="text-center py-4 text-muted">Không có người dùng phù hợp.</td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item ${usersPage.first ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}&roleId=${roleId}">Trước</a></li>
            <c:forEach begin="0" end="${usersPage.totalPages - 1}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}"><a class="page-link" href="?page=${i}&keyword=${keyword}&roleId=${roleId}">${i + 1}</a></li>
            </c:forEach>
            <li class="page-item ${usersPage.last ? 'disabled' : ''}"><a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}&roleId=${roleId}">Sau</a></li>
        </ul>
    </nav>
</div>

<div class="modal fade" id="addUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Thêm người dùng mới</h5><button class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form:form method="post" action="/admin/users/create" modelAttribute="newUser">
                    <div class="mb-3"><label class="form-label">Họ tên</label><form:input path="fullName" class="form-control"/></div>
                    <div class="mb-3"><label class="form-label">Email</label><form:input path="email" class="form-control" type="email"/></div>
                    <div class="mb-3"><label class="form-label">Tên đăng nhập</label><form:input path="username" class="form-control"/></div>
                    <div class="mb-3"><label class="form-label">Mật khẩu</label><form:input path="password" class="form-control" type="password"/></div>
                    <div class="mb-3"><label class="form-label">Số điện thoại</label><form:input path="phone" class="form-control"/></div>
                    <div class="mb-3"><label class="form-label">Vai trò</label><form:select path="roles.id" class="form-select"><form:option value="1">Quản trị viên</form:option><form:option value="2">Nhân viên</form:option><form:option value="3">Khách hàng</form:option></form:select></div>
                    <button class="btn btn-success w-100">Lưu người dùng</button>
                </form:form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
