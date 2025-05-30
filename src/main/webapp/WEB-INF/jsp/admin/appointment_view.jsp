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
  <title>Chi Tiết Lịch Hẹn #${appointment.appointmentId}</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
  <div class="card">
    <div class="card-header">
      <h3>Chi Tiết Lịch Hẹn #${appointment.appointmentId}</h3>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-md-6">
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
        <div class="col-md-6">
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
            <strong>Trạng thái:</strong>
            <span class="badge status-${appointment.status}">
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

      <hr>
      <h5>Chi Tiết Dịch Vụ & Mẫu Nail</h5>
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

      <hr>
      <h5>Thanh Toán</h5>
      <p>
        <strong>Tổng giá dịch vụ cơ bản:</strong> <fmt:formatNumber value="${appointment.totalBasePrice}" type="currency" currencySymbol="₫"/><br/>
        <strong>Tổng giá mẫu nail (thêm):</strong> <fmt:formatNumber value="${appointment.totalAddonPrice}" type="currency" currencySymbol="₫"/><br/>
        <strong>Giảm giá:</strong> <fmt:formatNumber value="${appointment.discountAmount}" type="currency" currencySymbol="₫"/><br/>
        <strong>Thành tiền:</strong> <strong style="font-size: 1.2em;"><fmt:formatNumber value="${appointment.finalAmount}" type="currency" currencySymbol="₫"/></strong>
      </p>

      <hr>
      <h5>Cập Nhật Trạng Thái</h5>
      <c:if test="${appointment.status != 'completed' && appointment.status != 'cancelled_by_customer' && appointment.status != 'cancelled_by_staff' && appointment.status != 'no_show'}">
        <form action="${pageContext.request.contextPath}/admin/appointments/update_status" method="post" class="form-inline">
          <input type="hidden" name="id" value="${appointment.appointmentId}">
          <input type="hidden" name="currentStaffId" value="${param.filterStaffId}"> <%-- Giữ lại filter nếu có --%>
          <div class="form-group mr-2">
            <select name="status" class="form-control">
              <c:if test="${appointment.status == 'pending_confirmation'}">
                <option value="confirmed">Xác nhận</option>
                <option value="cancelled_by_staff">Tiệm hủy</option>
              </c:if>
              <c:if test="${appointment.status == 'confirmed'}">
                <option value="in_progress">Đang thực hiện</option>
                <option value="cancelled_by_staff">Tiệm hủy</option>
                <option value="no_show">Khách không đến</option>
              </c:if>
              <c:if test="${appointment.status == 'in_progress'}">
                <option value="completed">Hoàn tất</option>
                <option value="cancelled_by_staff">Tiệm hủy (nếu có vấn đề)</option>
              </c:if>
            </select>
          </div>
          <button type="submit" class="btn btn-warning">Cập nhật trạng thái</button>
        </form>
      </c:if>
      <c:if test="${appointment.status == 'completed' || appointment.status == 'cancelled_by_customer' || appointment.status == 'cancelled_by_staff' || appointment.status == 'no_show'}">
        <p class="text-muted">Lịch hẹn đã ở trạng thái cuối cùng.</p>
      </c:if>


    </div>
    <div class="card-footer">
      <a href="${pageContext.request.contextPath}/admin/appointments/list<c:if test='${not empty param.filterStaffId}'>?filterStaffId=${param.filterStaffId}</c:if><c:if test='${not empty param.filterDate}'>&filterDate=${param.filterDate}</c:if><c:if test='${not empty param.filterStatus}'>&filterStatus=${param.filterStatus}</c:if>" class="btn btn-secondary">Quay Lại Danh Sách</a>
    </div>
  </div>
</div>
</body>
</html>