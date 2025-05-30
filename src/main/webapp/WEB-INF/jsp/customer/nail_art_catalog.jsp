<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Thư Viện Mẫu Nail - Tiệm Nail</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .nail-art-img-lg {
      width: 100%;
      height: 250px; /* Hoặc một chiều cao cố định bạn muốn */
      object-fit: cover;
    }
    .nail-art-card { margin-bottom: 30px; }
    body { padding-top: 20px; }
  </style>
</head>
<body>
<jsp:include page="_header_customer.jsp" />

<div class="container">
  <h1 class="my-4 text-center">Thư Viện Mẫu Nail</h1>

  <div class="row mb-4">
    <div class="col-md-12">
      <form action="${pageContext.request.contextPath}/nail-arts" method="get" class="form-inline">
        <label for="collectionId" class="mr-2">Lọc theo bộ sưu tập:</label>
        <select name="collectionId" id="collectionId" class="form-control mr-2" onchange="this.form.submit()">
          <option value="0">Tất cả mẫu nail</option>
          <c:forEach var="collection" items="${collections}">
            <option value="${collection.collectionId}" ${selectedCollectionId == collection.collectionId ? 'selected' : ''}>
              <c:out value="${collection.collectionName}"/>
            </option>
          </c:forEach>
        </select>
        <c:if test="${not empty selectedCollectionId && selectedCollectionId != '0'}">
          <a href="${pageContext.request.contextPath}/nail-arts" class="btn btn-outline-secondary">Xem tất cả</a>
        </c:if>
      </form>
    </div>
  </div>

  <div class="row">
    <c:if test="${empty listNailArt}">
      <div class="col-12">
        <p class="text-center">Hiện tại chưa có mẫu nail nào trong mục này.</p>
      </div>
    </c:if>

    <c:forEach var="nailArt" items="${listNailArt}">
      <div class="col-lg-4 col-md-6 nail-art-card">
        <div class="card h-100">
          <c:choose>
            <c:when test="${not empty nailArt.imageUrl}">
              <img class="card-img-top nail-art-img-lg" src="${pageContext.request.contextPath}/${nailArt.imageUrl}" alt="<c:out value='${nailArt.nailArtName}'/>">
            </c:when>
            <c:otherwise>
              <img class="card-img-top nail-art-img-lg" src="https://via.placeholder.com/700x400?text=Sample+Nail" alt="Sample Nail Art">
            </c:otherwise>
          </c:choose>
          <div class="card-body">
            <h5 class="card-title"><c:out value="${nailArt.nailArtName}"/></h5>
            <p class="card-text"><small><c:out value="${nailArt.description}"/></small></p>
            <p><strong>Giá thêm:</strong> <fmt:formatNumber value="${nailArt.priceAddon}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></p>
              <%-- Nút like có thể thêm sau nếu cần --%>
          </div>
            <%--
            <div class="card-footer text-center">
                 Nút chọn mẫu này để đặt lịch (nếu luồng đặt lịch cho phép chọn mẫu trước)
            </div>
            --%>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<jsp:include page="_footer_customer.jsp" />

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>