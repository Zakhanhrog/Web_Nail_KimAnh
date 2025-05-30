<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="userDAOForJSP" class="com.tiemnail.app.dao.UserDAO" scope="request"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản Lý Lịch Hẹn - Admin Panel</title>
    <jsp:include page="_header_admin.jsp" />
    <style>
        .status-badge { padding: .35em .65em; font-size: 85%; font-weight: 600; border-radius: .25rem; }
        .status-pending_confirmation { background-color: #ffc107; color: #212529; }
        .status-confirmed { background-color: #17a2b8; color: white; }
        .status-in_progress { background-color: #007bff; color: white; }
        .status-completed { background-color: #28a745; color: white; }
        .status-cancelled_by_customer, .status-cancelled_by_staff, .status-no_show { background-color: #dc3545; color: white; }
    </style>
</head>
<body>
<div class="container-fluid admin-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="admin-page-title mb-0">Danh Sách Lịch Hẹn</h2>
        <div>
            <a href="${pageContext.request.contextPath}/admin/appointments/new" class="btn btn-success">Tạo Lịch Hẹn Mới</a>
        </div>
    </div>
    <c:if test="${not empty param.error && param.error == 'notfound'}">
        <div class="alert alert-danger">Lịch hẹn không tìm thấy.</div>
    </c:if>
    <c:if test="${not empty sessionScope.successMessage_appointment}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <c:out value="${sessionScope.successMessage_appointment}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
        </div>
        <c:remove var="successMessage_appointment" scope="session"/>
    </c:if>

    <div class="card admin-form mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin/appointments/list" class="form-row align-items-end">
                <div class="col-md-3 form-group mb-md-0">
                    <label for="filterDate">Lọc theo ngày:</label>
                    <input type="date" name="filterDate" id="filterDate" class="form-control" value="${param.filterDate}">
                </div>
                <div class="col-md-3 form-group mb-md-0">
                    <label for="filterStaffId">Lọc theo nhân viên:</label>
                    <select name="filterStaffId" id="filterStaffId" class="custom-select">
                        <option value="">-- Tất cả nhân viên --</option>
                        <c:forEach var="staff" items="${staffListForFilter}">
                            <option value="${staff.userId}" ${param.filterStaffId == staff.userId ? 'selected' : ''}>
                                <c:out value="${staff.fullName}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3 form-group mb-md-0">
                    <label for="filterStatus">Lọc theo trạng thái:</label>
                    <select name="filterStatus" id="filterStatus" class="custom-select">
                        <option value="">-- Tất cả trạng thái --</option>
                        <option value="pending_confirmation" ${param.filterStatus == 'pending_confirmation' ? 'selected' : ''}>Chờ xác nhận</option>
                        <option value="confirmed" ${param.filterStatus == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                        <option value="in_progress" ${param.filterStatus == 'in_progress' ? 'selected' : ''}>Đang thực hiện</option>
                        <option value="completed" ${param.filterStatus == 'completed' ? 'selected' : ''}>Hoàn tất</option>
                        <option value="cancelled_by_customer" ${param.filterStatus == 'cancelled_by_customer' ? 'selected' : ''}>Khách hủy</option>
                        <option value="cancelled_by_staff" ${param.filterStatus == 'cancelled_by_staff' ? 'selected' : ''}>Tiệm hủy</option>
                        <option value="no_show" ${param.filterStatus == 'no_show' ? 'selected' : ''}>Không đến</option>
                    </select>
                </div>
                <div class="col-md-auto form-group mb-md-0">
                    <button type="submit" class="btn btn-primary">Lọc</button>
                    <a href="${pageContext.request.contextPath}/admin/appointments/list" class="btn btn-secondary ml-2">Reset</a>
                </div>
            </form>
        </div>
    </div>

    <div class="card admin-form">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped mb-0">
                    <thead class="thead-dark">
                    <tr>
                        <th>ID</th>
                        <th>Khách Hàng</th>
                        <th>Nhân Viên</th>
                        <th>Ngày Giờ Hẹn</th>
                        <th class="text-right">Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th class="text-center">Hành Động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="appointment" items="${listAppointment}">
                        <tr>
                            <td><c:out value="${appointment.appointmentId}" /></td>
                            <td>
                                <c:if test="${not empty appointment.customerId}">
                                    <c:set var="customerUser" value="${userDAOForJSP.getUserById(appointment.customerId)}"/>
                                    <c:out value="${customerUser.fullName}"/> (ID: <c:out value="${appointment.customerId}"/>)
                                </c:if>
                                <c:if test="${empty appointment.customerId && not empty appointment.guestName}">
                                    <c:out value="${appointment.guestName}"/> (Khách vãng lai)
                                    <br/><small><c:out value="${appointment.guestPhone}"/></small>
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${not empty appointment.staffId}">
                                    <c:set var="staffUser" value="${userDAOForJSP.getUserById(appointment.staffId)}"/>
                                    <c:out value="${staffUser.fullName}"/> (ID: <c:out value="${appointment.staffId}"/>)
                                </c:if>
                                <c:if test="${empty appointment.staffId}">-Chưa gán-</c:if>
                            </td>
                            <td><fmt:formatDate value="${appointment.appointmentDatetime}" pattern="dd/MM/yyyy HH:mm" /></td>
                            <td class="text-right"><fmt:formatNumber value="${appointment.finalAmount}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></td>
                            <td>
                                        <span class="status-badge status-${appointment.status}">
                                            <c:choose>
                                                <c:when test="${appointment.status == 'pending_confirmation'}">Chờ xác nhận</c:when>
                                                <c:when test="${appointment.status == 'confirmed'}">Đã xác nhận</c:when>
                                                <c:when test="${appointment.status == 'in_progress'}">Đang thực hiện</c:when>
                                                <c:when test="${appointment.status == 'completed'}">Hoàn tất</c:when>
                                                <c:when test="${appointment.status == 'cancelled_by_customer'}">Khách hủy</c:when>
                                                <c:when test="${appointment.status == 'cancelled_by_staff'}">Tiệm hủy</c:when>
                                                <c:when test="${appointment.status == 'no_show'}">Không đến</c:when>
                                                <c:otherwise><c:out value="${appointment.status}"/></c:otherwise>
                                            </c:choose>
                                        </span>
                            </td>
                            <td class="text-center action-buttons">
                                <a href="${pageContext.request.contextPath}/admin/appointments/view?id=<c:out value='${appointment.appointmentId}' />" class="btn btn-sm btn-info" title="Xem chi tiết">Xem</a>
                                <a href="${pageContext.request.contextPath}/admin/appointments/edit?id=<c:out value='${appointment.appointmentId}' />" class="btn btn-sm btn-primary" title="Sửa">Sửa</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listAppointment}">
                        <tr>
                            <td colspan="7" class="text-center">Không có lịch hẹn nào phù hợp.</td>
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