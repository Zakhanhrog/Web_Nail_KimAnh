<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <jsp:include page="_header_customer.jsp">
    <jsp:param name="pageTitle" value="Chỉnh Sửa Hồ Sơ - Tiệm Nail XYZ"/>
  </jsp:include>
  <style>
    .profile-edit-card { background-color: var(--white-pure); border-radius: var(--border-radius-medium); box-shadow: var(--shadow-medium); padding: 30px;}
    .profile-edit-card h4 { color: var(--accent-pink); margin-top: 1.5rem; margin-bottom: 1rem; font-family: var(--font-heading);}
    .profile-edit-card .form-group label { font-weight: 500; color: var(--text-dark-gray); }
    .profile-edit-card .form-control { border-radius: var(--border-radius-small); }
  </style>
</head>
<body>
<div class="customer-page-container">
  <h1 class="customer-page-title">Chỉnh Sửa Hồ Sơ</h1>

  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="profile-edit-card animated-fadeInUpSlight">
        <c:if test="${not empty errorMessage}">
          <div class="alert alert-danger"><c:out value="${errorMessage}"/></div>
        </c:if>
        <c:if test="${not empty passwordErrorMessage}">
          <div class="alert alert-danger"><c:out value="${passwordErrorMessage}"/></div>
        </c:if>

        <h4>Thông Tin Cá Nhân</h4>
        <form action="${pageContext.request.contextPath}/customer/profile/update" method="post">
          <input type="hidden" name="userId" value="${userProfile.userId}"> <%-- userId từ userProfile (loggedInUser) --%>
          <div class="form-group">
            <label for="fullName">Họ Tên (*):</label>
            <input type="text" class="form-control" id="fullName" name="fullName" value="<c:out value='${userProfile.fullName}'/>" required>
          </div>
          <div class="form-group">
            <label for="email">Email (Không thể thay đổi):</label>
            <input type="email" class="form-control" id="email" name="email" value="<c:out value='${userProfile.email}'/>" readonly>
          </div>
          <div class="form-group">
            <label for="phoneNumber">Số Điện Thoại:</label>
            <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="<c:out value='${userProfile.phoneNumber}'/>">
          </div>
          <button type="submit" class="btn btn-primary-custom-filled">Lưu Thay Đổi Thông Tin</button>
          <a href="${pageContext.request.contextPath}/customer/profile/view" class="btn btn-outline-secondary ml-2">Hủy</a>
        </form>

        <hr class="my-5">

        <h4>Đổi Mật Khẩu</h4>
        <form action="${pageContext.request.contextPath}/customer/profile/change-password" method="post">
          <input type="hidden" name="userId" value="${userProfile.userId}">
          <div class="form-group">
            <label for="newPassword">Mật Khẩu Mới (*):</label>
            <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="6">
            <small class="form-text text-muted">Ít nhất 6 ký tự.</small>
          </div>
          <div class="form-group">
            <label for="confirmNewPassword">Xác Nhận Mật Khẩu Mới (*):</label>
            <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required>
          </div>
          <button type="submit" class="btn btn-warning">Đổi Mật Khẩu</button>
        </form>
      </div>
    </div>
  </div>
</div>
<jsp:include page="_footer_customer.jsp" />
</body>
</html>