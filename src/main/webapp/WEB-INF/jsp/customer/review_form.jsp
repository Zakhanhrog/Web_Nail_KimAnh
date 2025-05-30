<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="userDAOForJSP" class="com.tiemnail.app.dao.UserDAO" scope="request"/>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Đánh Giá Dịch Vụ - Tiệm Nail</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .star-rating { display: flex; flex-direction: row-reverse; justify-content: center; }
    .star-rating input[type="radio"] { display: none; }
    .star-rating label { font-size: 2rem; color: lightgray; cursor: pointer; padding: 0 0.2rem; }
    .star-rating input[type="radio"]:checked ~ label { color: orange; }
    .star-rating label:hover, .star-rating label:hover ~ label { color: orange; }
  </style>
</head>
<body>
<jsp:include page="_header_customer.jsp" />

<div class="container mt-4">
  <h2 class="mb-4">Đánh Giá Lịch Hẹn #${appointment.appointmentId}</h2>

  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger"><c:out value="${errorMessage}"/></div>
  </c:if>

  <c:if test="${appointment == null}">
    <div class="alert alert-warning">Không tìm thấy thông tin lịch hẹn để đánh giá.</div>
    <p><a href="${pageContext.request.contextPath}/customer/my-appointments/list" class="btn btn-primary">Quay lại lịch sử</a></p>
  </c:if>

  <c:if test="${appointment != null}">
    <p><strong>Ngày hẹn:</strong> <fmt:formatDate value="${appointment.appointmentDatetime}" pattern="dd/MM/yyyy HH:mm"/></p>
    <c:if test="${not empty appointment.staffId}">
      <c:set var="staffMember" value="${userDAOForJSP.getUserById(appointment.staffId)}"/>
      <p><strong>Nhân viên thực hiện:</strong> <c:out value="${staffMember.fullName}"/></p>
    </c:if>
    <hr/>

    <form action="${pageContext.request.contextPath}/customer/review/submit" method="post">
      <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">

      <div class="form-group">
        <label><strong>Đánh giá của bạn (Số sao):</strong></label>
        <div class="star-rating">
          <input type="radio" id="star5" name="ratingScore" value="5" required/><label for="star5" title="5 sao">★</label>
          <input type="radio" id="star4" name="ratingScore" value="4" /><label for="star4" title="4 sao">★</label>
          <input type="radio" id="star3" name="ratingScore" value="3" /><label for="star3" title="3 sao">★</label>
          <input type="radio" id="star2" name="ratingScore" value="2" /><label for="star2" title="2 sao">★</label>
          <input type="radio" id="star1" name="ratingScore" value="1" /><label for="star1" title="1 sao">★</label>
        </div>
      </div>

      <div class="form-group">
        <label for="comment"><strong>Nhận xét của bạn:</strong></label>
        <textarea class="form-control" id="comment" name="comment" rows="5" placeholder="Chia sẻ cảm nhận của bạn về dịch vụ..."></textarea>
      </div>

      <button type="submit" class="btn btn-primary">Gửi Đánh Giá</button>
      <a href="${pageContext.request.contextPath}/customer/my-appointments/view?id=${appointment.appointmentId}" class="btn btn-secondary">Bỏ qua</a>
    </form>
  </c:if>
</div>
<jsp:include page="_footer_customer.jsp" />
</body>
</html>