<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Bộ Sưu Tập Mẫu Nail</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="row mb-3">
        <div class="col-md-6">
            <h2>Danh Sách Bộ Sưu Tập</h2>
        </div>
        <div class="col-md-6 text-right">
            <a href="${pageContext.request.contextPath}/admin/nail-collections/new" class="btn btn-success">Thêm Bộ Sưu Tập</a>
        </div>
    </div>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger" role="alert">
            <c:out value="${sessionScope.errorMessage}"/>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <table class="table table-bordered table-hover">
        <thead class="thead-dark">
        <tr>
            <th>ID</th>
            <th>Tên Bộ Sưu Tập</th>
            <th>Mô Tả</th>
            <th>Hành Động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="collection" items="${listCollection}">
            <tr>
                <td><c:out value="${collection.collectionId}" /></td>
                <td><c:out value="${collection.collectionName}" /></td>
                <td><c:out value="${collection.description}" /></td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/nail-collections/edit?id=<c:out value='${collection.collectionId}' />" class="btn btn-sm btn-primary">Sửa</a>
                    <a href="${pageContext.request.contextPath}/admin/nail-collections/delete?id=<c:out value='${collection.collectionId}' />" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa bộ sưu tập này không? (Các mẫu nail thuộc bộ sưu tập này sẽ không còn liên kết)')">Xóa</a>
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
</body>
</html>