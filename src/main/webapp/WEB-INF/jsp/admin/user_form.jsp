<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- Thêm vào nếu cần --%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>
        <c:if test="${user != null && user.userId != 0}">Sửa Thông Tin Người Dùng</c:if>
        <c:if test="${user == null || user.userId == 0}">Thêm Người Dùng Mới</c:if>
        - Admin Panel
    </title>

    <jsp:include page="_header_admin.jsp" />

</head>
<body>

<div class="container-fluid admin-container">
    <c:set var="formTitle">
        <c:if test="${user != null && user.userId != 0}">Sửa Thông Tin Người Dùng (ID: ${user.userId})</c:if>
        <c:if test="${user == null || user.userId == 0}">Thêm Người Dùng Mới</c:if>
    </c:set>
    <h2 class="admin-page-title">${formTitle}</h2>

    <div class="row">
        <div class="col-lg-8 offset-lg-2 col-md-10 offset-md-1"> <%-- Căn giữa form trên màn hình lớn --%>
            <div class="card admin-form">
                <div class="card-body">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <c:out value="${errorMessage}"/>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">×</span>
                            </button>
                        </div>
                    </c:if>
                    <c:if test="${not empty requestScope.errorMessage}"> <%-- Dùng requestScope cho lỗi từ Servlet khi forward --%>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <c:out value="${requestScope.errorMessage}"/>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">×</span>
                            </button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin/users/${(user != null && user.userId != 0) ? 'update' : 'insert'}" method="post">
                        <c:if test="${user != null && user.userId != 0}">
                            <input type="hidden" name="userId" value="<c:out value='${user.userId}' />" />
                        </c:if>

                        <div class="form-group">
                            <label for="fullName">Họ Tên (*):</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" value="<c:out value='${user.fullName}' />" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email (*):</label>
                            <input type="email" class="form-control" id="email" name="email" value="<c:out value='${user.email}' />" required>
                        </div>

                        <div class="form-group">
                            <label for="password">Mật Khẩu ${ (user != null && user.userId != 0) ? '(Để trống nếu không muốn thay đổi)' : '(*)'}:</label>
                            <input type="password" class="form-control" id="password" name="password" ${ (user == null || user.userId == 0) ? 'required' : ''}>
                            <c:if test="${user != null && user.userId != 0}">
                                <small class="form-text text-muted">Nhập mật khẩu mới nếu bạn muốn thay đổi. Nếu để trống, mật khẩu cũ sẽ được giữ nguyên.</small>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="phoneNumber">Số Điện Thoại:</label>
                            <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="<c:out value='${user.phoneNumber}' />">
                        </div>

                        <div class="form-group">
                            <label for="role">Vai Trò (*):</label>
                            <select class="custom-select" id="role" name="role" required> <%-- Dùng custom-select của Bootstrap --%>
                                <option value="">-- Chọn vai trò --</option>
                                <option value="customer" ${user.role == 'customer' ? 'selected' : ''}>Khách hàng</option>
                                <option value="staff" ${user.role == 'staff' ? 'selected' : ''}>Nhân viên</option>
                                <option value="cashier" ${user.role == 'cashier' ? 'selected' : ''}>Thu ngân</option>
                                <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>Admin</option>
                            </select>
                        </div>

                        <div class="form-group form-check">
                            <input type="checkbox" class="form-check-input" id="isActive" name="isActive" <c:if test="${user == null || user.userId == 0 || user.active}">checked</c:if>>
                            <label class="form-check-label" for="isActive">Tài khoản hoạt động</label>
                        </div>

                        <hr>
                        <div class="text-right">
                            <button type="submit" class="btn btn-primary">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill mr-1" viewBox="0 0 16 16">
                                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                                </svg>
                                Lưu Thay Đổi
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/users/list" class="btn btn-secondary">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x-circle-fill mr-1" viewBox="0 0 16 16">
                                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0M5.354 4.646a.5.5 0 1 0-.708.708L7.293 8l-2.647 2.646a.5.5 0 0 0 .708.708L8 8.707l2.646 2.647a.5.5 0 0 0 .708-.708L8.707 8l2.647-2.646a.5.5 0 0 0-.708-.708L8 7.293z"/>
                                </svg>
                                Hủy Bỏ
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="_footer_admin.jsp" />
</body>
</html>