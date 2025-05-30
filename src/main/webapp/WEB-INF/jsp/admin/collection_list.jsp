<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản Lý Bộ Sưu Tập Nail - Admin Panel</title>
    <jsp:include page="_header_admin.jsp" />
</head>
<body>
<div class="container-fluid admin-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="admin-page-title mb-0">Danh Sách Bộ Sưu Tập Mẫu Nail</h2>
        <div>
            <a href="${pageContext.request.contextPath}/admin/nail-collections/new" class="btn btn-success">Thêm Bộ Sưu Tập</a>
        </div>
    </div>

    <c:if test="${not empty sessionScope.errorMessage_collection}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <c:out value="${sessionScope.errorMessage_collection}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
        </div>
        <c:remove var="errorMessage_collection" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.successMessage_collection}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <c:out value="${sessionScope.successMessage_collection}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
        </div>
        <c:remove var="successMessage_collection" scope="session"/>
    </c:if>

    <div class="card admin-form">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped mb-0">
                    <thead class="thead-dark">
                    <tr>
                        <th>ID</th>
                        <th>Tên Bộ Sưu Tập</th>
                        <th>Mô Tả</th>
                        <th class="text-center">Hành Động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="collection" items="${listCollection}">
                        <tr>
                            <td><c:out value="${collection.collectionId}" /></td>
                            <td><c:out value="${collection.collectionName}" /></td>
                            <td><c:out value="${collection.description}" default="-" /></td>
                            <td class="text-center action-buttons">
                                <a href="${pageContext.request.contextPath}/admin/nail-collections/edit?id=<c:out value='${collection.collectionId}' />" class="btn btn-sm btn-primary" title="Sửa">Sửa</a>
                                <a href="${pageContext.request.contextPath}/admin/nail-collections/delete?id=<c:out value='${collection.collectionId}' />" class="btn btn-sm btn-danger" title="Xóa"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa bộ sưu tập này không? Các mẫu nail thuộc bộ sưu tập này sẽ không còn liên kết.')">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listCollection}">
                        <tr>
                            <td colspan="4" class="text-center">Không có bộ sưu tập nào.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<jsp:include page="_footer_admin.jsp" />
</body>
</html>