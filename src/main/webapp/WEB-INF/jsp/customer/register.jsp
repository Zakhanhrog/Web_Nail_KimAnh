<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Đăng Ký - Tiệm Nail</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f8f9fa; }
    .register-container { max-width: 500px; margin: 50px auto; padding: 30px; background-color: #fff; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
  </style>
</head>
<body>
<div class="register-container">
  <h2 class="text-center mb-4">Đăng Ký Tài Khoản</h2>
  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger" role="alert">
      <c:out value="${errorMessage}"/>
    </div>
  </c:if>
  <form action="${pageContext.request.contextPath}/register" method="post">
    <div class="form-group">
      <label for="fullName">Họ Tên (*):</label>
      <input type="text" class="form-control" id="fullName" name="fullName" value="<c:out value='${fullName}'/>" required>
    </div>
    <div class="form-group">
      <label for="email">Email (*):</label>
      <input type="email" class="form-control" id="email" name="email" value="<c:out value='${email}'/>" required>
    </div>
    <div class="form-group">
      <label for="phoneNumber">Số Điện Thoại:</label>
      <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="<c:out value='${phoneNumber}'/>">
    </div>
    <div class="form-group">
      <label for="password">Mật Khẩu (*):</label>
      <input type="password" class="form-control" id="password" name="password" required>
    </div>
    <div class="form-group">
      <label for="confirmPassword">Xác Nhận Mật Khẩu (*):</label>
      <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
    </div>
    <button type="submit" class="btn btn-success btn-block">Đăng Ký</button>
    <div class="text-center mt-3">
      <p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></p>
      <p><a href="${pageContext.request.contextPath}/">Quay lại trang chủ</a></p>
    </div>
  </form>
</div>
</body>
</html>