<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="userDAOForJSP" class="com.tiemnail.app.dao.UserDAO" scope="request"/>
<jsp:useBean id="serviceDAOForJSP" class="com.tiemnail.app.dao.ServiceDAO" scope="request"/>
<jsp:useBean id="nailArtDAOForJSP" class="com.tiemnail.app.dao.NailArtDAO" scope="request"/>
<jsp:useBean id="reviewDAOForCheckPage" class="com.tiemnail.app.dao.ReviewDAO" scope="page"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Lịch Hẹn <c:if test="${appointment != null}">#${appointment.appointmentId}</c:if> - Tiệm Nail XYZ</title>
    <jsp:include page="_header_customer.jsp" />
    <style>
        /* Các style cho status-badge đã có trong my_appointment_list.jsp hoặc custom-style.css */
        /* Có thể thêm style riêng cho trang này nếu cần */
        .detail-section h5 {
            font-family: var(--font-heading);
            color: var(--accent-pink); /* Màu nhấn */
            margin-top: 1.8rem;
            margin-bottom: 0.8rem;
            padding-bottom: 0.6rem;
            border-bottom: 2px solid var(--primary-blue-soft); /* Đường gạch chân mềm mại */
            font-size: 1.3rem;
        }
        .info-block p { margin-bottom: 0.75rem; }
        .info-block strong { color: var(--text-dark-gray); min-width: 180px; display: inline-block;}
        .table-details th { background-color: var(--primary-blue-soft) !important; color: var(--text-on-blue-bg) !important; }
    </style>
</head>
<body>
<div class="customer-page-container">
    <c:if test="${not empty requestScope.errorMessage}">
        <div class="alert alert-danger animated-fadeIn"><c:out value="${requestScope.errorMessage}"/></div>
        <p class="text-center mt-3"><a href="${pageContext.request.contextPath}/customer/my-appointments/list" class="btn btn-secondary-custom">Quay Lại Danh Sách Lịch Hẹn</a></p>
    </c:if>
    <c:if test="${empty requestScope.errorMessage && appointment != null}">
        <h1 class="customer-page-title">Chi Tiết Lịch Hẹn #${appointment.appointmentId}</h1>

        <div class="card appointment-detail-card animated-fadeInUpSlight">
            <div class="card-body p-4">
                <div class="row">
                    <div class="col-md-6 detail-section">
                        <h5>Thông Tin Lịch Hẹn</h5>
                        <div class="info-block">
                            <p>
                                <strong>Nhân viên thực hiện:</strong>
                                <c:if test="${not empty appointment.staffId}">
                                    <c:set var="staffUser" value="${userDAOForJSP.getUserById(appointment.staffId)}"/>
                                    <c:out value="${staffUser.fullName}"/>
                                </c:if>
                                <c:if test="${empty appointment.staffId}">Chưa được gán</c:if>
                            </p>
                            <p><strong>Ngày giờ hẹn:</strong> <fmt:formatDate value="${appointment.appointmentDatetime}" pattern="HH:mm 'ngày' dd/MM/yyyy" /></p>
                            <p><strong>Thời gian dự kiến:</strong> <c:out value="${appointment.estimatedDurationMinutes}"/> phút</p>
                            <p>
                                <strong>Trạng thái:</strong>
                                <span class="badge status-badge status-${appointment.status}">
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
                    </div>
                    <div class="col-md-6 detail-section">
                        <h5>Thông Tin Thanh Toán</h5>
                        <div class="info-block">
                            <p><strong>Tổng giá dịch vụ:</strong> <span class="float-right"><fmt:formatNumber value="${appointment.totalBasePrice}" type="currency" currencySymbol="₫"/></span></p>
                            <p><strong>Tổng giá mẫu nail:</strong> <span class="float-right"><fmt:formatNumber value="${appointment.totalAddonPrice}" type="currency" currencySymbol="₫"/></span></p>
                            <p><strong>Giảm giá:</strong> <span class="float-right text-danger">- <fmt:formatNumber value="${appointment.discountAmount}" type="currency" currencySymbol="₫"/></span></p>
                            <hr class="my-2">
                            <p class="font-weight-bold"><strong>Thành tiền:</strong> <strong class="float-right" style="font-size: 1.4em; color: var(--accent-pink);"><fmt:formatNumber value="${appointment.finalAmount}" type="currency" currencySymbol="₫"/></strong></p>
                        </div>
                    </div>
                </div>

                <div class="detail-section">
                    <h5>Chi Tiết Dịch Vụ & Mẫu Nail Đã Đặt</h5>
                    <div class="table-responsive">
                        <table class="table table-sm table-striped table-bordered table-details">
                            <thead>
                            <tr>
                                <th>Dịch Vụ</th>
                                <th>Mẫu Nail (nếu có)</th>
                                <th class="text-right">Giá DV (lúc đặt)</th>
                                <th class="text-right">Giá Mẫu (lúc đặt)</th>
                                <th class="text-center">Số Lượng</th>
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
                                                <img src="${pageContext.request.contextPath}/${nailArt.imageUrl}" alt="Nail Art" style="max-width: 40px; max-height: 40px; margin-left: 10px; border-radius: 4px;"/>
                                            </c:if>
                                        </c:if>
                                        <c:if test="${empty detail.nailArtId}">-</c:if>
                                    </td>
                                    <td class="text-right"><fmt:formatNumber value="${detail.servicePriceAtBooking}" type="currency" currencySymbol="₫"/></td>
                                    <td class="text-right"><fmt:formatNumber value="${detail.nailArtPriceAtBooking}" type="currency" currencySymbol="₫"/></td>
                                    <td class="text-center"><c:out value="${detail.quantity}"/></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty details}">
                                <tr><td colspan="5" class="text-center text-muted">Không có chi tiết dịch vụ.</td></tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="card-footer bg-light text-right">
                <a href="${pageContext.request.contextPath}/customer/my-appointments/list" class="btn btn-secondary-custom">Quay Lại Danh Sách</a>
                <c:if test="${appointment.status == 'pending_confirmation' || appointment.status == 'confirmed'}">
                    <c:set var="nowPlusCancelHoursView" value="<%=new java.sql.Timestamp(java.util.Calendar.getInstance().getTimeInMillis() + 24*60*60*1000 - 1000)%>" />
                    <c:if test="${appointment.appointmentDatetime.after(nowPlusCancelHoursView)}">
                        <a href="${pageContext.request.contextPath}/customer/my-appointments/cancel?id=${appointment.appointmentId}" class="btn btn-danger ml-2" onclick="return confirm('Bạn có chắc chắn muốn hủy lịch hẹn này không?')">Hủy Lịch Hẹn</a>
                    </c:if>
                </c:if>
                <c:if test="${appointment.status == 'completed'}">
                    <c:set var="reviewedForView" value="${reviewDAOForCheckPage.getReviewByAppointmentId(appointment.appointmentId)}"/>
                    <c:if test="${empty reviewedForView}">
                        <a href="${pageContext.request.contextPath}/customer/review/new?appointmentId=${appointment.appointmentId}" class="btn btn-warning ml-2">Viết Đánh Giá</a>
                    </c:if>
                    <c:if test="${not empty reviewedForView}">
                        <button class="btn btn-outline-success ml-2" disabled>Đã đánh giá (<c:out value="${reviewedForView.ratingScore}"/> <span style="color: orange;">★</span>)</button>
                    </c:if>
                </c:if>
            </div>
        </div>
    </c:if>
</div>
<jsp:include page="_footer_customer.jsp" />
</body>
</html>