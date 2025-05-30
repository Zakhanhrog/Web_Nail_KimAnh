<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Báo Cáo Dịch Vụ Phổ Biến - Admin Panel</title>
    <jsp:include page="_header_admin.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> <%-- Đảm bảo Chart.js được include --%>
</head>
<body>
<div class="container-fluid admin-container">
    <h2 class="admin-page-title">Báo Cáo Dịch Vụ Phổ Biến</h2>
    <p class="text-muted mb-4">(Dựa trên số lượt đặt trong các lịch hẹn đã hoàn thành)</p>

    <c:if test="${empty popularServicesData}">
        <div class="alert alert-info">Chưa có đủ dữ liệu để tạo báo cáo dịch vụ phổ biến.</div>
    </c:if>

    <c:if test="${not empty popularServicesData}">
        <div class="row">
            <div class="col-md-5">
                <div class="card admin-form">
                    <div class="card-header">Danh sách dịch vụ và số lượt đặt</div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-striped table-sm mb-0">
                                <thead class="thead-light">
                                <tr>
                                    <th>Tên Dịch Vụ</th>
                                    <th class="text-right">Số Lượt Đặt</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="entry" items="${popularServicesData}">
                                    <tr>
                                        <td><c:out value="${entry.key}"/></td>
                                        <td class="text-right"><c:out value="${entry.value}"/></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-7">
                <div class="card admin-form">
                    <div class="card-header">Biểu đồ tỷ lệ sử dụng dịch vụ</div>
                    <div class="card-body">
                        <canvas id="popularServicesChart" style="max-height: 400px;"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>
<jsp:include page="_footer_admin.jsp" />

<c:if test="${not empty popularServicesData}">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const popularCtx = document.getElementById('popularServicesChart').getContext('2d');
            const serviceLabels = [];
            const serviceData = [];
            const backgroundColors = [
                'rgba(255, 99, 132, 0.7)', 'rgba(54, 162, 235, 0.7)', 'rgba(255, 206, 86, 0.7)',
                'rgba(75, 192, 192, 0.7)', 'rgba(153, 102, 255, 0.7)', 'rgba(255, 159, 64, 0.7)',
                'rgba(199, 199, 199, 0.7)', 'rgba(83, 102, 89, 0.7)', 'rgba(140, 159, 119, 0.7)',
                'rgba(213,76,90, 0.7)', 'rgba(255, 118, 163, 0.7)', 'rgba(79, 183, 244, 0.7)'
            ]; // Thêm màu nếu cần

            let colorIndex = 0;
            <c:forEach var="entry" items="${popularServicesData}">
            serviceLabels.push("${entry.key}".replace(/'/g, "\\'").replace(/"/g, '\\"'));
            serviceData.push(${entry.value});
            </c:forEach>

            new Chart(popularCtx, {
                type: 'doughnut',
                data: {
                    labels: serviceLabels,
                    datasets: [{
                        label: 'Số lượt đặt',
                        data: serviceData,
                        backgroundColor: serviceData.map((_, i) => backgroundColors[i % backgroundColors.length]),
                        borderColor: '#fff',
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right',
                        },
                        title: {
                            display: true,
                            text: 'Tỷ lệ sử dụng dịch vụ',
                            font: { size: 16 }
                        }
                    }
                }
            });
        });
    </script>
</c:if>
</body>
</html>