<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Mẫu Nail Art</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .nail-art-img { max-width: 100px; max-height: 100px; object-fit: cover; }
    </style>
</head>
<body>
<div class="container mt-4">
    <div class="row mb-3">
        <div class="col-md-6">
            <h2>Danh Sách Mẫu Nail Art</h2>
        </div>
        <div class="col-md-6 text-right">
            <a href="${pageContext.request.contextPath}/admin/nail-arts/new" class="btn btn-success">Thêm Mẫu Nail Mới</a>
        </div>
    </div>
    <c:if test="${not empty param.error && param.error == 'notfound'}">
        <div class="alert alert-danger">Mẫu nail không tìm thấy.</div>
    </c:if>

    <table class="table table-bordered table-hover">
        <thead class="thead-dark">
        <tr>
            <th>ID</th>
            <th>Ảnh</th>
            <th>Tên Mẫu Nail</th>
            <th>Giá Thêm</th>
            <th>Bộ Sưu Tập</th>
            <th>Lượt Thích</th>
            <th>Trạng Thái</th>
            <th>Hành Động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="nailArt" items="${listNailArt}">
            <tr>
                <td><c:out value="${nailArt.nailArtId}" /></td>
                <td>
                    <c:if test="${not empty nailArt.imageUrl}">
                        <img src="${pageContext.request.contextPath}/${nailArt.imageUrl}" alt="<c:out value='${nailArt.nailArtName}'/>" class="nail-art-img img-thumbnail">
                    </c:if>
                    <c:if test="${empty nailArt.imageUrl}">
                        <span>Không có ảnh</span>
                    </c:if>
                </td>
                <td><c:out value="${nailArt.nailArtName}" /></td>
                <td><fmt:formatNumber value="${nailArt.priceAddon}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></td>
                <td>
                    <c:if test="${not empty nailArt.collectionId}">
                        ID: <c:out value="${nailArt.collectionId}"/>
                        <%-- Thêm logic để hiển thị tên bộ sưu tập nếu cần --%>
                    </c:if>
                    <c:if test="${empty nailArt.collectionId}">-</c:if>
                </td>
                <td><c:out value="${nailArt.likesCount}" /></td>
                <td>
                    <c:if test="${nailArt.active}"><span class="badge badge-success">Hoạt động</span></c:if>
                    <c:if test="${not nailArt.active}"><span class="badge badge-danger">Không hoạt động</span></c:if>
                </td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/nail-arts/edit?id=<c:out value='${nailArt.nailArtId}' />" class="btn btn-sm btn-primary">Sửa</a>
                    <a href="${pageContext.request.contextPath}/admin/nail-arts/delete?id=<c:out value='${nailArt.nailArtId}' />" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn ${nailArt.active ? 'vô hiệu hóa' : 'kích hoạt lại'} mẫu nail này không?')">${nailArt.active ? "Vô hiệu hóa" : "Kích hoạt"}</a>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty listNailArt}">
            <tr>
                <td colspan="8" class="text-center">Không có mẫu nail nào.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
</body>
</html>