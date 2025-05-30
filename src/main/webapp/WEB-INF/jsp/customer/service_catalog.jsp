<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Dịch Vụ - Tiệm Nail XYZ</title>
    <%-- Link Google Fonts và Bootstrap đã có trong _header_customer.jsp --%>
    <jsp:include page="_header_customer.jsp" />
    <%-- custom-style.css cũng đã được include trong _header_customer.jsp --%>
</head>
<body>
<%-- Navbar đã được include --%>

<div class="container customer-page-container">
    <h1 class="customer-page-title">Dịch Vụ Của Chúng Tôi</h1>
    <p class="customer-page-subtitle">Khám phá các liệu pháp chăm sóc móng và spa được thiết kế riêng để mang lại vẻ đẹp và sự thư thái cho bạn.</p>

    <%-- Filter Form (nếu bạn có) --%>
    <c:if test="${not empty categories}"> <%-- Giả sử bạn có truyền categories từ Servlet --%>
        <div class="row mb-4 justify-content-center">
            <div class="col-md-8">
                <form action="${pageContext.request.contextPath}/services" method="get" class="form-inline filter-form justify-content-center">
                    <label for="category" class="mr-2 my-1">Lọc theo loại:</label>
                    <select name="category" id="category" class="custom-select mr-2 my-1" onchange="this.form.submit()" style="min-width: 200px;">
                        <option value="">Tất cả dịch vụ</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}" ${selectedCategory == cat ? 'selected' : ''}><c:out value="${cat}"/></option>
                        </c:forEach>
                    </select>
                    <c:if test="${not empty selectedCategory}">
                        <a href="${pageContext.request.contextPath}/services" class="btn btn-outline-secondary my-1">Xem tất cả</a>
                    </c:if>
                </form>
            </div>
        </div>
    </c:if>

    <div class="row">
        <c:if test="${empty listService}">
            <div class="col-12">
                <div class="alert alert-info text-center" role="alert">
                    Hiện tại chưa có dịch vụ nào trong mục này. Vui lòng quay lại sau!
                </div>
            </div>
        </c:if>

        <c:forEach var="service" items="${listService}">
            <div class="col-lg-4 col-md-6 animated-fadeIn">
                <div class="card catalog-card">
                    <a href="${pageContext.request.contextPath}/customer/book-appointment?serviceId=${service.serviceId}">
                        <c:choose>
                            <c:when test="${not empty service.imageUrl}"><img class="card-img-top" src="${pageContext.request.contextPath}/${service.imageUrl}" alt="<c:out value='${service.serviceName}'/>"></c:when>
                            <c:otherwise><img class="card-img-top" src="https://via.placeholder.com/400x280?text=${service.serviceName}" alt="Dịch vụ"></c:otherwise>
                        </c:choose>
                    </a>
                    <div class="card-body">
                        <h5 class="card-title">
                            <a href="${pageContext.request.contextPath}/customer/book-appointment?serviceId=${service.serviceId}"><c:out value="${service.serviceName}"/></a>
                        </h5>
                        <p class="service-price"><fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></p>
                        <p class="service-duration">Thời lượng: <c:out value="${service.durationMinutes}"/> phút</p>
                            <%-- <p class="card-text"><c:out value="${service.description}"/></p> --%> <%-- Có thể ẩn bớt mô tả dài --%>
                    </div>
                    <div class="card-footer text-center">
                        <a href="${pageContext.request.contextPath}/customer/book-appointment?serviceId=${service.serviceId}" class="btn btn-book-now">Đặt Lịch Ngay</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="_footer_customer.jsp" />
<%-- Script Bootstrap đã có trong _footer_customer.jsp hoặc _header_customer.jsp --%>
</body>
</html>