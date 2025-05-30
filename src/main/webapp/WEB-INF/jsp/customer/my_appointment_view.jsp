<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="userDAOForJSP" class="com.tiemnail.app.dao.UserDAO" scope="request"/>
<jsp:useBean id="serviceDAOForJSP" class="com.tiemnail.app.dao.ServiceDAO" scope="request"/>
<jsp:useBean id="nailArtDAOForJSP" class="com.tiemnail.app.dao.NailArtDAO" scope="request"/>
<jsp:useBean id="reviewDAOForCheck" class="com.tiemnail.app.dao.ReviewDAO" scope="page"/> <%-- Thêm useBean cho ReviewDAO --%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Lịch Hẹn #${appointment.appointmentId} - Tiệm Nail</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="_header_customer.jsp" />

<div class="container mt-4">
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
        <div class="alert alert-danger"><c:out value="${requestScope.errorMessage}"/></div>
        <p><a href="${pageContext.request.contextPath}/customer/my-appointments/list" class="btn btn-secondary">Quay Lại Danh Sách Lịch Hẹn</a></p>
    </c:if>

    <c:if test="${empty requestScope.errorMessage && appointment != null}">
        <div class="card">
            <div class="card-header">
                <h3>Chi Tiết Lịch Hẹn #${appointment.appointmentId}</h3>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h5>Thông Tin Lịch Hẹn</h5>
                        <p>
                            <strong>Nhân viên thực hiện:</strong>
                            <c:if test="${not empty appointment.staffId}">
                                <c:set var="staffUser" value="${userDAOForJSP.getUserById(appointment.staffId)}"/>
                                <c:out value="${staffUser.fullName}"/>
                            </c:if>
                            <c:if test="${empty appointment.staffId}">Chưa được gán / Hoặc bạn đã chọn "Bất kỳ nhân viên nào"</c:if><br/>
                            <strong>Ngày giờ hẹn:</strong> <fmt:formatDate value="${appointment.appointmentDatetime}" pattern="HH:mm 'ngày' dd/MM/yyyy" /><br/>
                            <strong>Thời gian dự kiến:</strong> <c:out value="${appointment.estimatedDurationMinutes}"/> phút<br/>
                            <strong>Trạng thái:</strong>
                            <span class="badge status-${appointment.status}">
                                    <c:choose>
                                        <c:when test="${appointment.status == 'pending_confirmation'}">Chờ xác nhận</c:when>
                                        <c:when test="${appointment.status == 'confirmed'}">Đã xác nhận</c:when>
                                        <c:when test="${appointment.status == 'in_progress'}">Đang thực hiện</c:when>
                                        <c:when test="${appointment.status == 'completed'}">Hoàn tất</c:when>
                                        <c:when test="${appointment.status == 'cancelled_by_customer'}">Bạn đã hủy</c:when>
                                        <c:when test="${appointment.status == 'cancelled_by_staff'}">Tiệm đã hủy</c:when>
                                        <c:when test="${appointment.status == 'no_show'}">Không đến</c:when>
                                        <c:otherwise><c:out value="${appointment.status}"/></c:otherwise>
                                    </c:choose>
                                </span>
                        </p>
                        <p><strong>Ghi chú của bạn:</strong> <c:out value="${appointment.customerNotes}" default="Không có"/></p>
                    </div>
                    <div class="col-md-6">
                        <h5>Thanh Toán</h5>
                        <p>
                            <strong>Tổng giá dịch vụ cơ bản:</strong> <fmt:formatNumber value="${appointment.totalBasePrice}" type="currency" currencySymbol="₫"/><br/>
                            <strong>Tổng giá mẫu nail (thêm):</strong> <fmt:formatNumber value="${appointment.totalAddonPrice}" type="currency" currencySymbol="₫"/><br/>
                            <strong>Giảm giá:</strong> <fmt:formatNumber value="${appointment.discountAmount}" type="currency" currencySymbol="₫"/><br/>
                            <strong>Thành tiền:</strong> <strong style="font-size: 1.2em;"><fmt:formatNumber value="${appointment.finalAmount}" type="currency" currencySymbol="₫"/></strong>
                        </p>
                    </div>
                </div>

                <hr>
                <h5>Chi Tiết Dịch Vụ & Mẫu Nail Đã Đặt</h5>
                <table class="table table-sm table-striped">
                    <thead>
                    <tr>
                        <th>Dịch Vụ</th>
                        <th>Mẫu Nail (nếu có)</th>
                        <th>Giá Dịch Vụ (lúc đặt)</th>
                        <th>Giá Mẫu Nail (lúc đặt)</th>
                        <th>Số Lượng</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="detail" items="${details}">
                        <tr>
                            <td>
                                <c:set var="service" value="${serviceDAOForJSP.getServiceById(detail.serviceId)}"/>
                                <c:out value="${service.serviceName}"/>
                            </td>
                            <td>
                                <c:if test="${not empty detail.nailArtId}">
                                    <c:set var="nailArt" value="${nailArtDAOForJSP.getNailArtById(detail.nailArtId)}"/>
                                    <c:out value="${nailArt.nailArtName}"/>
                                    <c:if test="${not empty nailArt.imageUrl}">
                                        <img src="${pageContext.request.contextPath}/${nailArt.imageUrl}" alt="Nail Art" style="max-width: 50px; max-height: 50px; margin-left: 10px;"/>
                                    </c:if>
                                </c:if>
                                <c:if test="${empty detail.nailArtId}">-</c:if>
                            </td>
                            <td><fmt:formatNumber value="${detail.servicePriceAtBooking}" type="currency" currencySymbol="₫"/></td>
                            <td><fmt:formatNumber value="${detail.nailArtPriceAtBooking}" type="currency" currencySymbol="₫"/></td>
                            <td><c:out value="${detail.quantity}"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/customer/my-appointments/list" class="btn btn-secondary">Quay Lại Danh Sách</a>
                <c:if test="${appointment.status == 'pending_confirmation' || appointment.status == 'confirmed'}">
                    <c:set var="nowPlusCancelHours" value="<%=new java.sql.Timestamp(java.util.Calendar.getInstance().getTimeInMillis() + 24*60*60*1000)%>" />
                    <c:if test="${appointment.appointmentDatetime.after(nowPlusCancelHours)}">
                        <a href="${pageContext.request.contextPath}/customer/my-appointments/cancel?id=${appointment.appointmentId}" class="btn btn-danger" onclick="return confirm('Bạn có chắc chắn muốn hủy lịch hẹn này không?')">Hủy Lịch Hẹn Này</a>
                    </c:if>
                </c:if>
                <c:if test="${appointment.status == 'completed'}">
                    <c:set var="reviewed" value="${reviewDAOForCheck.getReviewByAppointmentId(appointment.appointmentId)}"/>
                    <c:if test="${empty reviewed}">
                        <a href="${pageContext.request.contextPath}/customer/review/new?appointmentId=${appointment.appointmentId}" class="btn btn-warning">Viết Đánh Giá</a>
                    </c:if>
                    <c:if test="${not empty reviewed}">
                        <button class="btn btn-outline-secondary" disabled>Đã đánh giá (<c:out value="${reviewed.ratingScore}"/> sao)</button>
                    </c:if>
                </c:if>
            </div>
        </div>
    </c:if>
</div>
<jsp:include page="_footer_customer.jsp" />
</body>
</html>