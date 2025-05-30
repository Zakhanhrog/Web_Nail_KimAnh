<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Quản Lý Dịch Vụ - Admin Panel</title>
  <jsp:include page="_header_admin.jsp" />
  <style>
    .service-img-thumbnail { max-width: 80px; max-height: 80px; object-fit: cover; border:1px solid #ddd; padding:2px; border-radius: .25rem; }
  </style>
</head>
<body>
<div class="container-fluid admin-container">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="admin-page-title mb-0">Danh Sách Dịch Vụ</h2>
    <div>
      <a href="${pageContext.request.contextPath}/admin/services/new" class="btn btn-success">Thêm Dịch Vụ Mới</a>
    </div>
  </div>

  <c:if test="${not empty sessionScope.successMessage_service}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <c:out value="${sessionScope.successMessage_service}"/>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
    </div>
    <c:remove var="successMessage_service" scope="session"/>
  </c:if>

  <div class="card admin-form">
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover table-striped mb-0">
          <thead class="thead-dark">
          <tr>
            <th>ID</th>
            <th>Ảnh</th>
            <th>Tên Dịch Vụ</th>
            <th>Giá</th>
            <th>Thời Lượng (phút)</th>
            <th>Phân Loại</th>
            <th>Trạng Thái</th>
            <th class="text-center">Hành Động</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="service" items="${listService}">
            <tr>
              <td><c:out value="${service.serviceId}" /></td>
              <td>
                <c:if test="${not empty service.imageUrl}">
                  <img src="${pageContext.request.contextPath}/${service.imageUrl}" alt="<c:out value='${service.serviceName}'/>" class="service-img-thumbnail">
                </c:if>
                <c:if test="${empty service.imageUrl}">
                  <span>N/A</span>
                </c:if>
              </td>
              <td><c:out value="${service.serviceName}" /></td>
              <td><fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></td>
              <td><c:out value="${service.durationMinutes}" /></td>
              <td><c:out value="${service.category}" default="-"/></td>
              <td>
                <c:if test="${service.active}"><span class="badge badge-success">Hoạt động</span></c:if>
                <c:if test="${not service.active}"><span class="badge badge-danger">Không hoạt động</span></c:if>
              </td>
              <td class="text-center action-buttons">
                <a href="${pageContext.request.contextPath}/admin/services/edit?id=<c:out value='${service.serviceId}' />" class="btn btn-sm btn-primary" title="Sửa">Sửa</a>
                <a href="${pageContext.request.contextPath}/admin/services/delete?id=<c:out value='${service.serviceId}' />" class="btn btn-sm btn-danger" title="Xóa (Vô hiệu hóa)"
                   onclick="return confirm('Bạn có chắc chắn muốn ${service.active ? 'vô hiệu hóa' : 'kích hoạt lại'} dịch vụ này không?')">
                    ${service.active ? "Vô hiệu hóa" : "Kích hoạt"}
                </a>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty listService}">
            <tr>
              <td colspan="8" class="text-center">Không có dịch vụ nào.</td>
            </tr>
          </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<jsp:include page="_footer_admin.jsp" />
</body>
</html>