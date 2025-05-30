<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- Thêm nếu bạn cần format ngày tháng, số --%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"> <%-- Thêm viewport cho responsive --%>
    <title>Quản Lý Người Dùng - Admin Panel</title> <%-- Title cụ thể hơn --%>

    <%-- Include phần head chung (chứa link CSS Bootstrap, admin-style.css, fonts) --%>
    <jsp:include page="_header_admin.jsp" />

    <%-- Nếu trang này có CSS hoặc JS riêng biệt, bạn có thể link ở đây --%>
</head>
<body>
<%-- Navbar đã được include bên trong _header_admin.jsp --%>

<div class="container-fluid admin-container"> <%-- Sử dụng class bọc chung --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="admin-page-title mb-0">Danh Sách Người Dùng</h2> <%-- Sử dụng class tiêu đề --%>
        <div>
            <a href="${pageContext.request.contextPath}/admin/users/new" class="btn btn-success">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-lg mr-1" viewBox="0 0 16 16">
                    <path fill-rule="evenodd" d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2"/>
                </svg>
                Thêm Người Dùng
            </a>
        </div>
    </div>

    <c:if test="${not empty sessionScope.successMessage_user}"> <%-- Ví dụ về flash message --%>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <c:out value="${sessionScope.successMessage_user}"/>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">×</span>
        </button>
    </div>
        <c:remove var="successMessage_user" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage_user}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <c:out value="${sessionScope.errorMessage_user}"/>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">×</span>
        </button>
    </div>
        <c:remove var="errorMessage_user" scope="session"/>
    </c:if>

    <div class="card admin-form"> <%-- Bọc bảng trong card để có style đồng nhất --%>
        <div class="card-body p-0"> <%-- Loại bỏ padding mặc định của card-body nếu bảng đã có margin --%>
            <div class="table-responsive"> <%-- Cho bảng responsive trên màn hình nhỏ --%>
                <table class="table table-hover table-striped mb-0"> <%-- Bỏ table-bordered nếu muốn, thêm mb-0 nếu card-body p-0 --%>
                    <thead class="thead-dark"> <%-- Hoặc bỏ thead-dark để dùng style từ admin-style.css --%>
                    <tr>
                        <th>ID</th>
                        <th>Họ Tên</th>
                        <th>Email</th>
                        <th>Điện Thoại</th>
                        <th>Vai Trò</th>
                        <th>Trạng Thái</th>
                        <th class="text-center">Hành Động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${listUser}">
                        <tr>
                            <td><c:out value="${user.userId}" /></td>
                            <td><c:out value="${user.fullName}" /></td>
                            <td><c:out value="${user.email}" /></td>
                            <td><c:out value="${user.phoneNumber}" default="-" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.role == 'admin'}"><span class="badge badge-danger">Admin</span></c:when>
                                    <c:when test="${user.role == 'staff'}"><span class="badge badge-info">Nhân viên</span></c:when>
                                    <c:when test="${user.role == 'cashier'}"><span class="badge badge-warning text-dark">Thu ngân</span></c:when> <%-- Thêm text-dark cho dễ đọc trên nền vàng --%>
                                    <c:when test="${user.role == 'customer'}"><span class="badge badge-primary">Khách hàng</span></c:when>
                                    <c:otherwise><c:out value="${user.role}" /></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${user.active}">
                                    <span class="badge badge-success">Hoạt động</span>
                                </c:if>
                                <c:if test="${not user.active}">
                                    <span class="badge badge-secondary">Vô hiệu hóa</span>
                                </c:if>
                            </td>
                            <td class="text-center action-buttons">
                                <a href="${pageContext.request.contextPath}/admin/users/edit?id=<c:out value='${user.userId}' />" class="btn btn-sm btn-primary" title="Sửa">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                                        <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                        <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5z"/>
                                    </svg>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/users/toggle_status?id=<c:out value='${user.userId}' />"
                                   class="btn btn-sm ${user.active ? 'btn-warning' : 'btn-secondary'}"
                                   title="${user.active ? 'Vô hiệu hóa' : 'Kích hoạt'}"
                                   onclick="return confirm('Bạn có chắc chắn muốn ${user.active ? 'vô hiệu hóa' : 'kích hoạt'} tài khoản này không?')">
                                    <c:if test="${user.active}">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-lock-fill" viewBox="0 0 16 16">
                                            <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2m3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2"/>
                                        </svg>
                                    </c:if>
                                    <c:if test="${not user.active}">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-unlock-fill" viewBox="0 0 16 16">
                                            <path d="M11 1a2 2 0 0 0-2 2v4a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h5V3a3 3 0 0 1 6 0v4a.5.5 0 0 1-1 0V3a2 2 0 0 0-2-2"/>
                                        </svg>
                                    </c:if>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listUser}">
                        <tr>
                            <td colspan="7" class="text-center">Không có người dùng nào.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="_footer_admin.jsp" />
</body>
</html>