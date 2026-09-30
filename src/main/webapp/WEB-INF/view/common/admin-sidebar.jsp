<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="sidebar">
    <div class="brand">
        <div class="brand-icon"><i class="fas fa-leaf"></i></div>
        <div>
            <h4 class="mb-0">TREESHOP</h4>
            <small>Admin Panel</small>
        </div>
    </div>

    <nav class="nav flex-column mt-4">
        <c:if test="${not empty adminMenus}">
            <div class="sidebar-section-title"></div>
            <c:forEach var="menu" items="${adminMenus}">
                <a href="<c:url value='${empty menu.url ? "#" : menu.url}'/>" class="nav-link">
                    <i class="${empty menu.icon ? 'fas fa-circle' : menu.icon}"></i><span>${menu.name}</span>
                </a>
                <c:forEach var="child" items="${menu.children}">
                    <c:if test="${child.active}">
                        <a href="<c:url value='${empty child.url ? "#" : child.url}'/>" class="nav-link admin-child-link">
                            <i class="${empty child.icon ? 'fas fa-angle-right' : child.icon}"></i><span>${child.name}</span>
                        </a>
                    </c:if>
                </c:forEach>
            </c:forEach>
        </c:if>
    </nav>

    <div class="sidebar-footer">
        <a href="<c:url value='/client/logout'/>" class="nav-link nav-link-logout">
            <i class="fas fa-sign-out-alt"></i><span>Đăng xuất</span>
        </a>
    </div>
</div>
