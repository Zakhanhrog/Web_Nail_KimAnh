<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="userDAOForJSP" class="com.tiemnail.app.dao.UserDAO" scope="request"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Chi Phí</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="row mb-3">
        <div class="col-md-6">
            <h2>Danh Sách Chi Phí</h2>
        </div>
        <div class="col-md-6 text-right">
            <a href="${pageContext.request.contextPath}/admin/expenses/new" class="btn btn-success">Thêm Chi Phí Mới</a>
        </div>
    </div>
    <c:if test="${not empty param.error && param.error == 'notfound'}">
        <div class="alert alert-danger">Chi phí không tìm thấy.</div>
    </c:if>

    <form method="get" action="${pageContext.request.contextPath}/admin/expenses/list" class="form-row mb-3">
        <div class="col-md-3 form-group">
            <label for="filterStartDate">Từ ngày:</label>
            <input type="date" name="filterStartDate" id="filterStartDate" class="form-control" value="${param.filterStartDate}">
        </div>
        <div class="col-md-3 form-group">
            <label for="filterEndDate">Đến ngày:</label>
            <input type="date" name="filterEndDate" id="filterEndDate" class="form-control" value="${param.filterEndDate}">
        </div>
        <div class="col-md-3 form-group">
            <label for="filterCategory">Lọc theo danh mục:</label>
            <input type="text" name="filterCategory" id="filterCategory" class="form-control" value="${param.filterCategory}" placeholder="VD: Vật tư, Lương">
        </div>
        <div class="col-md-2 form-group d-flex align-items-end">
            <button type="submit" class="btn btn-primary">Lọc</button>
            <a href="${pageContext.request.contextPath}/admin/expenses/list" class="btn btn-secondary ml-2">Reset</a>
        </div>
    </form>

    <table class="table table-bordered table-hover table-sm">
        <thead class="thead-dark">
        <tr>
            <th>ID</th>
            <th>Ngày</th>
            <th>Mô Tả</th>
            <th>Số Tiền</th>
            <th>Danh Mục</th>
            <th>Nhà Cung Cấp</th>
            <th>Người Ghi Nhận</th>
            <th>Hành Động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="expense" items="${listExpense}">
            <tr>
                <td><c:out value="${expense.expenseId}" /></td>
                <td><fmt:formatDate value="${expense.expenseDate}" pattern="dd/MM/yyyy" /></td>
                <td><c:out value="${expense.description}" /></td>
                <td><fmt:formatNumber value="${expense.amount}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></td>
                <td><c:out value="${expense.category}" /></td>
                <td><c:out value="${expense.supplier}" default="-" /></td>
                <td>
                    <c:if test="${not empty expense.recordedByUserId}">
                        <c:set var="recorder" value="${userDAOForJSP.getUserById(expense.recordedByUserId)}"/>
                        <c:out value="${recorder.fullName}"/>
                    </c:if>
                    <c:if test="${empty expense.recordedByUserId}">-</c:if>
                </td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/expenses/edit?id=<c:out value='${expense.expenseId}' />" class="btn btn-sm btn-primary">Sửa</a>
                    <a href="${pageContext.request.contextPath}/admin/expenses/delete?id=<c:out value='${expense.expenseId}' />" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa chi phí này không?')">Xóa</a>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty listExpense}">
            <tr>
                <td colspan="8" class="text-center">Không có chi phí nào được ghi nhận.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
</body>
</html>