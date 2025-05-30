<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%--
    File này sẽ chứa phần <head> chung và navbar cho các trang khách hàng.
    Quan trọng: Các trang JSP con sẽ KHÔNG cần thẻ <!DOCTYPE html>, <html>, <head> nữa.
    Chúng sẽ bắt đầu trực tiếp với nội dung bên trong <body>.
--%>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">

  <%-- Title sẽ được set bởi trang JSP con, nhưng có thể có title mặc định ở đây --%>
  <%-- <title>KimiBeauty</title> --%>

  <!-- Bootstrap CSS từ CDN -->
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700&family=Playfair+Display:wght@400;500;600;700;800&display=swap" rel="stylesheet">

  <!-- Custom CSS của bạn -->
  <link href="${pageContext.request.contextPath}/css/custom-style.css" rel="stylesheet">

  <%-- Thẻ title sẽ được ghi đè bởi trang con nếu trang con cũng định nghĩa title --%>
</head>
<body> <%-- Mở thẻ body ở đây --%>

<nav class="navbar navbar-expand-lg navbar-dark fixed-top navbar-custom"> <%-- Sử dụng class navbar-custom --%>
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/">KimiBeauty</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarResponsive">
      <ul class="navbar-nav ml-auto">
        <li class="nav-item <c:if test="${pageContext.request.requestURI.endsWith('/') || pageContext.request.requestURI.endsWith('/index.jsp') || empty pageContext.request.servletPath && !pageContext.request.requestURI.contains('/admin/')}">active</c:if>">
          <a class="nav-link" href="${pageContext.request.contextPath}/">Trang Chủ
            <c:if test="${pageContext.request.requestURI.endsWith('/') || pageContext.request.requestURI.endsWith('/index.jsp') || empty pageContext.request.servletPath && !pageContext.request.requestURI.contains('/admin/')}"><span class="sr-only">(current)</span></c:if>
          </a>
        </li>
        <li class="nav-item <c:if test="${pageContext.request.requestURI.contains('/services')}">active</c:if>">
          <a class="nav-link" href="${pageContext.request.contextPath}/services">Dịch Vụ</a>
        </li>
        <li class="nav-item <c:if test="${pageContext.request.requestURI.contains('/nail-arts')}">active</c:if>">
          <a class="nav-link" href="${pageContext.request.contextPath}/nail-arts">Mẫu Nail</a>
        </li>
        <li class="nav-item <c:if test="${pageContext.request.requestURI.contains('/customer/book-appointment')}">active</c:if>">
          <a class="nav-link" href="${pageContext.request.contextPath}/customer/book-appointment">Đặt Lịch</a>
        </li>

        <c:choose>
          <c:when test="${not empty sessionScope.loggedInUser}">
            <li class="nav-item <c:if test="${pageContext.request.requestURI.contains('/customer/my-appointments')}">active</c:if>">
              <a class="nav-link" href="${pageContext.request.contextPath}/customer/my-appointments">Lịch Hẹn Của Tôi</a>
            </li>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownUser" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                Chào, <c:out value="${sessionScope.loggedInUser.fullName}"/>
              </a>
              <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownUser">
                <a class="dropdown-item" href="${pageContext.request.contextPath}/customer/profile/view">Hồ Sơ Của Tôi</a>
                <div class="dropdown-divider"></div>
                <c:if test="${sessionScope.loggedInUser.role == 'admin' || sessionScope.loggedInUser.role == 'staff' || sessionScope.loggedInUser.role == 'cashier'}">
                  <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">Trang Quản Trị</a>
                  <div class="dropdown-divider"></div>
                </c:if>
                <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng Xuất</a>
              </div>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item <c:if test="${pageContext.request.requestURI.contains('/login')}">active</c:if>">
              <a class="nav-link" href="${pageContext.request.contextPath}/login">Đăng Nhập</a>
            </li>
            <li class="nav-item <c:if test="${pageContext.request.requestURI.contains('/register')}">active</c:if>">
              <a class="nav-link" href="${pageContext.request.contextPath}/register">Đăng Ký</a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>
<div style="padding-top: 70px;"></div>
<%-- Thẻ <body> được mở ở đây và sẽ được đóng ở file JSP con (hoặc trong _footer_customer.jsp nếu bạn muốn) --%>