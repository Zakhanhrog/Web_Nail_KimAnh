<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="userDAOForJSP" class="com.tiemnail.app.dao.UserDAO" scope="request"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch Hẹn Của Tôi - Tiệm Nail</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .status-pending_confirmation { background-color: #ffc107; color: black; }
        .status-confirmed { background-color: #17a2b8; color: white; }
        .status-in_progress { background-color: #007bff; color: white; }
        .status-completed { background-color: #28a745; color: white; }
        .status-cancelled_by_customer, .status-cancelled_by_staff, .status-no_show { background-color: #dc3545; color: white; }
    </style>
</head>
<body>
<jsp:include page="_header_customer.jsp" />

<div class="container mt-4">
    <h2 class="mb-4">Lịch Hẹn Của Tôi</h2>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success" role="alert">
            <c:out value="${sessionScope.successMessage}"/>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger" role="alert">
            <c:out value="${sessionScope.errorMessage}"/>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty requestScope.errorMessage}">
        <div class="alert alert-danger" role="alert">
            <c:out value="${requestScope.errorMessage}"/>
        </div>
    </c:if>

    <div class="table-responsive">
        <table class="table table-hover">
            <thead>
            <tr>
                <th>ID Lịch Hẹn</th>
                <th>Ngày Giờ</th>
                <th>Nhân Viên</th>
                <th>Tổng Tiền</th>
                <th>Trạng Thái</th>
                <th>Hành Động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="app" items="${myAppointments}">
                <tr>
                    <td>#<c:out value="${app.appointmentId}"/></td>
                    <td><fmt:formatDate value="${app.appointmentDatetime}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td>
                        <c:if test="${not empty app.staffId}">
                            <c:set var="staffMember" value="${userDAOForJSP.getUserById(app.staffId)}"/>
                            <c:out value="${staffMember.fullName}"/>
                        </c:if>
                        <c:if test="${empty app.staffId}">Chưa gán</c:if>
                    </td>
                    <td><fmt:formatNumber value="${app.finalAmount}" type="currency" currencySymbol="₫"/></td>
                    <td>
                                <span class="badge status-${app.status}">
                                    <c:choose>
                                        <c:when test="${app.status == 'pending_confirmation'}">Chờ xác nhận</c:when>
                                        <c:when test="${app.status == 'confirmed'}">Đã xác nhận</c:when>
                                        <c:when test="${app.status == 'in_progress'}">Đang thực hiện</c:when>
                                        <c:when test="${app.status == 'completed'}">Hoàn tất</c:when>
                                        <c:when test="${app.status == 'cancelled_by_customer'}">Bạn đã hủy</c:when>
                                        <c:when test="${app.status == 'cancelled_by_staff'}">Tiệm đã hủy</c:when>
                                        <c:when test="${app.status == 'no_show'}">Không đến</c:when>
                                        <c:otherwise><c:out value="${app.status}"/></c:otherwise>
                                    </c:choose>
                                </span>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/customer/my-appointments/view?id=${app.appointmentId}" class="btn btn-info btn-sm">Xem Chi Tiết</a>
                        <c:if test="${app.status == 'pending_confirmation' || app.status == 'confirmed'}">
                            <%-- Thêm kiểm tra thời gian cho phép hủy ở đây nếu muốn (ví dụ: chỉ hiện nút nếu còn trong thời gian cho phép) --%>
                            <c:set var="nowPlus24Hours" value="<%=new java.sql.Timestamp(java.util.Calendar.getInstance().getTimeInMillis() + 24*60*60*1000)%>" />
                            <c:if test="${app.appointmentDatetime.after(nowPlus24Hours)}">
                                <a href="${pageContext.request.contextPath}/customer/my-appointments/cancel?id=${app.appointmentId}" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn hủy lịch hẹn này không?')">Hủy Lịch</a>
                            </c:if>
                        </c:if>
                        <c:if test="${app.status == 'completed'}">
                            <c:set var="existingReview" value="<%= new com.tiemnail.app.dao.ReviewDAO().getReviewByAppointmentId( ((com.tiemnail.app.model.Appointment)pageContext.getAttribute("app")).getAppointmentId() ) %>" />
                            <c:if test="${empty existingReview}">
                                <a href="${pageContext.request.contextPath}/customer/review/new?appointmentId=${app.appointmentId}" class="btn btn-warning btn-sm mt-1">Đánh Giá</a>
                            </c:if>
                            <c:if test="${not empty existingReview}">
                                <button class="btn btn-outline-secondary btn-sm mt-1" disabled>Đã đánh giá</button>
                            </c:if>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty myAppointments}">
                <tr>
                    <td colspan="6" class="text-center">Bạn chưa có lịch hẹn nào. <a href="${pageContext.request.contextPath}/customer/book-appointment">Đặt lịch ngay!</a></td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="_footer_customer.jsp" />
</body>
</html>