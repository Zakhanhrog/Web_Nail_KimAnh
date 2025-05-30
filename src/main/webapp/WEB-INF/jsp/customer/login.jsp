<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng Nhập - Tiệm Nail XYZ</title>
  <jsp:include page="_header_customer.jsp" />
  <style>
    .auth-container {
      min-height: 70vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .auth-card {
      width: 100%;
      max-width: 420px;
      padding: 35px;
      background-color: var(--white-pure);
      border-radius: var(--border-radius-medium);
      box-shadow: var(--shadow-strong);
    }
    .auth-card h2 {
      font-family: var(--font-heading);
      color: var(--text-darkest);
      margin-bottom: 25px;
    }
    .auth-card .form-control {
      border-radius: var(--border-radius-small);
      padding: 12px 15px;
      font-size: 0.95rem;
    }
    .auth-card .btn-submit {
      background-color: var(--accent-pink);
      border-color: var(--accent-pink);
      color: var(--white-pure);
      font-weight: 600;
      padding: 12px;
      font-size: 1rem;
      border-radius: var(--border-radius-small);
    }
    .auth-card .btn-submit:hover {
      background-color: var(--secondary-pink);
      border-color: var(--secondary-pink);
    }
    .auth-card .extra-links p {
      font-size: 0.9rem;
      color: var(--text-medium-gray);
    }
  </style>
</head>
<body>
<div class="customer-page-container auth-container">
  <div class="auth-card animated-fadeInUpSlight">
    <h2 class="text-center">Đăng Nhập</h2>
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
        <label for="email" class="font-weight-bold">Email:</label>
        <input type="email" class="form-control" id="email" name="email" value="<c:out value='${email}'/>" required placeholder="Nhập địa chỉ email của bạn">
      </div>
      <div class="form-group">
        <label for="password" class="font-weight-bold">Mật Khẩu:</label>
        <input type="password" class="form-control" id="password" name="password" required placeholder="Nhập mật khẩu">
      </div>
      <button type="submit" class="btn btn-submit btn-block">Đăng Nhập</button>
      <div class="text-center mt-4 extra-links">
        <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
        <p><a href="${pageContext.request.contextPath}/">Quay lại trang chủ</a></p>
      </div>
    </form>
  </div>
</div>
<jsp:include page="_footer_customer.jsp" />
</body>
</html>