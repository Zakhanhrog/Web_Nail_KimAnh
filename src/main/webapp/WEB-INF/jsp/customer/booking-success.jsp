<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đặt Lịch Thành Công - KimiBeauty</title>
  <jsp:include page="_header_customer.jsp" />
  <style>
    .success-container {
      min-height: 60vh;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      text-align: center;
    }
    .success-icon {
      font-size: 5rem;
      color: var(--accent-pink); /* Hoặc màu xanh lá thành công: #28a745 */
      margin-bottom: 20px;
      animation: popIn 0.5s ease-out;
    }
    .success-card {
      background-color: var(--white-pure);
      padding: 40px;
      border-radius: var(--border-radius-medium);
      box-shadow: var(--shadow-strong);
      max-width: 600px;
    }
    .success-card h3 {
      color: var(--text-darkest);
      margin-bottom: 15px;
    }
    .success-card p {
      color: var(--text-medium-gray);
      font-size: 1.05rem;
      line-height: 1.7;
    }
    .success-card .appointment-id {
      font-weight: bold;
      color: var(--accent-pink);
    }
    .success-actions .btn {
      margin: 10px 5px;
    }

    @keyframes popIn {
      0% { transform: scale(0.5); opacity: 0; }
      70% { transform: scale(1.1); opacity: 1; }
      100% { transform: scale(1); opacity: 1; }
    }
  </style>
</head>
<body>
<div class="customer-page-container success-container">
  <div class="success-card animated-fadeInUpSlight">
    <div class="success-icon">
      <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" fill="currentColor" class="bi bi-check-circle-fill" viewBox="0 0 16 16">
        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
      </svg>
    </div>
    <h3>Đặt Lịch Thành Công!</h3>
    <p>Cảm ơn bạn đã đặt lịch hẹn tại KimiBeauty. Lịch hẹn của bạn (ID: <strong class="appointment-id">#${param.appointmentId}</strong>) đã được ghi nhận và đang chờ xác nhận từ chúng tôi.</p>
    <p>Chúng tôi sẽ sớm liên hệ với bạn qua email hoặc điện thoại. Bạn có thể xem lại lịch hẹn trong mục "Lịch Hẹn Của Tôi".</p>
    <hr class="my-4">
    <div class="success-actions">
      <a href="${pageContext.request.contextPath}/customer/my-appointments" class="btn btn-primary-custom-filled">Xem Lịch Hẹn Của Tôi</a>
      <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary-custom">Về Trang Chủ</a>
    </div>
  </div>
</div>
<jsp:include page="_footer_customer.jsp" />
</body>
</html>