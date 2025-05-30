<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo Khách Hàng Trung Thành</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="_header_admin.jsp" />
<div class="container mt-4">
    <h2>Báo Cáo Khách Hàng Trung Thành</h2>
    <hr/>
    <form method="get" action="${pageContext.request.contextPath}/admin/reports/loyal-customers" class="form-inline mb-4">
        <div class="form-group mr-2">
            <label for="orderBy" class="mr-2">Sắp xếp theo:</label>
            <select name="orderBy" id="orderBy" class="form-control">
                <option value="total_visits" ${currentOrderBy == 'total_visits' ? 'selected' : ''}>Số Lần Đến Nhiều Nhất</option>
                <option value="total_spent" ${currentOrderBy == 'total_spent' ? 'selected' : ''}>Chi Tiêu Nhiều Nhất</option>
            </select>
        </div>
        <div class="form-group mr-2">
            <label for="limit" class="mr-2">Hiển thị Top:</label>
            <input type="number" name="limit" id="limit" class="form-control" value="${currentLimit}" min="1" max="100" style="width: 80px;">
        </div>
        <button type="submit" class="btn btn-primary">Xem Báo Cáo</button>
    </form>

    <c:if test="${not empty reportError}">
        <div class="alert alert-danger"><c:out value="${reportError}"/></div>
    </c:if>

    <c:if test="${empty reportError}">
        <c:choose>
            <c:when test="${not empty loyalCustomersList}">
                <table class="table table-striped table-hover">
                    <thead class="thead-dark">
                    <tr>
                        <th>ID Khách Hàng</th>
                        <th>Tên Khách Hàng</th>
                        <th>Email</th>
                        <th>Số Điện Thoại</th>
                        <th>Tổng Số Lần Đến</th>
                        <th>Tổng Chi Tiêu</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="customer" items="${loyalCustomersList}">
                        <tr>
                            <td><c:out value="${customer.customerId}"/></td>
                            <td><c:out value="${customer.customerName}"/></td>
                            <td><c:out value="${customer.customerEmail}"/></td>
                            <td><c:out value="${customer.customerPhone}"/></td>
                            <td><c:out value="${customer.totalVisits}"/></td>
                            <td><fmt:formatNumber value="${customer.totalSpent}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info">Không có dữ liệu khách hàng.</div>
            </c:otherwise>
        </c:choose>
    </c:if>
</div>
<jsp:include page="_footer_admin.jsp" />
</body>
</html>