<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>
    <c:if test="${schedule != null}">Sửa Lịch Làm Việc</c:if>
    <c:if test="${schedule == null}">Thêm Lịch Làm Việc Mới</c:if>
  </title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
  <div class="card">
    <div class="card-header">
      <h3>
        <c:if test="${schedule != null}">Sửa Lịch Làm Việc</c:if>
        <c:if test="${schedule == null}">Thêm Lịch Làm Việc Mới</c:if>
      </h3>
    </div>
    <div class="card-body">
      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" role="alert">
          <c:out value="${errorMessage}"/>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/admin/staff-schedules/${schedule != null ? 'update' : 'insert'}" method="post">
        <c:if test="${schedule != null}">
          <input type="hidden" name="scheduleId" value="<c:out value='${schedule.scheduleId}' />" />
        </c:if>

        <div class="form-group">
          <label for="staffId">Nhân Viên (*):</label>
          <select class="form-control" id="staffId" name="staffId" required>
            <option value="">-- Chọn nhân viên --</option>
            <c:forEach var="staff" items="${staffList}">
              <option value="${staff.userId}" ${schedule.staffId == staff.userId ? 'selected' : ''}>
                <c:out value="${staff.fullName}" /> (<c:out value="${staff.role}" />)
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label for="workDate">Ngày Làm (*):</label>
          <input type="date" class="form-control" id="workDate" name="workDate"
                 value="<fmt:formatDate value="${schedule.workDate}" pattern="yyyy-MM-dd" />" required>
        </div>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="startTime">Giờ Bắt Đầu (*):</label>
            <input type="time" class="form-control" id="startTime" name="startTime"
                   value="<fmt:formatDate value="${schedule.startTime}" pattern="HH:mm" />" required>
          </div>
          <div class="form-group col-md-6">
            <label for="endTime">Giờ Kết Thúc (*):</label>
            <input type="time" class="form-control" id="endTime" name="endTime"
                   value="<fmt:formatDate value="${schedule.endTime}" pattern="HH:mm" />" required>
          </div>
        </div>

        <div class="form-group form-check">
          <input type="checkbox" class="form-check-input" id="isAvailable" name="isAvailable" <c:if test="${schedule == null || schedule.available}">checked</c:if>>
          <label class="form-check-label" for="isAvailable">Sẵn sàng làm việc</label>
        </div>

        <button type="submit" class="btn btn-primary">Lưu Lịch</button>
        <a href="${pageContext.request.contextPath}/admin/staff-schedules/list<c:if test='${not empty schedule.staffId}'>?staffId=${schedule.staffId}</c:if>" class="btn btn-secondary">Hủy</a>
      </form>
    </div>
  </div>
</div>
</body>
</html>