<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="_header_customer.jsp">
        <jsp:param name="pageTitle" value="Hồ Sơ Của Tôi - Tiệm Nail XYZ"/>
    </jsp:include>
    <style>
        .profile-card { background-color: var(--white-pure); border-radius: var(--border-radius-medium); box-shadow: var(--shadow-medium); padding: 30px;}
        .profile-info p { margin-bottom: 1rem; font-size: 1.05rem;}
        .profile-info strong { color: var(--text-darkest); min-width: 150px; display: inline-block;}
    </style>
</head>
<body>
<div class="customer-page-container">
    <h1 class="customer-page-title">Hồ Sơ Của Tôi</h1>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show animated-fadeIn" role="alert">
            <c:out value="${sessionScope.successMessage}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.passwordSuccessMessage}">
        <div class="alert alert-success alert-dismissible fade show animated-fadeIn" role="alert">
            <c:out value="${sessionScope.passwordSuccessMessage}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
        </div>
        <c:remove var="passwordSuccessMessage" scope="session"/>
    </c:if>

    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="profile-card animated-fadeInUpSlight">
                <div class="profile-info">
                    <p><strong>Họ và Tên:</strong> <c:out value="${sessionScope.loggedInUser.fullName}"/></p>
                    <p><strong>Email:</strong> <c:out value="${sessionScope.loggedInUser.email}"/></p>
                    <p><strong>Số Điện Thoại:</strong> <c:out value="${sessionScope.loggedInUser.phoneNumber}" default="Chưa cập nhật"/></p>
                    <p><strong>Vai trò:</strong> <span class="badge badge-info text-capitalize"><c:out value="${sessionScope.loggedInUser.role}"/></span></p>
                    <p><strong>Ngày tham gia:</strong> <fmt:formatDate value="${sessionScope.loggedInUser.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
                </div>
                <hr>
                <div class="text-right">
                    <a href="${pageContext.request.contextPath}/customer/profile/edit" class="btn btn-primary-custom-filled">Chỉnh Sửa Hồ Sơ & Mật Khẩu</a>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="_footer_customer.jsp" />
</body>
</html>