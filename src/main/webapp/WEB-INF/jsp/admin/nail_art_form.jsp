<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>
    <c:if test="${nailArt != null && nailArt.nailArtId != 0}">Sửa Mẫu Nail Art</c:if>
    <c:if test="${nailArt == null || nailArt.nailArtId == 0}">Thêm Mẫu Nail Art Mới</c:if>
    - Admin Panel
  </title>
  <jsp:include page="_header_admin.jsp" />
</head>
<body>
<div class="container-fluid admin-container">
  <c:set var="formTitle">
    <c:if test="${nailArt != null && nailArt.nailArtId != 0}">Sửa Thông Tin Mẫu Nail Art (ID: ${nailArt.nailArtId})</c:if>
    <c:if test="${nailArt == null || nailArt.nailArtId == 0}">Thêm Mẫu Nail Art Mới</c:if>
  </c:set>
  <h2 class="admin-page-title">${formTitle}</h2>

  <div class="row">
    <div class="col-lg-8 offset-lg-2 col-md-10 offset-md-1">
      <div class="card admin-form">
        <div class="card-body">
          <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <c:out value="${requestScope.errorMessage}"/>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
            </div>
          </c:if>

          <form action="${pageContext.request.contextPath}/admin/nail-arts/${(nailArt != null && nailArt.nailArtId != 0) ? 'update' : 'insert'}" method="post" enctype="multipart/form-data">
            <c:if test="${nailArt != null && nailArt.nailArtId != 0}">
              <input type="hidden" name="nailArtId" value="<c:out value='${nailArt.nailArtId}' />" />
              <input type="hidden" name="existingImageUrl" value="<c:out value='${nailArt.imageUrl}' />" />
            </c:if>

            <div class="form-group">
              <label for="nailArtName">Tên Mẫu Nail (*):</label>
              <input type="text" class="form-control" id="nailArtName" name="nailArtName" value="<c:out value='${nailArt.nailArtName}' />" required>
            </div>

            <div class="form-group">
              <label for="description">Mô Tả:</label>
              <textarea class="form-control" id="description" name="description" rows="3"><c:out value='${nailArt.description}' /></textarea>
            </div>

            <div class="form-row">
              <div class="form-group col-md-6">
                <label for="priceAddon">Giá Thêm (VNĐ) (*):</label>
                <input type="number" step="1000" class="form-control" id="priceAddon" name="priceAddon" value="${nailArt != null ? nailArt.priceAddon : 0}" required min="0">
              </div>
              <div class="form-group col-md-6">
                <label for="collectionId">Bộ Sưu Tập (tùy chọn):</label>
                <select class="custom-select" id="collectionId" name="collectionId">
                  <option value="0">-- Không thuộc bộ sưu tập nào --</option>
                  <c:forEach var="collection" items="${listCollection}"> <%-- listCollection cần được set từ Servlet --%>
                    <option value="${collection.collectionId}" ${nailArt.collectionId == collection.collectionId ? 'selected' : ''}>
                      <c:out value="${collection.collectionName}" />
                    </option>
                  </c:forEach>
                </select>
              </div>
            </div>

            <div class="form-group">
              <label for="imageFile">Hình Ảnh Đại Diện ${nailArt != null && nailArt.nailArtId != 0 ? '(Chọn file mới để thay thế)' : ''}:</label>
              <input type="file" class="form-control-file" id="imageFile" name="imageFile" accept="image/*">
              <c:if test="${nailArt != null && not empty nailArt.imageUrl}">
                <small class="form-text text-muted mt-2">Ảnh hiện tại:
                  <img src="${pageContext.request.contextPath}/${nailArt.imageUrl}" alt="Ảnh mẫu nail" style="max-width: 100px; max-height: 100px; border:1px solid #ddd; padding:2px;"/>
                </small>
              </c:if>
            </div>

            <div class="form-group form-check">
              <input type="checkbox" class="form-check-input" id="isActive" name="isActive" <c:if test="${nailArt == null || nailArt.active}">checked</c:if>>
              <label class="form-check-label" for="isActive">Đang hoạt động</label>
            </div>
            <hr>
            <div class="text-right">
              <button type="submit" class="btn btn-primary">Lưu Mẫu Nail</button>
              <a href="${pageContext.request.contextPath}/admin/nail-arts/list" class="btn btn-secondary">Hủy</a>
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