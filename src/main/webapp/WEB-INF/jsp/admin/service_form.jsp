<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>
    <c:if test="${service != null}">Sửa Dịch Vụ</c:if>
    <c:if test="${service == null}">Thêm Dịch Vụ Mới</c:if>
  </title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
  <div class="card">
    <div class="card-header">
      <h3>
        <c:if test="${service != null}">Sửa Thông Tin Dịch Vụ</c:if>
        <c:if test="${service == null}">Thêm Dịch Vụ Mới</c:if>
      </h3>
    </div>
    <div class="card-body">
      <form action="${pageContext.request.contextPath}/admin/services/${service != null ? 'update' : 'insert'}" method="post">
        <c:if test="${service != null}">
          <input type="hidden" name="serviceId" value="<c:out value='${service.serviceId}' />" />
        </c:if>

        <div class="form-group">
          <label for="serviceName">Tên Dịch Vụ:</label>
          <input type="text" class="form-control" id="serviceName" name="serviceName" value="<c:out value='${service.serviceName}' />" required>
        </div>

        <div class="form-group">
          <label for="description">Mô Tả:</label>
          <textarea class="form-control" id="description" name="description" rows="3"><c:out value='${service.description}' /></textarea>
        </div>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="price">Giá (VNĐ):</label>
            <input type="number" step="1000" class="form-control" id="price" name="price" value="<c:out value='${service.price}' />" required>
          </div>
          <div class="form-group col-md-6">
            <label for="durationMinutes">Thời Lượng (phút):</label>
            <input type="number" class="form-control" id="durationMinutes" name="durationMinutes" value="<c:out value='${service.durationMinutes}' />" required>
          </div>
        </div>

        <div class="form-group">
          <label for="category">Phân Loại:</label>
          <input type="text" class="form-control" id="category" name="category" value="<c:out value='${service.category}' />" placeholder="Ví dụ: Nail, Spa, Skincare">
        </div>

        <div class="form-group">
          <label for="imageUrl">URL Hình Ảnh (tùy chọn):</label>
          <input type="url" class="form-control" id="imageUrl" name="imageUrl" value="<c:out value='${service.imageUrl}' />">
        </div>

        <div class="form-group form-check">
          <input type="checkbox" class="form-check-input" id="isActive" name="isActive" <c:if test="${service == null || service.active}">checked</c:if>>
          <label class="form-check-label" for="isActive">Đang hoạt động</label>
        </div>

        <button type="submit" class="btn btn-primary">Lưu Dịch Vụ</button>
        <a href="${pageContext.request.contextPath}/admin/services/list" class="btn btn-secondary">Hủy</a>
      </form>
    </div>
  </div>
</div>
</body>
</html>