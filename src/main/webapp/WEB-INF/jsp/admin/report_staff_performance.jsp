<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Báo Cáo Hiệu Suất Nhân Viên - Admin Panel</title>
    <jsp:include page="_header_admin.jsp" />
</head>
<body>
<div class="container-fluid admin-container">
    <h2 class="admin-page-title">Báo Cáo Hiệu Suất Nhân Viên</h2>

    <div class="card admin-form mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin/reports/staff-performance" class="form-row align-items-end">
                <div class="col-md-5 form-group mb-md-0">
                    <label for="startDate">Từ ngày:</label>
                    <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}" required>
                </div>
                <div class="col-md-5 form-group mb-md-0">
                    <label for="endDate">Đến ngày:</label>
                    <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}" required>
                </div>
                <div class="col-md-2 form-group mb-md-0">
                    <button type="submit" class="btn btn-primary btn-block">Xem</button>
                </div>
            </form>
        </div>
    </div>

    <c:if test="${not empty reportError}">
        <div class="alert alert-danger"><c:out value="${reportError}"/></div>
    </c:if>

    <c:if test="${empty reportError}">
        <div class="card admin-form">
            <div class="card-header">
                Kết quả từ <fmt:parseDate value="${startDate}" pattern="yyyy-MM-dd" var="pStartDate"/><fmt:formatDate value="${pStartDate}" pattern="dd/MM/yyyy"/>
                đến <fmt:parseDate value="${endDate}" pattern="yyyy-MM-dd" var="pEndDate"/><fmt:formatDate value="${pEndDate}" pattern="dd/MM/yyyy"/>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0">
                        <thead class="thead-dark">
                        <tr>
                            <th>ID Nhân Viên</th>
                            <th>Tên Nhân Viên</th>
                            <th class="text-center">Số Lịch Hoàn Tất</th>
                            <th class="text-right">Tổng Doanh Thu</th>
                            <th class="text-center">Đánh Giá TB</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="perf" items="${staffPerformanceList}">
                            <tr>
                                <td><c:out value="${perf.staffId}"/></td>
                                <td><c:out value="${perf.staffName}"/></td>
                                <td class="text-center"><c:out value="${perf.completedAppointments}"/></td>
                                <td class="text-right"><fmt:formatNumber value="${perf.totalRevenue}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></td>
                                <td class="text-center">
                                    <c:if test="${not empty perf.averageRating && perf.averageRating > 0}">
                                        <fmt:formatNumber value="${perf.averageRating}" minFractionDigits="1" maxFractionDigits="2"/> <span class="text-warning">★</span>
                                    </c:if>
                                    <c:if test="${empty perf.averageRating || perf.averageRating == 0}">Chưa có</c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty staffPerformanceList}">
                            <tr>
                                <td colspan="5" class="text-center">Không có dữ liệu hiệu suất nhân viên cho khoảng thời gian đã chọn.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </c:if>
</div>
<jsp:include page="_footer_admin.jsp" />
</body>
</html>