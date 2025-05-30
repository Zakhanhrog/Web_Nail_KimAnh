<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>
    <c:if test="${collection != null && collection.collectionId != 0}">Sửa Bộ Sưu Tập</c:if>
    <c:if test="${collection == null || collection.collectionId == 0}">Thêm Bộ Sưu Tập Mới</c:if>
    - Admin Panel
  </title>
  <jsp:include page="_header_admin.jsp" />
</head>
<body>
<div class="container-fluid admin-container">
  <c:set var="formTitle">
    <c:if test="${collection != null && collection.collectionId != 0}">Sửa Thông Tin Bộ Sưu Tập (ID: ${collection.collectionId})</c:if>
    <c:if test="${collection == null || collection.collectionId == 0}">Thêm Bộ Sưu Tập Mới</c:if>
  </c:set>
  <h2 class="admin-page-title">${formTitle}</h2>

  <div class="row">
    <div class="col-lg-6 offset-lg-3 col-md-8 offset-md-2">
      <div class="card admin-form">
        <div class="card-body">
          <c:if test="${not empty requestScope.errorMessage_collection}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <c:out value="${requestScope.errorMessage_collection}"/>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
            </div>
          </c:if>

          <form action="${pageContext.request.contextPath}/admin/nail-collections/${(collection != null && collection.collectionId != 0) ? 'update' : 'insert'}" method="post">
            <c:if test="${collection != null && collection.collectionId != 0}">
              <input type="hidden" name="collectionId" value="<c:out value='${collection.collectionId}' />" />
            </c:if>

            <div class="form-group">
              <label for="collectionName">Tên Bộ Sưu Tập (*):</label>
              <input type="text" class="form-control" id="collectionName" name="collectionName" value="<c:out value='${collection.collectionName}' />" required>
            </div>

            <div class="form-group">
              <label for="description">Mô Tả:</label>
              <textarea class="form-control" id="description" name="description" rows="4"><c:out value='${collection.description}' /></textarea>
            </div>
            <hr>
            <div class="text-right">
              <button type="submit" class="btn btn-primary">Lưu Bộ Sưu Tập</button>
              <a href="${pageContext.request.contextPath}/admin/nail-collections/list" class="btn btn-secondary">Hủy</a>
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