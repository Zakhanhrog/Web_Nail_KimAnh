<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo Dịch Vụ Phổ Biến</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<jsp:include page="_header_admin.jsp" />
<div class="container mt-4">
    <h2>Báo Cáo Dịch Vụ Phổ Biến</h2>
    <p class="text-muted">(Dựa trên số lượt đặt trong các lịch hẹn đã hoàn thành)</p>
    <hr/>

    <c:if test="${empty popularServicesData}">
        <div class="alert alert-info">Chưa có đủ dữ liệu để tạo báo cáo dịch vụ phổ biến.</div>
    </c:if>

    <c:if test="${not empty popularServicesData}">
        <div class="row">
            <div class="col-md-6">
                <h4>Danh sách</h4>
                <table class="table table-striped table-sm">
                    <thead class="thead-light">
                    <tr>
                        <th>Tên Dịch Vụ</th>
                        <th>Số Lượt Đặt</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="entry" items="${popularServicesData}">
                        <tr>
                            <td><c:out value="${entry.key}"/></td>
                            <td><c:out value="${entry.value}"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="col-md-6">
                <h4>Biểu đồ</h4>
                <canvas id="popularServicesChart" width="400" height="300"></canvas>
            </div>
        </div>
    </c:if>
</div>
<jsp:include page="_footer_admin.jsp" />

<c:if test="${not empty popularServicesData}">
    <script>
        const popularCtx = document.getElementById('popularServicesChart').getContext('2d');
        const serviceLabels = [];
        const serviceData = [];
        <c:forEach var="entry" items="${popularServicesData}">
        serviceLabels.push("${entry.key}".replace(/'/g, "\\'")); // Escape single quotes for JS string
        serviceData.push(${entry.value});
        </c:forEach>

        new Chart(popularCtx, {
            type: 'pie', // Hoặc 'doughnut' hoặc 'bar'
            data: {
                labels: serviceLabels,
                datasets: [{
                    label: 'Số lượt đặt',
                    data: serviceData,
                    backgroundColor: [ // Thêm màu cho đẹp hơn
                        'rgba(255, 99, 132, 0.7)',
                        'rgba(54, 162, 235, 0.7)',
                        'rgba(255, 206, 86, 0.7)',
                        'rgba(75, 192, 192, 0.7)',
                        'rgba(153, 102, 255, 0.7)',
                        'rgba(255, 159, 64, 0.7)',
                        'rgba(199, 199, 199, 0.7)',
                        'rgba(83, 102, 89, 0.7)',
                        'rgba(140, 159, 119, 0.7)',
                        'rgba(213,76,90, 0.7)'
                    ],
                    borderColor: '#fff',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                        text: 'Tỷ lệ sử dụng dịch vụ'
                    }
                }
            }
        });
    </script>
</c:if>
</body>
</html>