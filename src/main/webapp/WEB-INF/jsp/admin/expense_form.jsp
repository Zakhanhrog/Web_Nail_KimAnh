<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>
    <c:if test="${expense != null}">Sửa Chi Phí</c:if>
    <c:if test="${expense == null}">Thêm Chi Phí Mới</c:if>
  </title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
  <div class="card">
    <div class="card-header">
      <h3>
        <c:if test="${expense != null}">Sửa Thông Tin Chi Phí</c:if>
        <c:if test="${expense == null}">Thêm Chi Phí Mới</c:if>
      </h3>
    </div>
    <div class="card-body">
      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" role="alert">
          <c:out value="${errorMessage}"/>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/admin/expenses/${expense != null ? 'update' : 'insert'}" method="post">
        <c:if test="${expense != null}">
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
                 value="${expense.amount}" required>
        </div>

        <div class="form-group">
          <label for="category">Danh Mục:</label>
          <input type="text" class="form-control" id="category" name="category" value="<c:out value='${expense.category}' />" placeholder="Ví dụ: Vật tư, Lương, Mặt bằng">
        </div>

        <div class="form-group">
          <label for="supplier">Nhà Cung Cấp (nếu có):</label>
          <input type="text" class="form-control" id="supplier" name="supplier" value="<c:out value='${expense.supplier}' />">
        </div>

        <%-- Tạm thời chưa làm upload file hóa đơn
        <div class="form-group">
            <label for="receiptUrl">URL Hóa Đơn (tùy chọn):</label>
            <input type="url" class="form-control" id="receiptUrl" name="receiptUrl" value="<c:out value='${expense.receiptUrl}' />">
        </div>
        --%>

        <div class="form-group">
          <label for="recordedByUserId">Người Ghi Nhận (tùy chọn):</label>
          <select class="form-control" id="recordedByUserId" name="recordedByUserId">
            <option value="0">-- Chọn người ghi nhận --</option>
            <c:forEach var="user" items="${userList}">
              <option value="${user.userId}" ${expense.recordedByUserId == user.userId ? 'selected' : ''}>
                <c:out value="${user.fullName}" />
              </option>
            </c:forEach>
          </select>
        </div>


        <button type="submit" class="btn btn-primary">Lưu Chi Phí</button>
        <a href="${pageContext.request.contextPath}/admin/expenses/list" class="btn btn-secondary">Hủy</a>
      </form>
    </div>
  </div>
</div>
</body>
</html>