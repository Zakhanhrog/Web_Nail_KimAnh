<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng Ký Tài Khoản - Tiệm Nail XYZ</title>
  <jsp:include page="_header_customer.jsp" />
  <%-- Sử dụng lại style của auth-container, auth-card từ login.jsp nếu phù hợp --%>
  <style>
    .auth-container {
      min-height: 75vh; /* Tăng chiều cao để form không quá sát footer */
      display: flex;
      align-items: center;
      justify-content: center;
      padding-top: 30px;
      padding-bottom: 30px;
    }
    .auth-card {
      width: 100%;
      max-width: 480px; /* Rộng hơn chút cho form đăng ký */
      padding: 30px 35px;
      background-color: var(--white-pure);
      border-radius: var(--border-radius-medium);
      box-shadow: var(--shadow-strong);
    }
    .auth-card h2 {
      font-family: var(--font-heading);
      color: var(--text-darkest);
      margin-bottom: 25px;
      font-size: 2rem;
    }
    .auth-card .form-control {
      border-radius: var(--border-radius-small);
      padding: 12px 15px;
      font-size: 0.95rem;
      border: 1px solid var(--border-soft);
    }
    .auth-card .form-control:focus {
      border-color: var(--secondary-pink);
      box-shadow: 0 0 0 0.2rem rgba(248, 175, 166, 0.3); /* Màu hồng nhạt cho focus */
    }
    .auth-card .btn-submit {
      background-color: var(--accent-pink);
      border-color: var(--accent-pink);
      color: var(--white-pure);
      font-weight: 600;
      padding: 12px;
      font-size: 1rem;
      border-radius: var(--border-radius-small);
      transition: var(--transition-fast);
    }
    .auth-card .btn-submit:hover {
      background-color: var(--secondary-pink);
      border-color: var(--secondary-pink);
      transform: translateY(-2px);
    }
    .auth-card .extra-links p {
      font-size: 0.9rem;
      color: var(--text-medium-gray);
      margin-top: 1rem;
    }
    .auth-card .form-group label {
      font-weight: 500;
      color: var(--text-dark-gray);
    }
  </style>
</head>
<body>
<div class="customer-page-container auth-container">
  <div class="auth-card animated-fadeInUpSlight">
    <h2 class="text-center">Tạo Tài Khoản Mới</h2>
    <c:if test="${not empty errorMessage}">
      <div class="alert alert-danger" role="alert">
        <c:out value="${errorMessage}"/>
      </div>
    </c:if>
    <form action="${pageContext.request.contextPath}/register" method="post">
      <div class="form-group">
        <label for="fullName">Họ và Tên (*):</label>
        <input type="text" class="form-control" id="fullName" name="fullName" value="<c:out value='${fullName}'/>" required placeholder="Nhập họ tên đầy đủ">
      </div>
      <div class="form-group">
        <label for="email">Địa chỉ Email (*):</label>
        <input type="email" class="form-control" id="email" name="email" value="<c:out value='${email}'/>" required placeholder="vidu@email.com">
      </div>
      <div class="form-group">
        <label for="phoneNumber">Số Điện Thoại (tùy chọn):</label>
        <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="<c:out value='${phoneNumber}'/>" placeholder="09xxxxxxxx">
      </div>
      <div class="form-row">
        <div class="form-group col-md-6">
          <label for="password">Mật Khẩu (*):</label>
          <input type="password" class="form-control" id="password" name="password" required placeholder="Ít nhất 6 ký tự">
        </div>
        <div class="form-group col-md-6">
          <label for="confirmPassword">Xác Nhận Mật Khẩu (*):</label>
          <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required placeholder="Nhập lại mật khẩu">
        </div>
      </div>
      <button type="submit" class="btn btn-submit btn-block mt-3">Đăng Ký</button>
      <div class="text-center mt-3 extra-links">
        <p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a></p>
      </div>
    </form>
  </div>
</div>
<jsp:include page="_footer_customer.jsp" />
</body>
</html>