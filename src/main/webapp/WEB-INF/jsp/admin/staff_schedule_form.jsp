<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>
    <c:if test="${schedule != null && schedule.scheduleId != 0}">Sửa Lịch Làm Việc</c:if>
    <c:if test="${schedule == null || schedule.scheduleId == 0}">Thêm Lịch Làm Việc Mới</c:if>
    - Admin Panel
  </title>
  <jsp:include page="_header_admin.jsp" />
</head>
<body>
<div class="container-fluid admin-container">
  <c:set var="formTitle">
    <c:if test="${schedule != null && schedule.scheduleId != 0}">Sửa Lịch Làm Việc (ID: ${schedule.scheduleId})</c:if>
    <c:if test="${schedule == null || schedule.scheduleId == 0}">Thêm Lịch Làm Việc Mới</c:if>
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

          <form action="${pageContext.request.contextPath}/admin/staff-schedules/${(schedule != null && schedule.scheduleId != 0) ? 'update' : 'insert'}" method="post">
            <c:if test="${schedule != null && schedule.scheduleId != 0}">
              <input type="hidden" name="scheduleId" value="<c:out value='${schedule.scheduleId}' />" />
            </c:if>

            <div class="form-group">
              <label for="staffId">Nhân Viên (*):</label>
              <select class="custom-select" id="staffId" name="staffId" required>
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
            <hr>
            <div class="text-right">
              <button type="submit" class="btn btn-primary">Lưu Lịch</button>
              <a href="${pageContext.request.contextPath}/admin/staff-schedules/list<c:if test='${not empty schedule.staffId}'>?staffId=${schedule.staffId}</c:if><c:if test='${empty schedule.staffId && not empty param.staffId}'>?staffId=${param.staffId}</c:if>" class="btn btn-secondary">Hủy</a>
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