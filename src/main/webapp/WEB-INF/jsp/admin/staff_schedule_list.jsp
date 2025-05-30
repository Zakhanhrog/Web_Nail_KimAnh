<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Quản Lý Lịch Làm Việc Nhân Viên</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
  <div class="row mb-3">
    <div class="col-md-8">
      <h2>Lịch Làm Việc Nhân Viên <c:if test="${not empty selectedStaffName}">: <c:out value="${selectedStaffName}"/></c:if></h2>
    </div>
    <div class="col-md-4 text-right">
      <a href="${pageContext.request.contextPath}/admin/staff-schedules/new" class="btn btn-success">Thêm Lịch Mới</a>
    </div>
  </div>

  <form method="get" action="${pageContext.request.contextPath}/admin/staff-schedules/list" class="form-inline mb-3">
    <div class="form-group mr-2">
      <label for="staffIdFilter" class="mr-2">Chọn nhân viên:</label>
      <select name="staffId" id="staffIdFilter" class="form-control" onchange="this.form.submit()">
        <option value="">-- Tất cả (Chọn để xem) --</option>
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

  <table class="table table-bordered table-hover">
    <thead class="thead-dark">
    <tr>
      <th>ID Lịch</th>
      <th>Nhân Viên ID</th> <%-- Có thể join để lấy tên NV --%>
      <th>Ngày Làm</th>
      <th>Giờ Bắt Đầu</th>
      <th>Giờ Kết Thúc</th>
      <th>Trạng Thái</th>
      <th>Hành Động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="schedule" items="${listSchedule}">
      <tr>
        <td><c:out value="${schedule.scheduleId}" /></td>
        <td><c:out value="${schedule.staffId}" /></td>
        <td><fmt:formatDate value="${schedule.workDate}" pattern="dd/MM/yyyy" /></td>
        <td><fmt:formatDate value="${schedule.startTime}" pattern="HH:mm" /></td>
        <td><fmt:formatDate value="${schedule.endTime}" pattern="HH:mm" /></td>
        <td>
          <c:if test="${schedule.available}"><span class="badge badge-success">Sẵn sàng</span></c:if>
          <c:if test="${not schedule.available}"><span class="badge badge-secondary">Không sẵn sàng</span></c:if>
        </td>
        <td>
          <a href="${pageContext.request.contextPath}/admin/staff-schedules/edit?id=<c:out value='${schedule.scheduleId}' />" class="btn btn-sm btn-primary">Sửa</a>
          <a href="${pageContext.request.contextPath}/admin/staff-schedules/delete?id=<c:out value='${schedule.scheduleId}' />" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa lịch làm việc này không?')">Xóa</a>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty listSchedule && not empty param.staffId}">
      <tr>
        <td colspan="7" class="text-center">Nhân viên này chưa có lịch làm việc nào.</td>
      </tr>
    </c:if>
    <c:if test="${empty param.staffId}">
      <tr>
        <td colspan="7" class="text-center">Vui lòng chọn nhân viên để xem lịch.</td>
      </tr>
    </c:if>
    </tbody>
  </table>
</div>
</body>
</html>