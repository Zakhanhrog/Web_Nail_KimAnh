<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Quản Lý Lịch Làm Việc - Admin Panel</title>
  <jsp:include page="_header_admin.jsp" />
</head>
<body>
<div class="container-fluid admin-container">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="admin-page-title mb-0">Lịch Làm Việc Nhân Viên <c:if test="${not empty selectedStaffName}">: <c:out value="${selectedStaffName}"/></c:if></h2>
    <div>
      <a href="${pageContext.request.contextPath}/admin/staff-schedules/new" class="btn btn-success">Thêm Lịch Mới</a>
    </div>
  </div>

  <form method="get" action="${pageContext.request.contextPath}/admin/staff-schedules/list" class="form-inline mb-3 p-3 bg-light border rounded">
    <div class="form-group mr-3">
      <label for="staffIdFilter" class="mr-2">Chọn nhân viên:</label>
      <select name="staffId" id="staffIdFilter" class="custom-select" onchange="this.form.submit()">
        <option value="">-- Chọn để xem lịch --</option>
        <c:forEach var="staff" items="${staffList}">
          <option value="${staff.userId}" ${param.staffId == staff.userId ? 'selected' : ''}>
            <c:out value="${staff.fullName}" /> (<c:out value="${staff.role}" />)
          </option>
        </c:forEach>
      </select>
    </div>
  </form>

  <c:if test="${not empty param.error && param.error == 'notfound'}">
    <div class="alert alert-danger">Lịch làm việc không tìm thấy.</div>
  </c:if>
  <c:if test="${not empty sessionScope.successMessage_schedule}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <c:out value="${sessionScope.successMessage_schedule}"/>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
    </div>
    <c:remove var="successMessage_schedule" scope="session"/>
  </c:if>

  <div class="card admin-form">
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover table-striped mb-0">
          <thead class="thead-dark">
          <tr>
            <th>ID Lịch</th>
            <%-- <th>Nhân Viên ID</th> --%>
            <th>Ngày Làm</th>
            <th>Giờ Bắt Đầu</th>
            <th>Giờ Kết Thúc</th>
            <th>Trạng Thái</th>
            <th class="text-center">Hành Động</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="schedule" items="${listSchedule}">
            <tr>
              <td><c:out value="${schedule.scheduleId}" /></td>
                <%-- <td><c:out value="${schedule.staffId}" /></td> --%>
              <td><fmt:formatDate value="${schedule.workDate}" pattern="dd/MM/yyyy" /></td>
              <td><fmt:formatDate value="${schedule.startTime}" pattern="HH:mm" /></td>
              <td><fmt:formatDate value="${schedule.endTime}" pattern="HH:mm" /></td>
              <td>
                <c:if test="${schedule.available}"><span class="badge badge-success">Sẵn sàng</span></c:if>
                <c:if test="${not schedule.available}"><span class="badge badge-secondary">Không sẵn sàng</span></c:if>
              </td>
              <td class="text-center action-buttons">
                <a href="${pageContext.request.contextPath}/admin/staff-schedules/edit?id=<c:out value='${schedule.scheduleId}' />" class="btn btn-sm btn-primary" title="Sửa">Sửa</a>
                <a href="${pageContext.request.contextPath}/admin/staff-schedules/delete?id=<c:out value='${schedule.scheduleId}' />" class="btn btn-sm btn-danger" title="Xóa"
                   onclick="return confirm('Bạn có chắc chắn muốn xóa lịch làm việc này không?')">Xóa</a>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty listSchedule && not empty param.staffId}">
            <tr>
              <td colspan="6" class="text-center">Nhân viên này chưa có lịch làm việc nào.</td>
            </tr>
          </c:if>
          <c:if test="${empty param.staffId}">
            <tr>
              <td colspan="6" class="text-center">Vui lòng chọn nhân viên để xem lịch.</td>
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