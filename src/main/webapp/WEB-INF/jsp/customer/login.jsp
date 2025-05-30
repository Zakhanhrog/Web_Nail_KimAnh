<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Đăng Nhập - Tiệm Nail</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f8f9fa; }
    .login-container { max-width: 400px; margin: 50px auto; padding: 30px; background-color: #fff; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
  </style>
</head>
<body>
<div class="login-container">
  <h2 class="text-center mb-4">Đăng Nhập</h2>
  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger" role="alert">
      <c:out value="${errorMessage}"/>
    </div>
  </c:if>
  <c:if test="${not empty successMessage}">
    <div class="alert alert-success" role="alert">
      <c:out value="${successMessage}"/>
    </div>
  </c:if>
  <form action="${pageContext.request.contextPath}/login" method="post">
    <div class="form-group">
      <label for="email">Email:</label>
      <input type="email" class="form-control" id="email" name="email" value="<c:out value='${email}'/>" required>
    </div>
    <div class="form-group">
      <label for="password">Mật Khẩu:</label>
      <input type="password" class="form-control" id="password" name="password" required>
    </div>
    <button type="submit" class="btn btn-primary btn-block">Đăng Nhập</button>
    <div class="text-center mt-3">
      <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
      <p><a href="${pageContext.request.contextPath}/">Quay lại trang chủ</a></p>
    </div>
  </form>
</div>
</body>
</html>