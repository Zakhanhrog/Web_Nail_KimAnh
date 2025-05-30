<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Admin Dashboard - KimiBeauty</title>
  <jsp:include page="_header_admin.jsp" />
  <style>
    .dashboard-card {
      margin-bottom: 20px;
      box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, .075) !important;
    }
    .dashboard-card .card-body {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 120px;
    }
    .dashboard-card .card-title {
      font-size: 1.1rem;
      font-weight: 500;
      color: #555;
    }
    .dashboard-card .card-text {
      font-size: 2rem;
      font-weight: bold;
      color: #007bff;
    }
    .quick-links .list-group-item {
      font-size: 1rem;
    }
    .quick-links .list-group-item:hover {
      background-color: #f8f9fa;
    }
  </style>
</head>
<body>
<div class="container-fluid admin-container">
  <h2 class="admin-page-title">Bảng Điều Khiển</h2>

  <c:if test="${not empty sessionScope.loggedInUser}">
    <p class="lead">Chào mừng trở lại, <c:out value="${sessionScope.loggedInUser.fullName}"/>!</p>
  </c:if>
  <hr/>

  <%-- Phần này có thể lấy dữ liệu từ Servlet sau này --%>
  <div class="row">
    <div class="col-xl-3 col-md-6">
      <div class="card bg-primary text-white dashboard-card">
        <div class="card-body">
          <div class="card-title">Tổng Lịch Hẹn (Tháng này)</div>
          <div class="card-text">125</div> <%-- Dữ liệu mẫu --%>
        </div>
      </div>
    </div>
    <div class="col-xl-3 col-md-6">
      <div class="card bg-warning text-dark dashboard-card">
        <div class="card-body">
          <div class="card-title">Doanh Thu (Hôm nay)</div>
          <div class="card-text">5.250K</div> <%-- Dữ liệu mẫu --%>
        </div>
      </div>
    </div>
    <div class="col-xl-3 col-md-6">
      <div class="card bg-success text-white dashboard-card">
        <div class="card-body">
          <div class="card-title">Khách Hàng Mới (Tuần này)</div>
          <div class="card-text">15</div> <%-- Dữ liệu mẫu --%>
        </div>
      </div>
    </div>
    <div class="col-xl-3 col-md-6">
      <div class="card bg-danger text-white dashboard-card">
        <div class="card-body">
          <div class="card-title">Đánh Giá Chờ Duyệt</div>
          <div class="card-text">3</div> <%-- Dữ liệu mẫu --%>
        </div>
      </div>
    </div>
  </div>

  <div class="row mt-4">
    <div class="col-md-8">
      <div class="card admin-form">
        <div class="card-header">Lịch hẹn sắp tới</div>
        <div class="card-body">
          <%-- Hiển thị một vài lịch hẹn sắp tới ở đây --%>
          <p class="text-muted">Chức năng hiển thị lịch hẹn sắp tới sẽ được cập nhật sau.</p>
        </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card admin-form quick-links">
        <div class="card-header">Truy Cập Nhanh</div>
        <div class="list-group list-group-flush">
          <a href="${pageContext.request.contextPath}/admin/appointments/list" class="list-group-item list-group-item-action">Quản lý Lịch Hẹn</a>
          <a href="${pageContext.request.contextPath}/admin/users/list" class="list-group-item list-group-item-action">Quản lý Người Dùng</a>
          <a href="${pageContext.request.contextPath}/admin/services/list" class="list-group-item list-group-item-action">Quản lý Dịch Vụ</a>
          <a href="${pageContext.request.contextPath}/admin/reports/revenue" class="list-group-item list-group-item-action">Xem Báo Cáo Doanh Thu</a>
        </div>
      </div>
    </div>
  </div>
</div>
<jsp:include page="_footer_admin.jsp" />
</body>
</html>