<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>Admin Dashboard</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-3">
  <h1>Chào mừng Admin, <c:out value="${sessionScope.loggedInUser.fullName}"/>!</h1>
  <p>Đây là trang quản trị.</p>
  <p><a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Đăng xuất</a></p>

  <h3>Menu Quản Lý:</h3>
  <ul>
    <li><a href="${pageContext.request.contextPath}/admin/users/list">Quản lý Người Dùng</a></li>
    <li><a href="${pageContext.request.contextPath}/admin/services/list">Quản lý Dịch Vụ</a></li>
    <li><a href="${pageContext.request.contextPath}/admin/nail-collections/list">Quản lý Bộ Sưu Tập Nail</a></li>
    <li><a href="${pageContext.request.contextPath}/admin/nail-arts/list">Quản lý Mẫu Nail</a></li>
    <li><a href="${pageContext.request.contextPath}/admin/staff-schedules/list">Quản lý Lịch Nhân Viên</a></li>
    <li><a href="${pageContext.request.contextPath}/admin/appointments/list">Quản lý Lịch Hẹn</a></li>
    <li><a href="${pageContext.request.contextPath}/admin/expenses/list">Quản lý Chi Phí</a></li>
  </ul>
</div>
</body>
</html>