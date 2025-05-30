<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Báo Cáo Khách Hàng Trung Thành - Admin Panel</title>
    <jsp:include page="_header_admin.jsp" />
</head>
<body>
<div class="container-fluid admin-container">
    <h2 class="admin-page-title">Báo Cáo Khách Hàng Trung Thành</h2>

    <div class="card admin-form mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin/reports/loyal-customers" class="form-inline">
                <div class="form-group mr-3">
                    <label for="orderBy" class="mr-2">Sắp xếp theo:</label>
                    <select name="orderBy" id="orderBy" class="custom-select">
                        <option value="total_visits" ${currentOrderBy == 'total_visits' ? 'selected' : ''}>Số Lần Đến Nhiều Nhất</option>
                        <option value="total_spent" ${currentOrderBy == 'total_spent' ? 'selected' : ''}>Chi Tiêu Nhiều Nhất</option>
                    </select>
                </div>
                <div class="form-group mr-3">
                    <label for="limit" class="mr-2">Hiển thị Top:</label>
                    <input type="number" name="limit" id="limit" class="form-control" value="${currentLimit}" min="1" max="100" style="width: 100px;">
                </div>
                <button type="submit" class="btn btn-primary">Xem Báo Cáo</button>
            </form>
        </div>
    </div>

    <c:if test="${not empty reportError}">
        <div class="alert alert-danger"><c:out value="${reportError}"/></div>
    </c:if>

    <c:if test="${empty reportError}">
        <div class="card admin-form">
            <div class="card-header">
                Kết quả <c:if test="${not empty currentOrderBy}"> (Sắp xếp theo ${currentOrderBy == 'total_visits' ? 'Số lần đến' : 'Tổng chi tiêu'})</c:if>
                <c:if test="${not empty currentLimit}"> - Top ${currentLimit}</c:if>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0">
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
                                <td><c:out value="${customer.customerPhone}" default="-"/></td>
                                <td><c:out value="${customer.totalVisits}"/></td>
                                <td><fmt:formatNumber value="${customer.totalSpent}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty loyalCustomersList}">
                            <tr>
                                <td colspan="6" class="text-center">Không có dữ liệu khách hàng.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </c:if>
</div>
<jsp:include page="_footer_admin.jsp" />
</body>
</html>