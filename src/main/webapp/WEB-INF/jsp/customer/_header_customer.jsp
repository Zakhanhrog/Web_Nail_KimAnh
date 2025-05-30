<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/">Tiệm Nail XYZ</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarResponsive">
      <ul class="navbar-nav ml-auto">
        <li class="nav-item ${pageContext.request.requestURI.endsWith('/') || pageContext.request.requestURI.endsWith('/index.jsp') ? 'active' : ''}">
          <a class="nav-link" href="${pageContext.request.contextPath}/">Trang Chủ</a>
        </li>
        <li class="nav-item ${pageContext.request.requestURI.contains('/services') ? 'active' : ''}">
          <a class="nav-link" href="${pageContext.request.contextPath}/services">Dịch Vụ</a>
        </li>
        <li class="nav-item ${pageContext.request.requestURI.contains('/nail-arts') ? 'active' : ''}">
          <a class="nav-link" href="${pageContext.request.contextPath}/nail-arts">Mẫu Nail</a>
        </li>
        <c:choose>
          <c:when test="${not empty sessionScope.loggedInUser}">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownUser" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                Chào, <c:out value="${sessionScope.loggedInUser.fullName}"/>
              </a>
              <div class="dropdown-menu" aria-labelledby="navbarDropdownUser">
                <a class="dropdown-item" href="#">Hồ sơ của tôi</a> <%-- Link đến trang profile --%>
                <a class="dropdown-item" href="#">Lịch hẹn của tôi</a> <%-- Link đến lịch sử đặt lịch --%>
                <div class="dropdown-divider"></div>
                <c:if test="${sessionScope.loggedInUser.role == 'admin' || sessionScope.loggedInUser.role == 'staff' || sessionScope.loggedInUser.role == 'cashier'}">
                  <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">Trang Quản Trị</a>
                  <div class="dropdown-divider"></div>
                </c:if>
                <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
              </div>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item ${pageContext.request.requestURI.contains('/login') ? 'active' : ''}">
              <a class="nav-link" href="${pageContext.request.contextPath}/login">Đăng Nhập</a>
            </li>
            <li class="nav-item ${pageContext.request.requestURI.contains('/register') ? 'active' : ''}">
              <a class="nav-link" href="${pageContext.request.contextPath}/register">Đăng Ký</a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>
<div style="padding-top: 56px;"></div> <%-- Padding để nội dung không bị che bởi fixed navbar --%>