<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Cây Xanh</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Admin CSS -->
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/index.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/admin/admincss/admin-shared.css'/>">
</head>
<body>

<c:set var="adminUser" value="${not empty sessionScope.user ? sessionScope.user : sessionScope.currentUser}" />

<jsp:include page="/WEB-INF/view/common/admin-sidebar.jsp"><jsp:param name="active" value="dashboard"/></jsp:include>

<!-- Main Content -->
<div class="main-content">
    <div class="admin-header">
        <div class="row align-items-center">
            <div class="col">
                <h3 class="mb-0 fw-bold">Dashboard</h3>
                <p class="text-muted mb-0">Tổng quan hệ thống</p>
            </div>

            <div class="col-auto">
                <div class="user-info d-flex align-items-center gap-3">
                    <div class="user-avatar"><i class="fas fa-user"></i></div>
                    <div class="text-end">
                        <div class="fw-bold">
                            <c:out value="${adminUser.fullName != null ? adminUser.fullName : 'Admin User'}" />
                        </div>
                        <small class="text-muted d-block">
                            <c:if test="${not empty adminUser and not empty adminUser.roles}">
                                <c:out value="${adminUser.roles.name}" />
                            </c:if>
                        </small>
                        <div class="mt-2">
                            <a href="<c:url value='/client/logout'/>" class="btn btn-sm btn-outline-danger">
                                <i class="fas fa-sign-out-alt me-1"></i> Đăng xuất
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Statistics -->
    <div class="row g-4 mb-4">
        <div class="col-xl-3 col-md-6">
            <div class="stat-card products">
                <div class="stat-icon text-info"><i class="fas fa-tree"></i></div>
                <div class="stat-number text-info">${stats.totalProducts}</div>
                <div class="stat-label">Tổng sản phẩm</div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="stat-card users">
                <div class="stat-icon text-warning"><i class="fas fa-users"></i></div>
                <div class="stat-number text-warning">${stats.totalUsers}</div>
                <div class="stat-label">Người dùng</div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="stat-card orders">
                <div class="stat-icon text-success"><i class="fas fa-shopping-cart"></i></div>
                <div class="stat-number text-success">${stats.totalOrders}</div>
                <div class="stat-label">Đơn hàng</div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="stat-card revenue">
                <div class="stat-icon text-danger"><i class="fas fa-dollar-sign"></i></div>
                <div class="stat-number text-danger">
                    <fmt:formatNumber value="${stats.totalRevenue}" pattern="#,##0"/>₫
                </div>
                <div class="stat-label">Doanh thu</div>
            </div>
        </div>
    </div>

    <!-- Recent Orders -->
    <div class="row g-4">
        <div class="col-lg-8">
            <div class="recent-card">
                <div class="card-header">
                    <h5 class="mb-0 fw-bold">
                        <i class="fas fa-clock me-2 text-warning"></i> Đơn hàng gần đây
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Khách hàng</th>
                                <th>Số tiền</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty recentOrders}">
                                    <tr><td colspan="4" class="text-center text-muted py-4">Chưa có dữ liệu</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="o" items="${recentOrders}">
                                        <tr>
                                            <td>#${o.id}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty o.user}">
                                                        ${o.user.fullName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted fst-italic">Khách vãng lai</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatNumber value="${o.totalPrice}" pattern="#,##0"/>₫</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${o.status eq 'pending'}">
                                                        <span class="badge bg-warning text-dark">Chờ xử lý</span>
                                                    </c:when>
                                                    <c:when test="${o.status eq 'confirmed'}">
                                                        <span class="badge bg-info text-dark">Đã xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${o.status eq 'shipping'}">
                                                        <span class="badge bg-primary">Đang giao</span>
                                                    </c:when>
                                                    <c:when test="${o.status eq 'delivered'}">
                                                        <span class="badge bg-success">Hoàn thành</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Không xác định</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column -->
        <div class="col-lg-4">
            <div class="recent-card mb-4">
                <div class="card-header"><h5 class="fw-bold"><i class="fas fa-bolt me-2 text-primary"></i> Thao tác nhanh</h5></div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="<c:url value='/admin/products'/>" class="btn btn-primary"><i class="fas fa-plus me-2"></i> Thêm sản phẩm</a>
                        <a href="<c:url value='/admin/orders'/>" class="btn btn-success"><i class="fas fa-shopping-cart me-2"></i> Xem đơn hàng</a>
                        <a href="<c:url value='/admin/categories'/>" class="btn btn-info text-white"><i class="fas fa-list me-2"></i> Quản lý danh mục</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
