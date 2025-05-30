<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>
    <c:if test="${nailArt != null}">Sửa Mẫu Nail Art</c:if>
    <c:if test="${nailArt == null}">Thêm Mẫu Nail Art Mới</c:if>
  </title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
  <div class="card">
    <div class="card-header">
      <h3>
        <c:if test="${nailArt != null}">Sửa Thông Tin Mẫu Nail Art</c:if>
        <c:if test="${nailArt == null}">Thêm Mẫu Nail Art Mới</c:if>
      </h3>
    </div>
    <div class="card-body">
      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" role="alert">
          <c:out value="${errorMessage}"/>
        </div>
      </c:if>
      <form action="${pageContext.request.contextPath}/admin/nail-arts/${nailArt != null ? 'update' : 'insert'}" method="post" enctype="multipart/form-data">
        <c:if test="${nailArt != null}">
          <input type="hidden" name="nailArtId" value="<c:out value='${nailArt.nailArtId}' />" />
          <input type="hidden" name="existingImageUrl" value="<c:out value='${nailArt.imageUrl}' />" />
        </c:if>

        <div class="form-group">
          <label for="nailArtName">Tên Mẫu Nail:</label>
          <input type="text" class="form-control" id="nailArtName" name="nailArtName" value="<c:out value='${nailArt.nailArtName}' />" required>
        </div>

        <div class="form-group">
          <label for="description">Mô Tả:</label>
          <textarea class="form-control" id="description" name="description" rows="3"><c:out value='${nailArt.description}' /></textarea>
        </div>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="priceAddon">Giá Thêm (VNĐ):</label>
            <input type="number" step="1000" class="form-control" id="priceAddon" name="priceAddon" value="${nailArt != null ? nailArt.priceAddon : 0}" required>
          </div>
          <div class="form-group col-md-6">
            <label for="collectionId">Bộ Sưu Tập (tùy chọn):</label>
            <select class="form-control" id="collectionId" name="collectionId">
              <option value="0">-- Không thuộc bộ sưu tập nào --</option>
              <c:forEach var="collection" items="${listCollection}">
                <option value="${collection.collectionId}" ${nailArt.collectionId == collection.collectionId ? 'selected' : ''}>
                  <c:out value="${collection.collectionName}" />
                </option>
              </c:forEach>
            </select>
          </div>
        </div>

        <div class="form-group">
          <label for="imageFile">Hình Ảnh Đại Diện ${nailArt != null ? '(Chọn file mới để thay thế)' : ''}:</label>
          <input type="file" class="form-control-file" id="imageFile" name="imageFile" accept="image/*">
          <c:if test="${nailArt != null && not empty nailArt.imageUrl}">
            <small class="form-text text-muted">Ảnh hiện tại: <img src="${pageContext.request.contextPath}/${nailArt.imageUrl}" alt="Current Image" style="max-width: 100px; max-height: 100px; margin-top: 5px;"/></small>
          </c:if>
        </div>

        <div class="form-group form-check">
          <input type="checkbox" class="form-check-input" id="isActive" name="isActive" <c:if test="${nailArt == null || nailArt.active}">checked</c:if>>
          <label class="form-check-label" for="isActive">Đang hoạt động</label>
        </div>

        <button type="submit" class="btn btn-primary">Lưu Mẫu Nail</button>
        <a href="${pageContext.request.contextPath}/admin/nail-arts/list" class="btn btn-secondary">Hủy</a>
      </form>
    </div>
  </div>
</div>
</body>
</html>