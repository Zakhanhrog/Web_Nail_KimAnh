<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>
    <c:if test="${service != null && service.serviceId != 0}">Sửa Dịch Vụ</c:if>
    <c:if test="${service == null || service.serviceId == 0}">Thêm Dịch Vụ Mới</c:if>
    - Admin Panel
  </title>
  <jsp:include page="_header_admin.jsp" />
</head>
<body>
<div class="container-fluid admin-container">
  <c:set var="formTitle">
    <c:if test="${service != null && service.serviceId != 0}">Sửa Thông Tin Dịch Vụ (ID: ${service.serviceId})</c:if>
    <c:if test="${service == null || service.serviceId == 0}">Thêm Dịch Vụ Mới</c:if>
  </c:set>
  <h2 class="admin-page-title">${formTitle}</h2>

  <div class="row">
    <div class="col-lg-8 offset-lg-2 col-md-10 offset-md-1">
      <div class="card admin-form">
        <div class="card-body">
          <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <c:out value="${requestScope.errorMessage}"/>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">×</span>
              </button>
            </div>
          </c:if>

          <form action="${pageContext.request.contextPath}/admin/services/${(service != null && service.serviceId != 0) ? 'update' : 'insert'}" method="post" enctype="multipart/form-data">
            <c:if test="${service != null && service.serviceId != 0}">
              <input type="hidden" name="serviceId" value="<c:out value='${service.serviceId}' />" />
              <input type="hidden" name="existingImageUrl" value="<c:out value='${service.imageUrl}' />" />
            </c:if>

            <div class="form-group">
              <label for="serviceName">Tên Dịch Vụ (*):</label>
              <input type="text" class="form-control" id="serviceName" name="serviceName" value="<c:out value='${service.serviceName}' />" required>
            </div>

            <div class="form-group">
              <label for="description">Mô Tả:</label>
              <textarea class="form-control" id="description" name="description" rows="3"><c:out value='${service.description}' /></textarea>
            </div>

            <div class="form-row">
              <div class="form-group col-md-6">
                <label for="price">Giá (VNĐ) (*):</label>
                <input type="number" step="1000" class="form-control" id="price" name="price" value="${service.price}" required>
              </div>
              <div class="form-group col-md-6">
                <label for="durationMinutes">Thời Lượng (phút) (*):</label>
                <input type="number" class="form-control" id="durationMinutes" name="durationMinutes" value="${service.durationMinutes}" required min="1">
              </div>
            </div>

            <div class="form-group">
              <label for="category">Phân Loại:</label>
              <input type="text" class="form-control" id="category" name="category" value="<c:out value='${service.category}' />" placeholder="Ví dụ: Nail, Spa, Skincare">
            </div>

            <div class="form-group">
              <label for="imageFile">Hình Ảnh Đại Diện ${service != null && service.serviceId != 0 ? '(Chọn file mới để thay thế)' : ''}:</label>
              <input type="file" class="form-control-file" id="imageFile" name="imageFile" accept="image/*">
              <c:if test="${service != null && not empty service.imageUrl}">
                <small class="form-text text-muted">Ảnh hiện tại:
                  <img src="${pageContext.request.contextPath}/${service.imageUrl}" alt="Ảnh dịch vụ" style="max-width: 100px; max-height: 100px; margin-top: 5px; border:1px solid #ddd; padding:2px;"/>
                </small>
              </c:if>
            </div>

            <div class="form-group form-check">
              <input type="checkbox" class="form-check-input" id="isActive" name="isActive" <c:if test="${service == null || service.active}">checked</c:if>>
              <label class="form-check-label" for="isActive">Đang hoạt động</label>
            </div>
            <hr>
            <div class="text-right">
              <button type="submit" class="btn btn-primary">Lưu Dịch Vụ</button>
              <a href="${pageContext.request.contextPath}/admin/services/list" class="btn btn-secondary">Hủy</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<jsp:include page="_footer_admin.jsp" />
</body>
</html>