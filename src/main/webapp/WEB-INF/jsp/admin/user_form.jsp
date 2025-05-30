<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        <c:if test="${user != null && user.userId != 0}">Sửa Thông Tin Người Dùng</c:if>
        <c:if test="${user == null || user.userId == 0}">Thêm Người Dùng Mới</c:if>
    </title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="card">
        <div class="card-header">
            <h3>
                <c:if test="${user != null && user.userId != 0}">Sửa Thông Tin Người Dùng</c:if>
                <c:if test="${user == null || user.userId == 0}">Thêm Người Dùng Mới</c:if>
            </h3>
        </div>
        <div class="card-body">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    <c:out value="${errorMessage}"/>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/users/${(user != null && user.userId != 0) ? 'update' : 'insert'}" method="post">
                <c:if test="${user != null && user.userId != 0}">
                    <input type="hidden" name="userId" value="<c:out value='${user.userId}' />" />
                </c:if>

                <div class="form-group">
                    <label for="fullName">Họ Tên (*):</label>
                    <input type="text" class="form-control" id="fullName" name="fullName" value="<c:out value='${user.fullName}' />" required>
                </div>

                <div class="form-group">
                    <label for="email">Email (*):</label>
                    <input type="email" class="form-control" id="email" name="email" value="<c:out value='${user.email}' />" required>
                </div>

                <div class="form-group">
                    <label for="password">Mật Khẩu ${ (user != null && user.userId != 0) ? '(Để trống nếu không đổi)' : '(*)'}:</label>
                    <input type="password" class="form-control" id="password" name="password" ${ (user == null || user.userId == 0) ? 'required' : ''}>
                </div>

                <div class="form-group">
                    <label for="phoneNumber">Số Điện Thoại:</label>
                    <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="<c:out value='${user.phoneNumber}' />">
                </div>

                <div class="form-group">
                    <label for="role">Vai Trò (*):</label>
                    <select class="form-control" id="role" name="role" required>
                        <option value="">-- Chọn vai trò --</option>
                        <option value="customer" ${user.role == 'customer' ? 'selected' : ''}>Khách hàng</option>
                        <option value="staff" ${user.role == 'staff' ? 'selected' : ''}>Nhân viên</option>
                        <option value="cashier" ${user.role == 'cashier' ? 'selected' : ''}>Thu ngân</option>
                        <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>Admin</option>
                    </select>
                </div>

                <div class="form-group form-check">
                    <input type="checkbox" class="form-check-input" id="isActive" name="isActive" <c:if test="${user == null || user.userId == 0 || user.active}">checked</c:if>>
                    <label class="form-check-label" for="isActive">Đang hoạt động</label>
                </div>

                <button type="submit" class="btn btn-primary">Lưu Người Dùng</button>
                <a href="${pageContext.request.contextPath}/admin/users/list" class="btn btn-secondary">Hủy</a>
            </form>
        </div>
    </div>
</div>
</body>
</html>