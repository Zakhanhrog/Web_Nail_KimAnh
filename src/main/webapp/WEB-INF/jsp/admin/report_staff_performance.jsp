<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo Hiệu Suất Nhân Viên</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="_header_admin.jsp" />
<div class="container mt-4">
    <h2>Báo Cáo Hiệu Suất Nhân Viên</h2>
    <hr/>
    <form method="get" action="${pageContext.request.contextPath}/admin/reports/staff-performance" class="form-inline mb-4">
        <div class="form-group mr-2">
            <label for="startDate" class="mr-2">Từ ngày:</label>
            <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}" required>
        </div>
        <div class="form-group mr-2">
            <label for="endDate" class="mr-2">Đến ngày:</label>
            <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}" required>
        </div>
        <button type="submit" class="btn btn-primary">Xem Báo Cáo</button>
    </form>

    <c:if test="${not empty reportError}">
        <div class="alert alert-danger"><c:out value="${reportError}"/></div>
    </c:if>

    <c:if test="${empty reportError}">
        <c:choose>
            <c:when test="${not empty staffPerformanceList}">
                <table class="table table-striped table-hover">
                    <thead class="thead-dark">
                    <tr>
                        <th>ID Nhân Viên</th>
                        <th>Tên Nhân Viên</th>
                        <th>Số Lịch Hoàn Tất</th>
                        <th>Tổng Doanh Thu</th>
                        <th>Đánh Giá TB</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="perf" items="${staffPerformanceList}">
                        <tr>
                            <td><c:out value="${perf.staffId}"/></td>
                            <td><c:out value="${perf.staffName}"/></td>
                            <td><c:out value="${perf.completedAppointments}"/></td>
                            <td><fmt:formatNumber value="${perf.totalRevenue}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></td>
                            <td>
                                <c:if test="${not empty perf.averageRating}">
                                    <fmt:formatNumber value="${perf.averageRating}" minFractionDigits="1" maxFractionDigits="2"/> <span class="text-warning">★</span>
                                </c:if>
                                <c:if test="${empty perf.averageRating}">Chưa có</c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info">Không có dữ liệu hiệu suất nhân viên cho khoảng thời gian đã chọn.</div>
            </c:otherwise>
        </c:choose>
    </c:if>
</div>
<jsp:include page="_footer_admin.jsp" />
</body>
</html>