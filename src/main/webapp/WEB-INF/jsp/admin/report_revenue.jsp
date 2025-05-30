<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Báo Cáo Doanh Thu - Admin Panel</title>
  <jsp:include page="_header_admin.jsp" />
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="container-fluid admin-container">
  <h2 class="admin-page-title">Báo Cáo Doanh Thu</h2>

  <div class="card admin-form mb-4">
    <div class="card-body">
      <form method="get" action="${pageContext.request.contextPath}/admin/reports/revenue" class="form-row align-items-end">
        <div class="col-md-4 form-group mb-md-0">
          <label for="startDate">Từ ngày:</label>
          <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}" required>
        </div>
        <div class="col-md-4 form-group mb-md-0">
          <label for="endDate">Đến ngày:</label>
          <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}" required>
        </div>
        <input type="hidden" name="viewMode" value="range">
        <div class="col-md-2 form-group mb-md-0">
          <button type="submit" class="btn btn-primary btn-block">Lọc Theo Khoảng</button>
        </div>
      </form>
      <hr>
      <form method="get" action="${pageContext.request.contextPath}/admin/reports/revenue" class="form-row align-items-end">
        <div class="col-md-4 form-group mb-md-0">
          <label for="monthYear">Xem theo tháng (YYYY-MM):</label>
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
        <div class="col-md-2 form-group mb-md-0">
          <button type="submit" class="btn btn-info btn-block">Lọc Theo Tháng</button>
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
        <h3 class="card-title text-center mb-4">Tổng Doanh Thu:
          <span class="text-success font-weight-bold"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/></span>
        </h3>

        <c:if test="${viewMode == 'monthly' && not empty dailyRevenueData}">
          <h5 class="mt-4 text-center">Biểu đồ chi tiết doanh thu theo ngày:</h5>
          <div style="max-width: 800px; margin: auto;">
            <canvas id="dailyRevenueChart"></canvas>
          </div>
          <h5 class="mt-5">Bảng dữ liệu:</h5>
          <div class="table-responsive">
            <table class="table table-sm table-striped mt-3">
              <thead class="thead-light"><tr><th>Ngày</th><th class="text-right">Doanh Thu</th></tr></thead>
              <tbody>
              <c:forEach var="entry" items="${dailyRevenueData}">
                <tr>
                  <fmt:parseDate value="${entry.key}" pattern="yyyy-MM-dd" var="parsedEntryDate"/>
                  <td><fmt:formatDate value="${parsedEntryDate}" pattern="dd/MM/yyyy"/></td>
                  <td class="text-right"><fmt:formatNumber value="${entry.value}" type="currency" currencySymbol="₫"/></td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </c:if>
      </div>
    </div>
  </c:if>
</div>
<jsp:include page="_footer_admin.jsp" />

<c:if test="${viewMode == 'monthly' && not empty dailyRevenueData}">
  <script>
    document.addEventListener('DOMContentLoaded', function () {
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
            backgroundColor: 'rgba(75, 192, 192, 0.6)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 1
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: {
              beginAtZero: true,
              ticks: {
                callback: function(value, index, values) {
                  return new Intl.NumberFormat('vi-VN').format(value) + ' ₫';
                }
              }
            }
          }
        }
      });
    });
  </script>
</c:if>
</body>
</html>