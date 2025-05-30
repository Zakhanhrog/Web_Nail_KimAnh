<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>
    <c:if test="${appointment != null && appointment.appointmentId != 0}">Sửa Lịch Hẹn</c:if>
    <c:if test="${appointment == null || appointment.appointmentId == 0}">Tạo Lịch Hẹn Mới</c:if>
    - Admin Panel
  </title>
  <jsp:include page="_header_admin.jsp" />
  <style>
    .service-item-row { border: 1px solid #e0e0e0; padding: 15px; margin-bottom: 15px; border-radius: 5px; background-color: #f9f9f9;}
    .service-item-row .form-group { margin-bottom: 0.5rem; }
  </style>
</head>
<body>
<div class="container-fluid admin-container">
  <c:set var="formTitle">
    <c:if test="${appointment != null && appointment.appointmentId != 0}">Sửa Lịch Hẹn (ID: ${appointment.appointmentId})</c:if>
    <c:if test="${appointment == null || appointment.appointmentId == 0}">Tạo Lịch Hẹn Mới</c:if>
  </c:set>
  <h2 class="admin-page-title">${formTitle}</h2>

  <div class="card admin-form">
    <div class="card-body">
      <c:if test="${not empty requestScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
          <c:out value="${requestScope.errorMessage}"/>
          <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
        </div>
      </c:if>
      <c:set var="targetAppointment" value="${appointment != null ? appointment : appointmentDraft}" />

      <form action="${pageContext.request.contextPath}/admin/appointments/${(targetAppointment != null && targetAppointment.appointmentId gt 0) ? 'update' : 'insert'}" method="post">
        <c:if test="${targetAppointment != null && targetAppointment.appointmentId gt 0}">
          <input type="hidden" name="appointmentId" value="<c:out value='${targetAppointment.appointmentId}' />" />
        </c:if>

        <h5>Thông Tin Khách Hàng & Lịch Hẹn</h5>
        <hr class="mt-1 mb-3">
        <div class="form-row">
          <div class="form-group col-md-4">
            <label for="customerId">Khách Hàng (Nếu có TK):</label>
            <select class="custom-select" id="customerId" name="customerId">
              <option value="0">-- Khách vãng lai --</option>
              <c:forEach var="customer" items="${customerList}">
                <option value="${customer.userId}" ${targetAppointment.customerId == customer.userId ? 'selected' : ''}>
                  <c:out value="${customer.fullName}" /> (<c:out value="${customer.email}" />)
                </option>
              </c:forEach>
            </select>
          </div>
          <div class="form-group col-md-4">
            <label for="guestName">Tên Khách Vãng Lai:</label>
            <input type="text" class="form-control" id="guestName" name="guestName" value="<c:out value='${targetAppointment.guestName}' />">
          </div>
          <div class="form-group col-md-4">
            <label for="guestPhone">SĐT Khách Vãng Lai:</label>
            <input type="tel" class="form-control" id="guestPhone" name="guestPhone" value="<c:out value='${targetAppointment.guestPhone}' />">
          </div>
        </div>

        <div class="form-row">
          <div class="form-group col-md-4">
            <label for="appointmentDate">Ngày Hẹn (*):</label>
            <input type="date" class="form-control" id="appointmentDate" name="appointmentDate"
                   value="<fmt:formatDate value="${targetAppointment.appointmentDatetime}" pattern="yyyy-MM-dd" />" required>
          </div>
          <div class="form-group col-md-4">
            <label for="appointmentTime">Giờ Hẹn (*):</label>
            <input type="time" class="form-control" id="appointmentTime" name="appointmentTime"
                   value="<fmt:formatDate value="${targetAppointment.appointmentDatetime}" pattern="HH:mm" />" required>
          </div>
          <div class="form-group col-md-4">
            <label for="staffId">Nhân Viên Thực Hiện:</label>
            <select class="custom-select" id="staffId" name="staffId">
              <option value="0">-- Tự động hoặc chưa gán --</option>
              <c:forEach var="staff" items="${staffList}">
                <option value="${staff.userId}" ${targetAppointment.staffId == staff.userId ? 'selected' : ''}>
                  <c:out value="${staff.fullName}" />
                </option>
              </c:forEach>
            </select>
          </div>
        </div>
        <div class="form-group">
          <label for="status">Trạng Thái:</label>
          <select name="status" id="status" class="custom-select">
            <option value="pending_confirmation" ${targetAppointment.status == 'pending_confirmation' ? 'selected' : ''}>Chờ xác nhận</option>
            <option value="confirmed" ${targetAppointment.status == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
            <option value="in_progress" ${targetAppointment.status == 'in_progress' ? 'selected' : ''}>Đang thực hiện</option>
            <option value="completed" ${targetAppointment.status == 'completed' ? 'selected' : ''}>Hoàn tất</option>
            <option value="cancelled_by_customer" ${targetAppointment.status == 'cancelled_by_customer' ? 'selected' : ''}>Khách hủy</option>
            <option value="cancelled_by_staff" ${targetAppointment.status == 'cancelled_by_staff' ? 'selected' : ''}>Tiệm hủy</option>
            <option value="no_show" ${targetAppointment.status == 'no_show' ? 'selected' : ''}>Không đến</option>
          </select>
        </div>

        <h5 class="mt-4">Dịch Vụ & Mẫu Nail</h5>
        <hr class="mt-1 mb-3">
        <div id="serviceItemsContainerAdmin">
          <c:choose>
            <c:when test="${not empty details && targetAppointment != null && targetAppointment.appointmentId gt 0}">
              <c:forEach var="detail" items="${details}" varStatus="loop">
                <div class="service-item-row">
                  <input type="hidden" name="detailId" value="${detail.appointmentDetailId}"> <%-- Giữ lại ID để update nếu cần --%>
                  <div class="form-row">
                    <div class="form-group col-md-5">
                      <label>Dịch Vụ ${loop.count}:</label>
                      <select name="serviceId" class="custom-select service-select">
                        <option value="">-- Chọn dịch vụ --</option>
                        <c:forEach var="service" items="${serviceList}"><option value="${service.serviceId}" ${detail.serviceId == service.serviceId ? 'selected' : ''} data-price="${service.price}" data-duration="${service.durationMinutes}">${service.serviceName} (<fmt:formatNumber value="${service.price}" type="currency"/>)</option></c:forEach>
                      </select>
                    </div>
                    <div class="form-group col-md-4">
                      <label>Mẫu Nail:</label>
                      <select name="nailArtId" class="custom-select nailart-select">
                        <option value="0">-- Không chọn mẫu --</option>
                        <c:forEach var="nailArt" items="${nailArtList}"><option value="${nailArt.nailArtId}" ${detail.nailArtId == nailArt.nailArtId ? 'selected' : ''} data-price="${nailArt.priceAddon}">${nailArt.nailArtName} (+<fmt:formatNumber value="${nailArt.priceAddon}" type="currency"/>)</option></c:forEach>
                      </select>
                    </div>
                    <div class="form-group col-md-2">
                      <label>Số Lượng:</label>
                      <input type="number" name="quantity" class="form-control quantity-input" value="${detail.quantity}" min="1">
                    </div>
                    <div class="form-group col-md-1 d-flex align-items-end">
                      <button type="button" class="btn btn-danger btn-sm remove-service-item-admin">Xóa</button>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div class="service-item-row">
                <div class="form-row">
                  <div class="form-group col-md-5">
                    <label>Dịch Vụ 1:</label>
                    <select name="serviceId" class="custom-select service-select">
                      <option value="">-- Chọn dịch vụ --</option>
                      <c:forEach var="service" items="${serviceList}"><option value="${service.serviceId}" data-price="${service.price}" data-duration="${service.durationMinutes}">${service.serviceName} (<fmt:formatNumber value="${service.price}" type="currency"/>)</option></c:forEach>
                    </select>
                  </div>
                  <div class="form-group col-md-4">
                    <label>Mẫu Nail:</label>
                    <select name="nailArtId" class="custom-select nailart-select">
                      <option value="0">-- Không chọn mẫu --</option>
                      <c:forEach var="nailArt" items="${nailArtList}"><option value="${nailArt.nailArtId}" data-price="${nailArt.priceAddon}">${nailArt.nailArtName} (+<fmt:formatNumber value="${nailArt.priceAddon}" type="currency"/>)</option></c:forEach>
                    </select>
                  </div>
                  <div class="form-group col-md-2">
                    <label>Số Lượng:</label>
                    <input type="number" name="quantity" class="form-control quantity-input" value="1" min="1">
                  </div>
                  <div class="form-group col-md-1 d-flex align-items-end">
                      <%-- Nút xóa sẽ được thêm bởi JS --%>
                  </div>
                </div>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
        <button type="button" id="addServiceItemAdmin" class="btn btn-info btn-sm mb-3">Thêm Dịch Vụ Khác</button>

        <h5 class="mt-3">Ghi Chú & Thanh Toán</h5>
        <hr class="mt-1 mb-3">
        <div class="form-group">
          <label for="customerNotes">Ghi Chú Của Khách:</label>
          <textarea class="form-control" id="customerNotes" name="customerNotes" rows="2"><c:out value='${targetAppointment.customerNotes}' /></textarea>
        </div>
        <div class="form-group">
          <label for="staffNotes">Ghi Chú Của Tiệm:</label>
          <textarea class="form-control" id="staffNotes" name="staffNotes" rows="2"><c:out value='${targetAppointment.staffNotes}' /></textarea>
        </div>
        <div class="form-group">
          <label for="discountAmount">Giảm Giá (VNĐ):</label>
          <input type="number" step="1000" class="form-control" id="discountAmount" name="discountAmount" value="${targetAppointment.discountAmount != null ? targetAppointment.discountAmount : 0}" min="0">
        </div>
        <hr>
        <div class="text-right">
          <button type="submit" class="btn btn-primary">Lưu Lịch Hẹn</button>
          <a href="${pageContext.request.contextPath}/admin/appointments/list" class="btn btn-secondary">Hủy</a>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="_footer_admin.jsp" />
<script>
  document.addEventListener('DOMContentLoaded', function () {
    let serviceItemCounter = document.querySelectorAll('#serviceItemsContainerAdmin .service-item-row').length;
    if (serviceItemCounter === 0) serviceItemCounter = 1; // Nếu form mới, bắt đầu từ 1

    document.getElementById('addServiceItemAdmin').addEventListener('click', function() {
      serviceItemCounter++;
      const container = document.getElementById('serviceItemsContainerAdmin');
      const newItemHtml = `
                    <div class="service-item-row">
                        <div class="form-row">
                            <div class="form-group col-md-5">
                                <label>Dịch Vụ ${"$"}{serviceItemCounter}:</label>
                                <select name="serviceId" class="custom-select service-select">
                                    <option value="">-- Chọn dịch vụ --</option>
                                    <c:forEach var="service" items="${serviceList}"><option value="${service.serviceId}" data-price="${service.price}" data-duration="${service.durationMinutes}">${service.serviceName} (<fmt:formatNumber value="${service.price}" type="currency"/>)</option></c:forEach>
                                </select>
                            </div>
                            <div class="form-group col-md-4">
                                <label>Mẫu Nail:</label>
                                <select name="nailArtId" class="custom-select nailart-select">
                                    <option value="0">-- Không chọn mẫu --</option>
                                    <c:forEach var="nailArt" items="${nailArtList}"><option value="${nailArt.nailArtId}" data-price="${nailArt.priceAddon}">${nailArt.nailArtName} (+<fmt:formatNumber value="${nailArt.priceAddon}" type="currency"/>)</option></c:forEach>
                                </select>
                            </div>
                            <div class="form-group col-md-2">
                                <label>Số Lượng:</label>
                                <input type="number" name="quantity" class="form-control quantity-input" value="1" min="1">
                            </div>
                            <div class="form-group col-md-1 d-flex align-items-end">
                                <button type="button" class="btn btn-danger btn-sm remove-service-item-admin">Xóa</button>
                            </div>
                        </div>
                    </div>`;
      container.insertAdjacentHTML('beforeend', newItemHtml);
    });

    document.getElementById('serviceItemsContainerAdmin').addEventListener('click', function(event) {
      if (event.target.classList.contains('remove-service-item-admin')) {
        event.target.closest('.service-item-row').remove();
        // Cập nhật lại số thứ tự label nếu cần (phức tạp hơn, có thể bỏ qua)
      }
    });
  });
</script>
</body>
</html>