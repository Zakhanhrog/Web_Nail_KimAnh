<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh Sách Dịch Vụ - Tiệm Nail</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .card-img-top {
            width: 100%;
            height: 200px; /* Hoặc một chiều cao cố định bạn muốn */
            object-fit: cover; /* Đảm bảo ảnh vừa vặn mà không bị méo */
        }
        .service-card { margin-bottom: 30px; }
        body { padding-top: 20px; /* Để navbar không che mất nội dung nếu có */ }
    </style>
</head>
<body>
<%-- Có thể thêm một file header.jsp chung cho các trang customer --%>
<jsp:include page="_header_customer.jsp" />

<div class="container">
    <h1 class="my-4 text-center">Dịch Vụ Của Chúng Tôi</h1>

    <%-- Filter theo category (Tùy chọn) --%>
    <%--
    <div class="row mb-4">
        <div class="col-md-12">
            <form action="${pageContext.request.contextPath}/services" method="get" class="form-inline">
                <label for="category" class="mr-2">Lọc theo loại dịch vụ:</label>
                <select name="category" id="category" class="form-control mr-2" onchange="this.form.submit()">
                    <option value="">Tất cả dịch vụ</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat}" ${selectedCategory == cat ? 'selected' : ''}><c:out value="${cat}"/></option>
                    </c:forEach>
                </select>
                <c:if test="${not empty selectedCategory}">
                     <a href="${pageContext.request.contextPath}/services" class="btn btn-outline-secondary">Xem tất cả</a>
                </c:if>
            </form>
        </div>
    </div>
    --%>

    <div class="row">
        <c:if test="${empty listService}">
            <div class="col-12">
                <p class="text-center">Hiện tại chưa có dịch vụ nào.</p>
            </div>
        </c:if>

        <c:forEach var="service" items="${listService}">
            <div class="col-lg-4 col-md-6 service-card">
                <div class="card h-100">
                    <a href="#"> <%-- Link đến trang chi tiết dịch vụ (nếu có) --%>
                        <c:choose>
                            <c:when test="${not empty service.imageUrl}">
                                <img class="card-img-top" src="${pageContext.request.contextPath}/${service.imageUrl}" alt="<c:out value='${service.serviceName}'/>">
                            </c:when>
                            <c:otherwise>
                                <img class="card-img-top" src="https://via.placeholder.com/700x400?text=No+Image" alt="No image available">
                            </c:otherwise>
                        </c:choose>
                    </a>
                    <div class="card-body">
                        <h4 class="card-title">
                            <a href="#"><c:out value="${service.serviceName}"/></a>
                        </h4>
                        <h5><fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></h5>
                        <p><strong>Thời lượng:</strong> <c:out value="${service.durationMinutes}"/> phút</p>
                        <p class="card-text"><c:out value="${service.description}"/></p>
                    </div>
                    <div class="card-footer text-center">
                        <a href="${pageContext.request.contextPath}/customer/book-appointment?serviceId=${service.serviceId}" class="btn btn-primary">Đặt Lịch Ngay</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<%-- Có thể thêm một file footer.jsp chung --%>
<jsp:include page="_footer_customer.jsp" />

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>