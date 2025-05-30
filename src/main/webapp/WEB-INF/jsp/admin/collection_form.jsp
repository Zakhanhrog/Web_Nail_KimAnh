<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>
    <c:if test="${collection != null}">Sửa Bộ Sưu Tập</c:if>
    <c:if test="${collection == null}">Thêm Bộ Sưu Tập Mới</c:if>
  </title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
  <div class="card">
    <div class="card-header">
      <h3>
        <c:if test="${collection != null}">Sửa Thông Tin Bộ Sưu Tập</c:if>
        <c:if test="${collection == null}">Thêm Bộ Sưu Tập Mới</c:if>
      </h3>
    </div>
    <div class="card-body">
      <form action="${pageContext.request.contextPath}/admin/nail-collections/${collection != null ? 'update' : 'insert'}" method="post">
        <c:if test="${collection != null}">
          <input type="hidden" name="collectionId" value="<c:out value='${collection.collectionId}' />" />
        </c:if>

        <div class="form-group">
          <label for="collectionName">Tên Bộ Sưu Tập:</label>
          <input type="text" class="form-control" id="collectionName" name="collectionName" value="<c:out value='${collection.collectionName}' />" required>
        </div>

        <div class="form-group">
          <label for="description">Mô Tả:</label>
          <textarea class="form-control" id="description" name="description" rows="3"><c:out value='${collection.description}' /></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Lưu Bộ Sưu Tập</button>
        <a href="${pageContext.request.contextPath}/admin/nail-collections/list" class="btn btn-secondary">Hủy</a>
      </form>
    </div>
  </div>
</div>
</body>
</html>