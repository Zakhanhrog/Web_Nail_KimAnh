<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Người Dùng</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .table th, .table td { vertical-align: middle; }
        .action-links a { margin-right: 10px; }
    </style>
</head>
<body>
<div class="container mt-4">
    <div class="row mb-3">
        <div class="col-md-6">
            <h2>Danh Sách Người Dùng</h2>
        </div>
        <div class="col-md-6 text-right">
            <a href="${pageContext.request.contextPath}/admin/users/new" class="btn btn-success">Thêm Người Dùng Mới</a>
        </div>
    </div>

    <table class="table table-bordered table-hover">
        <thead class="thead-dark">
        <tr>
            <th>ID</th>
            <th>Họ Tên</th>
            <th>Email</th>
            <th>Điện Thoại</th>
            <th>Vai Trò</th>
            <th>Trạng Thái</th>
            <th>Hành Động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="user" items="${listUser}">
            <tr>
                <td><c:out value="${user.userId}" /></td>
                <td><c:out value="${user.fullName}" /></td>
                <td><c:out value="${user.email}" /></td>
                <td><c:out value="${user.phoneNumber}" /></td>
                <td>
                    <c:choose>
                        <c:when test="${user.role == 'admin'}"><span class="badge badge-danger">Admin</span></c:when>
                        <c:when test="${user.role == 'staff'}"><span class="badge badge-info">Nhân viên</span></c:when>
                        <c:when test="${user.role == 'cashier'}"><span class="badge badge-warning">Thu ngân</span></c:when>
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
                <td class="action-links">
                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=<c:out value='${user.userId}' />" class="btn btn-sm btn-primary">Sửa</a>
                    <a href="${pageContext.request.contextPath}/admin/users/toggle_status?id=<c:out value='${user.userId}' />"
                       class="btn btn-sm ${user.active ? 'btn-warning' : 'btn-success'}"
                       onclick="return confirm('Bạn có chắc chắn muốn ${user.active ? 'vô hiệu hóa' : 'kích hoạt'} tài khoản này không?')">
                            ${user.active ? 'Vô hiệu hóa' : 'Kích hoạt'}
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
</body>
</html>