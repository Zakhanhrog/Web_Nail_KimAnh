<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:useBean id="userDAOForJSP" class="com.tiemnail.app.dao.UserDAO" scope="request"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Hẹn Của Tôi - KimiBeauty</title>
    <jsp:include page="_header_customer.jsp" />
</head>
<body>
<div class="container customer-page-container"> <%-- Thêm class container ở đây --%>
    <h1 class="customer-page-title">Lịch Hẹn Của Tôi</h1>
    <p class="customer-page-subtitle">Theo dõi và quản lý các lịch hẹn của bạn một cách dễ dàng.</p>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show animated-fadeIn" role="alert">
            <c:out value="${sessionScope.successMessage}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show animated-fadeIn" role="alert">
            <c:out value="${sessionScope.errorMessage}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty requestScope.pageErrorMessage}"> <%-- Đổi thành pageErrorMessage nếu bạn dùng biến này --%>
        <div class="alert alert-danger animated-fadeIn"><c:out value="${requestScope.pageErrorMessage}"/></div>
    </c:if>

    <div class="card my-appointments-table-card"> <%-- Sử dụng class mới --%>
        <div class="card-body p-0"> <%-- Padding 0 nếu table-responsive đã có margin/padding riêng --%>
            <div class="table-responsive">
                <table class="table table-hover my-appointments-table mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Ngày Giờ</th>
                        <th>Nhân Viên</th>
                        <th class="text-right">Tổng Tiền</th>
                        <th class="text-center">Trạng Thái</th>
                        <th class="text-center">Hành Động</th>
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
                            <td class="text-right"><fmt:formatNumber value="${app.finalAmount}" type="currency" currencySymbol="₫"/></td>
                            <td class="text-center">
                                        <span class="badge status-${fn:toLowerCase(fn:replace(app.status, '_', '-'))}">
                                            <c:choose>
                                                <c:when test="${app.status == 'pending_confirmation'}">Chờ xác nhận</c:when>
                                                <c:when test="${app.status == 'confirmed'}">Đã xác nhận</c:when>
                                                <c:when test="${app.status == 'in_progress'}">Đang làm</c:when>
                                                <c:when test="${app.status == 'completed'}">Hoàn tất</c:when>
                                                <c:when test="${app.status == 'cancelled_by_customer'}">Bạn đã hủy</c:when>
                                                <c:when test="${app.status == 'cancelled_by_staff'}">Tiệm đã hủy</c:when>
                                                <c:when test="${app.status == 'no_show'}">Không đến</c:when>
                                                <c:otherwise><c:out value="${app.status}"/></c:otherwise>
                                            </c:choose>
                                        </span>
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/customer/my-appointments/view?id=${app.appointmentId}" class="btn btn-outline-primary-custom">Xem Chi Tiết</a>
                                <c:if test="${app.status == 'pending_confirmation' || app.status == 'confirmed'}">
                                    <c:set var="nowPlus24Hours" value="<%=new java.sql.Timestamp(java.util.Calendar.getInstance().getTimeInMillis() + 24L*60*60*1000 - 1000)%>" />
                                    <c:if test="${app.appointmentDatetime.after(nowPlus24Hours)}">
                                        <a href="${pageContext.request.contextPath}/customer/my-appointments/cancel?id=${app.appointmentId}" class="btn btn-outline-danger" onclick="return confirm('Bạn có chắc chắn muốn hủy lịch hẹn này không?')">Hủy Lịch</a>
                                    </c:if>
                                </c:if>
                                <c:if test="${app.status == 'completed'}">
                                    <jsp:useBean id="reviewCheckDAO" class="com.tiemnail.app.dao.ReviewDAO" scope="page"/>
                                    <c:set var="existingReviewForApp" value="${reviewCheckDAO.getReviewByAppointmentId(app.appointmentId)}" />
                                    <c:if test="${empty existingReviewForApp}">
                                        <a href="${pageContext.request.contextPath}/customer/review/new?appointmentId=${app.appointmentId}" class="btn btn-warning">Đánh Giá</a>
                                    </c:if>
                                    <c:if test="${not empty existingReviewForApp}">
                                        <button class="btn btn-outline-secondary" disabled>Đã đánh giá</button>
                                    </c:if>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty myAppointments}">
                        <tr>
                            <td colspan="6" class="text-center py-4">
                                <p>Bạn chưa có lịch hẹn nào.</p>
                                <a href="${pageContext.request.contextPath}/customer/book-appointment" class="btn btn-primary-custom-filled">Đặt lịch ngay!</a>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<jsp:include page="_footer_customer.jsp" />
</body>
</html>