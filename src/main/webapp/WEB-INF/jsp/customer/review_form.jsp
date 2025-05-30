<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="userDAOForReviewForm" class="com.tiemnail.app.dao.UserDAO" scope="request"/>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Viết Đánh Giá Dịch Vụ - Tiệm Nail XYZ</title>
  <jsp:include page="_header_customer.jsp" />
  <style>
    /* Các style cho star-rating đã có trong custom-style.css */
    .review-form-container .appointment-info {
      background-color: var(--background-soft-cream);
      padding: 15px;
      border-radius: var(--border-radius-small);
      margin-bottom: 25px;
      border-left: 4px solid var(--primary-blue-soft);
    }
    .review-form-container .appointment-info p { margin-bottom: 0.5rem; }
    .review-form-container .form-group label strong { color: var(--text-darkest); }
  </style>
</head>
<body>
<div class="customer-page-container">
  <c:if test="${appointment != null}">
    <h1 class="customer-page-title">Đánh Giá Lịch Hẹn #${appointment.appointmentId}</h1>
    <p class="customer-page-subtitle">Chia sẻ cảm nhận của bạn để chúng tôi phục vụ tốt hơn!</p>
  </c:if>
  <c:if test="${appointment == null && empty errorMessage}">
    <h1 class="customer-page-title">Không tìm thấy lịch hẹn</h1>
  </c:if>


  <div class="review-form-container animated-fadeInUpSlight">
    <c:if test="${not empty errorMessage}">
      <div class="alert alert-danger"><c:out value="${errorMessage}"/></div>
      <p class="mt-3"><a href="${pageContext.request.contextPath}/customer/my-appointments/list" class="btn btn-secondary-custom">Quay lại lịch sử hẹn</a></p>
    </c:if>

    <c:if test="${appointment == null && empty errorMessage}">
      <div class="alert alert-warning">Không tìm thấy thông tin lịch hẹn để đánh giá.</div>
      <p class="mt-3"><a href="${pageContext.request.contextPath}/customer/my-appointments/list" class="btn btn-secondary-custom">Quay lại lịch sử hẹn</a></p>
    </c:if>

    <c:if test="${appointment != null}">
      <div class="appointment-info">
        <p><strong>Ngày hẹn:</strong> <fmt:formatDate value="${appointment.appointmentDatetime}" pattern="dd/MM/yyyy HH:mm"/></p>
        <c:if test="${not empty appointment.staffId}">
          <c:set var="staffMember" value="${userDAOForReviewForm.getUserById(appointment.staffId)}"/>
          <p><strong>Nhân viên phục vụ:</strong> <c:out value="${staffMember.fullName}"/></p>
        </c:if>
          <%-- Có thể thêm chi tiết dịch vụ nếu muốn --%>
      </div>


      <form action="${pageContext.request.contextPath}/customer/review/submit" method="post">
        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">

        <div class="form-group">
          <label for="ratingScore"><strong>Chất lượng dịch vụ (Số sao):</strong></label>
          <div class="star-rating">
            <input type="radio" id="star5" name="ratingScore" value="5" required/><label for="star5" title="Tuyệt vời">★</label>
            <input type="radio" id="star4" name="ratingScore" value="4" /><label for="star4" title="Tốt">★</label>
            <input type="radio" id="star3" name="ratingScore" value="3" /><label for="star3" title="Khá">★</label>
            <input type="radio" id="star2" name="ratingScore" value="2" /><label for="star2" title="Tạm ổn">★</label>
            <input type="radio" id="star1" name="ratingScore" value="1" /><label for="star1" title="Chưa tốt">★</label>
          </div>
        </div>

        <div class="form-group">
          <label for="comment"><strong>Nhận xét của bạn:</strong></label>
          <textarea class="form-control" id="comment" name="comment" rows="5" placeholder="Hãy cho chúng tôi biết cảm nhận của bạn về dịch vụ, nhân viên, không gian tiệm..."></textarea>
        </div>
        <hr class="my-4">
        <div class="text-right">
          <button type="submit" class="btn btn-primary-custom-filled">Gửi Đánh Giá</button>
          <a href="${pageContext.request.contextPath}/customer/my-appointments/view?id=${appointment.appointmentId}" class="btn btn-outline-secondary ml-2">Bỏ Qua</a>
        </div>
      </form>
    </c:if>
  </div>
</div>
<jsp:include page="_footer_customer.jsp" />
</body>
</html>