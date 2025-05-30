<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Báo Cáo Doanh Thu</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<jsp:include page="_header_admin.jsp" />
<div class="container mt-4">
  <h2>Báo Cáo Doanh Thu</h2>
  <hr/>
  <form method="get" action="${pageContext.request.contextPath}/admin/reports/revenue" class="form-inline mb-4">
    <div class="form-group mr-2">
      <label for="startDate" class="mr-2">Từ ngày:</label>
      <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}" required>
    </div>
    <div class="form-group mr-2">
      <label for="endDate" class="mr-2">Đến ngày:</label>
      <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}" required>
    </div>
    <input type="hidden" name="viewMode" value="range">
    <button type="submit" class="btn btn-primary">Xem Doanh Thu Khoảng Ngày</button>
  </form>

  <form method="get" action="${pageContext.request.contextPath}/admin/reports/revenue" class="form-inline mb-4">
    <div class="form-group mr-2">
      <label for="monthYear" class="mr-2">Xem theo tháng (YYYY-MM):</label>
      <%
        java.time.YearMonth currentYm = java.time.YearMonth.now();
        String defaultMonthInput = "";
        String currentStartDateParam = request.getParameter("startDate");
        String currentViewMode = request.getParameter("viewMode");

        if ("monthly".equals(currentViewMode) && currentStartDateParam != null && currentStartDateParam.length() >= 7) {
          defaultMonthInput = currentStartDateParam.substring(0, 7);
        } else {
          defaultMonthInput = currentYm.toString();
        }
      %>
      <input type="month" class="form-control" id="monthYear" name="startDate" value="<%= defaultMonthInput %>">
      <input type="hidden" name="viewMode" value="monthly">
    </div>
    <button type="submit" class="btn btn-info">Xem Doanh Thu Tháng</button>
  </form>


  <c:if test="${not empty reportError}">
    <div class="alert alert-danger"><c:out value="${reportError}"/></div>
  </c:if>

  <c:if test="${empty reportError}">
    <div class="card">
      <div class="card-header">
        <c:choose>
          <c:when test="${viewMode == 'monthly'}">
            Doanh thu tháng ${reportMonth}/${reportYear}
          </c:when>
          <c:otherwise>
            <fmt:parseDate value="${startDate}" pattern="yyyy-MM-dd" var="parsedStartDate"/>
            <fmt:parseDate value="${endDate}" pattern="yyyy-MM-dd" var="parsedEndDate"/>
            Doanh thu từ <fmt:formatDate value="${parsedStartDate}" pattern="dd/MM/yyyy"/> đến <fmt:formatDate value="${parsedEndDate}" pattern="dd/MM/yyyy"/>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="card-body">
        <h4 class="card-title">Tổng Doanh Thu:
          <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/>
        </h4>

        <c:if test="${viewMode == 'monthly' && not empty dailyRevenueData}">
          <h5 class="mt-4">Chi tiết doanh thu theo ngày:</h5>
          <canvas id="dailyRevenueChart" width="400" height="200"></canvas>
          <table class="table table-sm table-striped mt-3">
            <thead><tr><th>Ngày</th><th>Doanh Thu</th></tr></thead>
            <tbody>
            <c:forEach var="entry" items="${dailyRevenueData}">
              <tr>
                <fmt:parseDate value="${entry.key}" pattern="yyyy-MM-dd" var="parsedEntryDate"/>
                <td><fmt:formatDate value="${parsedEntryDate}" pattern="dd/MM/yyyy"/></td>
                <td><fmt:formatNumber value="${entry.value}" type="currency" currencySymbol="₫"/></td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </c:if>
      </div>
    </div>
  </c:if>
</div>
<jsp:include page="_footer_admin.jsp" />

<c:if test="${viewMode == 'monthly' && not empty dailyRevenueData}">
  <script>
    const dailyCtx = document.getElementById('dailyRevenueChart').getContext('2d');
    const dailyLabels = [];
    const dailyDataPoints = [];
    <c:forEach var="entry" items="${dailyRevenueData}">
    <fmt:parseDate value="${entry.key}" pattern="yyyy-MM-dd" var="parsedChartDateForLabel"/>
    dailyLabels.push('<fmt:formatDate value="${parsedChartDateForLabel}" pattern="dd/MM"/>');
    dailyDataPoints.push(${entry.value});
    </c:forEach>

    new Chart(dailyCtx, {
      type: 'bar',
      data: {
        labels: dailyLabels,
        datasets: [{
          label: 'Doanh thu hàng ngày (₫)',
          data: dailyDataPoints,
          backgroundColor: 'rgba(54, 162, 235, 0.6)',
          borderColor: 'rgba(54, 162, 235, 1)',
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: function(value, index, values) {
                return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
              }
            }
          }
        }
      }
    });
  </script>
</c:if>
</body>
</html>