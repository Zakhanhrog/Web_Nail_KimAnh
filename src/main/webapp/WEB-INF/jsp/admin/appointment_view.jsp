<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="userDAOForJSP" class="com.tiemnail.app.dao.UserDAO" scope="request"/>
<jsp:useBean id="serviceDAOForJSP" class="com.tiemnail.app.dao.ServiceDAO" scope="request"/>
<jsp:useBean id="nailArtDAOForJSP" class="com.tiemnail.app.dao.NailArtDAO" scope="request"/>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Chi Tiết Lịch Hẹn #${appointment.appointmentId} - Admin Panel</title>
  <jsp:include page="_header_admin.jsp" />
  <style>
    .status-badge { padding: .35em .65em; font-size: 85%; font-weight: 600; border-radius: .25rem; }
    .status-pending_confirmation { background-color: #ffc107; color: #212529; }
    .status-confirmed { background-color: #17a2b8; color: white; }
    .status-in_progress { background-color: #007bff; color: white; }
    .status-completed { background-color: #28a745; color: white; }
    .status-cancelled_by_customer, .status-cancelled_by_staff, .status-no_show { background-color: #dc3545; color: white; }
    .detail-section h5 { font-weight: 500; color: #007bff; margin-top: 1.5rem; margin-bottom: 0.5rem; border-bottom: 1px solid #eee; padding-bottom: 0.5rem;}
  </style>
</head>
<body>
<div class="container-fluid admin-container">
  <c:if test="${not empty param.error && param.error == 'notfound'}">
    <div class="alert alert-danger">Lịch hẹn không tìm thấy.
      <a href="${pageContext.request.contextPath}/admin/appointments/list" class="alert-link">Quay lại danh sách</a>.
    </div>
  </c:if>
  <c:if test="${not empty sessionScope.successMessage_appointment_status}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <c:out value="${sessionScope.successMessage_appointment_status}"/>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
    </div>
    <c:remove var="successMessage_appointment_status" scope="session"/>
  </c:if>


  <c:if test="${appointment != null}">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h2 class="admin-page-title mb-0">Chi Tiết Lịch Hẹn #${appointment.appointmentId}</h2>
      <div>
        <a href="${pageContext.request.contextPath}/admin/appointments/list?filterDate=<fmt:formatDate value="${appointment.appointmentDatetime}" pattern="yyyy-MM-dd"/>" class="btn btn-outline-secondary btn-sm">Quay Lại Danh Sách</a>
        <a href="${pageContext.request.contextPath}/admin/appointments/edit?id=${appointment.appointmentId}" class="btn btn-primary btn-sm ml-2">Sửa Lịch Hẹn</a>
      </div>
    </div>

    <div class="card admin-form">
      <div class="card-body">
        <div class="row">
          <div class="col-md-6 detail-section">
            <h5>Thông Tin Khách Hàng</h5>
            <p>
              <c:if test="${not empty appointment.customerId}">
                <c:set var="customerUser" value="${userDAOForJSP.getUserById(appointment.customerId)}"/>
                <strong>Tên:</strong> <c:out value="${customerUser.fullName}"/><br/>
                <strong>Email:</strong> <c:out value="${customerUser.email}"/><br/>
                <strong>SĐT:</strong> <c:out value="${customerUser.phoneNumber}"/>
              </c:if>
              <c:if test="${empty appointment.customerId && not empty appointment.guestName}">
                <strong>Tên (Khách vãng lai):</strong> <c:out value="${appointment.guestName}"/><br/>
                <strong>SĐT:</strong> <c:out value="${appointment.guestPhone}"/>
              </c:if>
            </p>
            <p><strong>Ghi chú của khách:</strong> <c:out value="${appointment.customerNotes}" default="Không có"/></p>
          </div>
          <div class="col-md-6 detail-section">
            <h5>Thông Tin Lịch Hẹn</h5>
            <p>
              <strong>Nhân viên thực hiện:</strong>
              <c:if test="${not empty appointment.staffId}">
                <c:set var="staffUser" value="${userDAOForJSP.getUserById(appointment.staffId)}"/>
                <c:out value="${staffUser.fullName}"/>
              </c:if>
              <c:if test="${empty appointment.staffId}">Chưa được gán</c:if><br/>
              <strong>Ngày giờ hẹn:</strong> <fmt:formatDate value="${appointment.appointmentDatetime}" pattern="HH:mm 'ngày' dd/MM/yyyy" /><br/>
              <strong>Thời gian dự kiến:</strong> <c:out value="${appointment.estimatedDurationMinutes}"/> phút<br/>
              <strong>Trạng thái hiện tại:</strong>
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
            </p>
            <p><strong>Ghi chú của tiệm:</strong> <c:out value="${appointment.staffNotes}" default="Không có"/></p>
          </div>
        </div>

        <div class="detail-section">
          <h5>Chi Tiết Dịch Vụ & Mẫu Nail</h5>
          <div class="table-responsive">
            <table class="table table-sm table-striped">
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
                    </c:if>
                    <c:if test="${empty detail.nailArtId}">-</c:if>
                  </td>
                  <td class="text-right"><fmt:formatNumber value="${detail.servicePriceAtBooking}" type="currency" currencySymbol="₫"/></td>
                  <td class="text-right"><fmt:formatNumber value="${detail.nailArtPriceAtBooking}" type="currency" currencySymbol="₫"/></td>
                  <td class="text-center"><c:out value="${detail.quantity}"/></td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>

        <div class="row detail-section">
          <div class="col-md-6">
            <h5>Thanh Toán</h5>
            <p class="mb-1"><strong>Tổng giá dịch vụ cơ bản:</strong> <span class="float-right"><fmt:formatNumber value="${appointment.totalBasePrice}" type="currency" currencySymbol="₫"/></span></p>
            <p class="mb-1"><strong>Tổng giá mẫu nail (thêm):</strong> <span class="float-right"><fmt:formatNumber value="${appointment.totalAddonPrice}" type="currency" currencySymbol="₫"/></span></p>
            <p class="mb-1"><strong>Giảm giá:</strong> <span class="float-right text-danger">- <fmt:formatNumber value="${appointment.discountAmount}" type="currency" currencySymbol="₫"/></span></p>
            <hr class="my-1">
            <p class="mb-0"><strong>Thành tiền:</strong> <strong class="float-right" style="font-size: 1.3em;"><fmt:formatNumber value="${appointment.finalAmount}" type="currency" currencySymbol="₫"/></strong></p>
          </div>
          <div class="col-md-6">
            <h5>Cập Nhật Trạng Thái Lịch Hẹn</h5>
            <c:if test="${appointment.status != 'completed' && appointment.status != 'cancelled_by_customer' && appointment.status != 'cancelled_by_staff' && appointment.status != 'no_show'}">
              <form action="${pageContext.request.contextPath}/admin/appointments/update_status" method="post" class="form-inline">
                <input type="hidden" name="id" value="${appointment.appointmentId}">
                <input type="hidden" name="currentStaffId" value="${appointment.staffId}">
                <div class="form-group mr-2 flex-grow-1">
                  <select name="status" class="custom-select">
                    <option value="confirmed" ${appointment.status == 'pending_confirmation' ? '' : 'disabled'}>Xác nhận</option>
                    <option value="in_progress" ${appointment.status == 'confirmed' ? '' : 'disabled'}>Đang thực hiện</option>
                    <option value="completed" ${appointment.status == 'in_progress' ? '' : 'disabled'}>Hoàn tất</option>
                    <option value="cancelled_by_staff"
                            <c:if test="${appointment.status == 'completed' || appointment.status == 'cancelled_by_customer' || appointment.status == 'no_show'}">disabled</c:if>
                    >Tiệm hủy</option>
                    <option value="no_show"
                            <c:if test="${appointment.status == 'completed' || appointment.status == 'cancelled_by_customer' || appointment.status == 'cancelled_by_staff'}">disabled</c:if>
                    >Khách không đến</option>
                  </select>
                </div>
                <button type="submit" class="btn btn-warning">Cập nhật</button>
              </form>
            </c:if>
            <c:if test="${appointment.status == 'completed' || appointment.status == 'cancelled_by_customer' || appointment.status == 'cancelled_by_staff' || appointment.status == 'no_show'}">
              <p class="text-muted mt-2">Lịch hẹn đã ở trạng thái cuối cùng, không thể thay đổi.</p>
            </c:if>
          </div>
        </div>
      </div>
    </div>
  </c:if>
</div>
<jsp:include page="_footer_admin.jsp" />
</body>
</html>