<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản Lý Mẫu Nail Art - Admin Panel</title>
    <jsp:include page="_header_admin.jsp" />
    <style>
        .nail-art-img-thumbnail { max-width: 80px; max-height: 80px; object-fit: cover; border:1px solid #ddd; padding:2px; border-radius: .25rem; }
    </style>
</head>
<body>
<div class="container-fluid admin-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="admin-page-title mb-0">Danh Sách Mẫu Nail Art</h2>
        <div>
            <a href="${pageContext.request.contextPath}/admin/nail-arts/new" class="btn btn-success">Thêm Mẫu Nail Mới</a>
        </div>
    </div>

    <c:if test="${not empty param.error && param.error == 'notfound'}">
        <div class="alert alert-danger">Mẫu nail không tìm thấy.</div>
    </c:if>
    <c:if test="${not empty sessionScope.successMessage_nailart}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <c:out value="${sessionScope.successMessage_nailart}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
        </div>
        <c:remove var="successMessage_nailart" scope="session"/>
    </c:if>

    <div class="card admin-form">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped mb-0">
                    <thead class="thead-dark">
                    <tr>
                        <th>ID</th>
                        <th>Ảnh</th>
                        <th>Tên Mẫu Nail</th>
                        <th class="text-right">Giá Thêm</th>
                        <th>Bộ Sưu Tập ID</th>
                        <th class="text-center">Lượt Thích</th>
                        <th>Trạng Thái</th>
                        <th class="text-center">Hành Động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="nailArt" items="${listNailArt}">
                        <tr>
                            <td><c:out value="${nailArt.nailArtId}" /></td>
                            <td>
                                <c:if test="${not empty nailArt.imageUrl}">
                                    <img src="${pageContext.request.contextPath}/${nailArt.imageUrl}" alt="<c:out value='${nailArt.nailArtName}'/>" class="nail-art-img-thumbnail">
                                </c:if>
                                <c:if test="${empty nailArt.imageUrl}">
                                    <span>N/A</span>
                                </c:if>
                            </td>
                            <td><c:out value="${nailArt.nailArtName}" /></td>
                            <td class="text-right"><fmt:formatNumber value="${nailArt.priceAddon}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></td>
                            <td><c:out value="${nailArt.collectionId}" default="-"/></td>
                            <td class="text-center"><c:out value="${nailArt.likesCount}" /></td>
                            <td>
                                <c:if test="${nailArt.active}"><span class="badge badge-success">Hoạt động</span></c:if>
                                <c:if test="${not nailArt.active}"><span class="badge badge-danger">Không hoạt động</span></c:if>
                            </td>
                            <td class="text-center action-buttons">
                                <a href="${pageContext.request.contextPath}/admin/nail-arts/edit?id=<c:out value='${nailArt.nailArtId}' />" class="btn btn-sm btn-primary" title="Sửa">Sửa</a>
                                <a href="${pageContext.request.contextPath}/admin/nail-arts/delete?id=<c:out value='${nailArt.nailArtId}' />" class="btn btn-sm ${nailArt.active ? 'btn-warning' : 'btn-secondary'}" title="${nailArt.active ? 'Vô hiệu hóa' : 'Kích hoạt'}"
                                   onclick="return confirm('Bạn có chắc chắn muốn ${nailArt.active ? 'vô hiệu hóa' : 'kích hoạt lại'} mẫu nail này không?')">${nailArt.active ? "Vô hiệu hóa" : "Kích hoạt"}</a>
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
        </div>
    </div>
</div>
<jsp:include page="_footer_admin.jsp" />
</body>
</html>