<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<head>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin-style.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
</head>

<nav class="navbar navbar-expand-lg navbar-dark admin-navbar sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">Admin Panel - KimiBeauty</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#adminNavbarResponsive" aria-controls="adminNavbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNavbarResponsive">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item <c:if test="${pageContext.request.requestURI.contains('/admin/dashboard')}">active</c:if>">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                </li>
                <li class="nav-item <c:if test="${pageContext.request.requestURI.contains('/admin/appointments')}">active</c:if>">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/appointments/list">Lịch Hẹn</a>
                </li>
                <li class="nav-item dropdown <c:if test="${pageContext.request.requestURI.contains('/admin/users') || pageContext.request.requestURI.contains('/admin/staff-schedules')}">active</c:if>">
                    <a class="nav-link dropdown-toggle" href="#" id="managementDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        Quản Lý
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="managementDropdown">
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/users/list">Người Dùng</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/staff-schedules/list">Lịch Nhân Viên</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/services/list">Dịch Vụ</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/nail-collections/list">Bộ Sưu Tập Nail</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/nail-arts/list">Mẫu Nail</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/expenses/list">Chi Phí</a>
                    </div>
                </li>
                <li class="nav-item dropdown <c:if test="${pageContext.request.requestURI.contains('/admin/reports')}">active</c:if>">
                    <a class="nav-link dropdown-toggle" href="#" id="reportsDropdownAdmin" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        Báo Cáo
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="reportsDropdownAdmin">
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reports/revenue">Doanh Thu</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reports/popular-services">Dịch Vụ Phổ Biến</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reports/staff-performance">Hiệu Suất Nhân Viên</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reports/loyal-customers">Khách Hàng TT</a>
                    </div>
                </li>

                <c:if test="${not empty sessionScope.loggedInUser}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="adminUserDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <c:out value="${sessionScope.loggedInUser.fullName}"/>
                        </a>
                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="adminUserDropdown">
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/">Xem Trang Khách</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng Xuất</a>
                        </div>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>