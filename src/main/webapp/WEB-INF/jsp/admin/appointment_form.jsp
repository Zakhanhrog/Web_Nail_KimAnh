<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>
    <c:if test="${appointment != null}">Sửa Lịch Hẹn</c:if>
    <c:if test="${appointment == null}">Tạo Lịch Hẹn Mới</c:if>
  </title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .service-item { border: 1px solid #eee; padding: 10px; margin-bottom: 10px; border-radius: 5px; }
  </style>
</head>
<body>
<div class="container mt-4 mb-5">
  <div class="card">
    <div class="card-header">
      <h3>
        <c:if test="${appointment != null}">Sửa Lịch Hẹn #${appointment.appointmentId}</c:if>
        <c:if test="${appointment == null}">Tạo Lịch Hẹn Mới</c:if>
      </h3>
    </div>
    <div class="card-body">
      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" role="alert">
          <c:out value="${errorMessage}"/>
        </div>
      </c:if>
      <c:set var="targetAppointment" value="${appointment != null ? appointment : appointmentDraft}" />


      <form action="${pageContext.request.contextPath}/admin/appointments/${targetAppointment != null && targetAppointment.appointmentId gt 0 ? 'update' : 'insert'}" method="post">
        <c:if test="${targetAppointment != null && targetAppointment.appointmentId gt 0}">
          <input type="hidden" name="appointmentId" value="<c:out value='${targetAppointment.appointmentId}' />" />
        </c:if>

        <h4>Thông Tin Khách Hàng</h4>
        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="customerId">Khách Hàng Đã Có Tài Khoản:</label>
            <select class="form-control" id="customerId" name="customerId">
              <option value="0">-- Chọn khách hàng hoặc nhập thông tin khách vãng lai --</option>
              <c:forEach var="customer" items="${customerList}">
                <option value="${customer.userId}" ${targetAppointment.customerId == customer.userId ? 'selected' : ''}>
                  <c:out value="${customer.fullName}" /> (<c:out value="${customer.email}" />)
                </option>
              </c:forEach>
            </select>
          </div>
        </div>
        <p class="text-muted">Hoặc nhập thông tin khách vãng lai:</p>
        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="guestName">Tên Khách Vãng Lai:</label>
            <input type="text" class="form-control" id="guestName" name="guestName" value="<c:out value='${targetAppointment.guestName}' />">
          </div>
          <div class="form-group col-md-6">
            <label for="guestPhone">SĐT Khách Vãng Lai:</label>
            <input type="tel" class="form-control" id="guestPhone" name="guestPhone" value="<c:out value='${targetAppointment.guestPhone}' />">
          </div>
        </div>
        <hr>
        <h4>Thông Tin Lịch Hẹn</h4>
        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="appointmentDate">Ngày Hẹn (*):</label>
            <input type="date" class="form-control" id="appointmentDate" name="appointmentDate"
                   value="<fmt:formatDate value="${targetAppointment.appointmentDatetime}" pattern="yyyy-MM-dd" />" required>
          </div>
          <div class="form-group col-md-6">
            <label for="appointmentTime">Giờ Hẹn (*):</label>
            <input type="time" class="form-control" id="appointmentTime" name="appointmentTime"
                   value="<fmt:formatDate value="${targetAppointment.appointmentDatetime}" pattern="HH:mm" />" required>
          </div>
        </div>
        <div class="form-group">
          <label for="staffId">Nhân Viên Thực Hiện:</label>
          <select class="form-control" id="staffId" name="staffId">
            <option value="0">-- Chọn nhân viên (tự động hoặc chưa gán) --</option>
            <c:forEach var="staff" items="${staffList}">
              <option value="${staff.userId}" ${targetAppointment.staffId == staff.userId ? 'selected' : ''}>
                <c:out value="${staff.fullName}" />
              </option>
            </c:forEach>
          </select>
        </div>
        <div class="form-group">
          <label for="status">Trạng Thái:</label>
          <select name="status" id="status" class="form-control">
            <option value="pending_confirmation" ${targetAppointment.status == 'pending_confirmation' ? 'selected' : ''}>Chờ xác nhận</option>
            <option value="confirmed" ${targetAppointment.status == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
            <option value="in_progress" ${targetAppointment.status == 'in_progress' ? 'selected' : ''}>Đang thực hiện</option>
            <option value="completed" ${targetAppointment.status == 'completed' ? 'selected' : ''}>Hoàn tất</option>
            <option value="cancelled_by_customer" ${targetAppointment.status == 'cancelled_by_customer' ? 'selected' : ''}>Khách hủy</option>
            <option value="cancelled_by_staff" ${targetAppointment.status == 'cancelled_by_staff' ? 'selected' : ''}>Tiệm hủy</option>
            <option value="no_show" ${targetAppointment.status == 'no_show' ? 'selected' : ''}>Không đến</option>
          </select>
        </div>
        <hr>
        <h4>Dịch Vụ & Mẫu Nail</h4>
        <div id="serviceItemsContainer">
          <%--
              Đây là phần cần JavaScript để thêm/xóa dòng dịch vụ động.
              Tạm thời, nếu là edit, chúng ta hiển thị các dịch vụ đã có.
              Nếu là new, có thể hiển thị 1 dòng trống ban đầu.
          --%>
          <c:if test="${targetAppointment == null || targetAppointment.appointmentId == 0}"> <%-- Form thêm mới --%>
            <div class="service-item">
              <div class="form-row">
                <div class="form-group col-md-5">
                  <label>Dịch Vụ:</label>
                  <select name="serviceId" class="form-control service-select">
                    <option value="">-- Chọn dịch vụ --</option>
                    <c:forEach var="service" items="${serviceList}"><option value="${service.serviceId}">${service.serviceName} (<fmt:formatNumber value="${service.price}" type="currency"/>)</option></c:forEach>
                  </select>
                </div>
                <div class="form-group col-md-4">
                  <label>Mẫu Nail:</label>
                  <select name="nailArtId" class="form-control nailart-select">
                    <option value="0">-- Không chọn mẫu --</option>
                    <c:forEach var="nailArt" items="${nailArtList}"><option value="${nailArt.nailArtId}">${nailArt.nailArtName} (+<fmt:formatNumber value="${nailArt.priceAddon}" type="currency"/>)</option></c:forEach>
                  </select>
                </div>
                <div class="form-group col-md-2">
                  <label>Số Lượng:</label>
                  <input type="number" name="quantity" class="form-control quantity-input" value="1" min="1">
                </div>
                <div class="form-group col-md-1 d-flex align-items-end">
                    <%-- Nút xóa dòng (cần JS) --%>
                </div>
              </div>
            </div>
          </c:if>
          <c:if test="${targetAppointment != null && targetAppointment.appointmentId gt 0 && not empty details}"> <%-- Form sửa và có details --%>
            <c:forEach var="detail" items="${details}" varStatus="loop">
              <div class="service-item">
                <div class="form-row">
                  <div class="form-group col-md-5">
                    <label>Dịch Vụ:</label>
                    <select name="serviceId" class="form-control service-select">
                      <option value="">-- Chọn dịch vụ --</option>
                      <c:forEach var="service" items="${serviceList}"><option value="${service.serviceId}" ${detail.serviceId == service.serviceId ? 'selected' : ''}>${service.serviceName} (<fmt:formatNumber value="${service.price}" type="currency"/>)</option></c:forEach>
                    </select>
                  </div>
                  <div class="form-group col-md-4">
                    <label>Mẫu Nail:</label>
                    <select name="nailArtId" class="form-control nailart-select">
                      <option value="0">-- Không chọn mẫu --</option>
                      <c:forEach var="nailArt" items="${nailArtList}"><option value="${nailArt.nailArtId}" ${detail.nailArtId == nailArt.nailArtId ? 'selected' : ''}>${nailArt.nailArtName} (+<fmt:formatNumber value="${nailArt.priceAddon}" type="currency"/>)</option></c:forEach>
                    </select>
                  </div>
                  <div class="form-group col-md-2">
                    <label>Số Lượng:</label>
                    <input type="number" name="quantity" class="form-control quantity-input" value="${detail.quantity}" min="1">
                  </div>
                  <div class="form-group col-md-1 d-flex align-items-end">
                      <%-- Nút xóa dòng (cần JS) --%>
                  </div>
                </div>
              </div>
            </c:forEach>
          </c:if>
        </div>
        <button type="button" id="addServiceItem" class="btn btn-info btn-sm mb-3">Thêm Dịch Vụ Khác</button>

        <hr>
        <h4>Ghi Chú & Thanh Toán</h4>
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
          <input type="number" step="1000" class="form-control" id="discountAmount" name="discountAmount" value="${targetAppointment.discountAmount != null ? targetAppointment.discountAmount : 0}">
        </div>

        <button type="submit" class="btn btn-primary">Lưu Lịch Hẹn</button>
        <a href="${pageContext.request.contextPath}/admin/appointments/list" class="btn btn-secondary">Hủy</a>
      </form>
    </div>
  </div>

  <script>
    // JavaScript để thêm dòng dịch vụ động
    document.getElementById('addServiceItem').addEventListener('click', function() {
      const container = document.getElementById('serviceItemsContainer');
      const newItemHtml = `
                    <div class="service-item">
                        <div class="form-row">
                            <div class="form-group col-md-5">
                                <label>Dịch Vụ:</label>
                                <select name="serviceId" class="form-control service-select">
                                    <option value="">-- Chọn dịch vụ --</option>
                                    <c:forEach var="service" items="${serviceList}"><option value="${service.serviceId}">${service.serviceName} (<fmt:formatNumber value="${service.price}" type="currency"/>)</option></c:forEach>
                                </select>
                            </div>
                            <div class="form-group col-md-4">
                                <label>Mẫu Nail:</label>
                                <select name="nailArtId" class="form-control nailart-select">
                                    <option value="0">-- Không chọn mẫu --</option>
                                    <c:forEach var="nailArt" items="${nailArtList}"><option value="${nailArt.nailArtId}">${nailArt.nailArtName} (+<fmt:formatNumber value="${nailArt.priceAddon}" type="currency"/>)</option></c:forEach>
                                </select>
                            </div>
                            <div class="form-group col-md-2">
                                <label>Số Lượng:</label>
                                <input type="number" name="quantity" class="form-control quantity-input" value="1" min="1">
                            </div>
                            <div class="form-group col-md-1 d-flex align-items-end">
                                <button type="button" class="btn btn-danger btn-sm remove-service-item">Xóa</button>
                            </div>
                        </div>
                    </div>`;
      container.insertAdjacentHTML('beforeend', newItemHtml);
    });

    // JavaScript để xóa dòng dịch vụ
    document.getElementById('serviceItemsContainer').addEventListener('click', function(event) {
      if (event.target.classList.contains('remove-service-item')) {
        event.target.closest('.service-item').remove();
      }
    });
  </script>
</div>
</body>
</html>
