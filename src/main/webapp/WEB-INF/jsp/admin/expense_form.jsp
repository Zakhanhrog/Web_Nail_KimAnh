<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>
    <c:if test="${expense != null && expense.expenseId != 0}">Sửa Chi Phí</c:if>
    <c:if test="${expense == null || expense.expenseId == 0}">Thêm Chi Phí Mới</c:if>
    - Admin Panel
  </title>
  <jsp:include page="_header_admin.jsp" />
</head>
<body>
<div class="container-fluid admin-container">
  <c:set var="formTitle">
    <c:if test="${expense != null && expense.expenseId != 0}">Sửa Thông Tin Chi Phí (ID: ${expense.expenseId})</c:if>
    <c:if test="${expense == null || expense.expenseId == 0}">Thêm Chi Phí Mới</c:if>
  </c:set>
  <h2 class="admin-page-title">${formTitle}</h2>

  <div class="row">
    <div class="col-lg-6 offset-lg-3 col-md-8 offset-md-2">
      <div class="card admin-form">
        <div class="card-body">
          <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <c:out value="${requestScope.errorMessage}"/>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
            </div>
          </c:if>

          <form action="${pageContext.request.contextPath}/admin/expenses/${(expense != null && expense.expenseId != 0) ? 'update' : 'insert'}" method="post">
            <c:if test="${expense != null && expense.expenseId != 0}">
              <input type="hidden" name="expenseId" value="<c:out value='${expense.expenseId}' />" />
            </c:if>

            <div class="form-group">
              <label for="expenseDate">Ngày Chi Phí (*):</label>
              <input type="date" class="form-control" id="expenseDate" name="expenseDate"
                     value="<fmt:formatDate value="${expense.expenseDate}" pattern="yyyy-MM-dd" />" required>
            </div>

            <div class="form-group">
              <label for="description">Mô Tả (*):</label>
              <input type="text" class="form-control" id="description" name="description" value="<c:out value='${expense.description}' />" required>
            </div>

            <div class="form-group">
              <label for="amount">Số Tiền (VNĐ) (*):</label>
              <input type="number" step="1000" class="form-control" id="amount" name="amount"
                     value="${expense.amount}" required min="1000">
            </div>

            <div class="form-group">
              <label for="category">Danh Mục:</label>
              <input type="text" class="form-control" id="category" name="category" value="<c:out value='${expense.category}' />" placeholder="Ví dụ: Vật tư, Lương, Mặt bằng, Marketing">
            </div>

            <div class="form-group">
              <label for="supplier">Nhà Cung Cấp (nếu có):</label>
              <input type="text" class="form-control" id="supplier" name="supplier" value="<c:out value='${expense.supplier}' />">
            </div>

            <div class="form-group">
              <label for="recordedByUserId">Người Ghi Nhận (tùy chọn):</label>
              <select class="custom-select" id="recordedByUserId" name="recordedByUserId">
                <option value="0">-- Chọn người ghi nhận --</option>
                <c:forEach var="user" items="${userList}"> <%-- userList cần được set từ Servlet --%>
                  <option value="${user.userId}" ${expense.recordedByUserId == user.userId ? 'selected' : ''}>
                    <c:out value="${user.fullName}" />
                  </option>
                </c:forEach>
              </select>
            </div>
            <hr>
            <div class="text-right">
              <button type="submit" class="btn btn-primary">Lưu Chi Phí</button>
              <a href="${pageContext.request.contextPath}/admin/expenses/list" class="btn btn-secondary">Hủy</a>
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