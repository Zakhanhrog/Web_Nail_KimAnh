<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Quản Lý Dịch Vụ</title>
  <!-- Link Bootstrap CSS -->
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
      <h2>Danh Sách Dịch Vụ</h2>
    </div>
    <div class="col-md-6 text-right">
      <a href="${pageContext.request.contextPath}/admin/services/new" class="btn btn-success">Thêm Dịch Vụ Mới</a>
    </div>
  </div>

  <table class="table table-bordered table-hover">
    <thead class="thead-dark">
    <tr>
      <th>ID</th>
      <th>Tên Dịch Vụ</th>
      <th>Giá</th>
      <th>Thời Lượng (phút)</th>
      <th>Phân Loại</th>
      <th>Trạng Thái</th>
      <th>Hành Động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="service" items="${listService}">
      <tr>
        <td><c:out value="${service.serviceId}" /></td>
        <td><c:out value="${service.serviceName}" /></td>
        <td><fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></td>
        <td><c:out value="${service.durationMinutes}" /></td>
        <td><c:out value="${service.category}" /></td>
        <td>
          <c:if test="${service.active}">
            <span class="badge badge-success">Hoạt động</span>
          </c:if>
          <c:if test="${not service.active}">
            <span class="badge badge-danger">Không hoạt động</span>
          </c:if>
        </td>
        <td class="action-links">
          <a href="${pageContext.request.contextPath}/admin/services/edit?id=<c:out value='${service.serviceId}' />" class="btn btn-sm btn-primary">Sửa</a>
          <a href="${pageContext.request.contextPath}/admin/services/delete?id=<c:out value='${service.serviceId}' />" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa dịch vụ này không?')">Xóa</a>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty listService}">
      <tr>
        <td colspan="7" class="text-center">Không có dịch vụ nào.</td>
      </tr>
    </c:if>
    </tbody>
  </table>
</div>

<!-- Link Bootstrap JS and dependencies (optional, for certain components) -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>