<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="userDAOForJSP" class="com.tiemnail.app.dao.UserDAO" scope="request"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản Lý Chi Phí - Admin Panel</title>
    <jsp:include page="_header_admin.jsp" />
</head>
<body>
<div class="container-fluid admin-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="admin-page-title mb-0">Danh Sách Chi Phí</h2>
        <div>
            <a href="${pageContext.request.contextPath}/admin/expenses/new" class="btn btn-success">Thêm Chi Phí Mới</a>
        </div>
    </div>

    <div class="card admin-form mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin/expenses/list" class="form-row align-items-end">
                <div class="col-md-3 form-group mb-md-0">
                    <label for="filterStartDate">Từ ngày:</label>
                    <input type="date" name="filterStartDate" id="filterStartDate" class="form-control" value="${param.filterStartDate}">
                </div>
                <div class="col-md-3 form-group mb-md-0">
                    <label for="filterEndDate">Đến ngày:</label>
                    <input type="date" name="filterEndDate" id="filterEndDate" class="form-control" value="${param.filterEndDate}">
                </div>
                <div class="col-md-3 form-group mb-md-0">
                    <label for="filterCategory">Lọc theo danh mục:</label>
                    <input type="text" name="filterCategory" id="filterCategory" class="form-control" value="${param.filterCategory}" placeholder="VD: Vật tư, Lương">
                </div>
                <div class="col-md-auto form-group mb-md-0">
                    <button type="submit" class="btn btn-primary">Lọc</button>
                    <a href="${pageContext.request.contextPath}/admin/expenses/list" class="btn btn-secondary ml-2">Reset</a>
                </div>
            </form>
        </div>
    </div>

    <c:if test="${not empty param.error && param.error == 'notfound'}">
        <div class="alert alert-danger">Chi phí không tìm thấy.</div>
    </c:if>
    <c:if test="${not empty sessionScope.successMessage_expense}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <c:out value="${sessionScope.successMessage_expense}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
        </div>
        <c:remove var="successMessage_expense" scope="session"/>
    </c:if>

    <div class="card admin-form">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped mb-0">
                    <thead class="thead-dark">
                    <tr>
                        <th>ID</th>
                        <th>Ngày</th>
                        <th>Mô Tả</th>
                        <th class="text-right">Số Tiền</th>
                        <th>Danh Mục</th>
                        <th>Nhà Cung Cấp</th>
                        <th>Người Ghi Nhận</th>
                        <th class="text-center">Hành Động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="expense" items="${listExpense}">
                        <tr>
                            <td><c:out value="${expense.expenseId}" /></td>
                            <td><fmt:formatDate value="${expense.expenseDate}" pattern="dd/MM/yyyy" /></td>
                            <td><c:out value="${expense.description}" /></td>
                            <td class="text-right"><fmt:formatNumber value="${expense.amount}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></td>
                            <td><c:out value="${expense.category}" default="-"/></td>
                            <td><c:out value="${expense.supplier}" default="-" /></td>
                            <td>
                                <c:if test="${not empty expense.recordedByUserId}">
                                    <c:set var="recorder" value="${userDAOForJSP.getUserById(expense.recordedByUserId)}"/>
                                    <c:out value="${recorder.fullName}"/>
                                </c:if>
                                <c:if test="${empty expense.recordedByUserId}">-</c:if>
                            </td>
                            <td class="text-center action-buttons">
                                <a href="${pageContext.request.contextPath}/admin/expenses/edit?id=<c:out value='${expense.expenseId}' />" class="btn btn-sm btn-primary" title="Sửa">Sửa</a>
                                <a href="${pageContext.request.contextPath}/admin/expenses/delete?id=<c:out value='${expense.expenseId}' />" class="btn btn-sm btn-danger" title="Xóa"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa chi phí này không?')">Xóa</a>
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
        </div>
    </div>
</div>
<jsp:include page="_footer_admin.jsp" />
</body>
</html>