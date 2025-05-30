<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Đặt Lịch Thành Công - Tiệm Nail</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="_header_customer.jsp" />
<div class="container mt-5 text-center">
  <div class="alert alert-success" role="alert">
    <h4 class="alert-heading">Đặt Lịch Thành Công!</h4>
    <p>Cảm ơn bạn đã đặt lịch hẹn tại Tiệm Nail XYZ. Lịch hẹn của bạn (ID: <strong>${param.appointmentId}</strong>) đã được ghi nhận.</p>
    <p>Chúng tôi sẽ sớm liên hệ với bạn để xác nhận (nếu cần thiết). Vui lòng kiểm tra email hoặc điện thoại của bạn.</p>
    <hr>
    <p class="mb-0">
      <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về Trang Chủ</a>
      <a href="#" class="btn btn-info">Xem Lịch Hẹn Của Tôi</a> <%-- Link đến trang lịch sử đặt lịch --%>
    </p>
  </div>
</div>
<jsp:include page="_footer_customer.jsp" />
</body>
</html>