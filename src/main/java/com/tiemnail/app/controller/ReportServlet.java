package com.tiemnail.app.controller;

import com.tiemnail.app.dao.AppointmentDAO;
import com.tiemnail.app.dao.AppointmentDetailDAO;
import com.tiemnail.app.dao.ServiceDAO;


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@WebServlet("/admin/reports/*")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    private AppointmentDetailDAO appointmentDetailDAO;
    private ServiceDAO serviceDAO;


    public void init() {
        appointmentDAO = new AppointmentDAO();
        appointmentDetailDAO = new AppointmentDetailDAO();
        serviceDAO = new ServiceDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getPathInfo();

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/reports/revenue"); // Mặc định là báo cáo doanh thu
            return;
        }

        try {
            switch (action) {
                case "/revenue":
                    showRevenueReport(request, response);
                    break;
                case "/popular-services":
                    showPopularServicesReport(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException("Lỗi cơ sở dữ liệu khi tạo báo cáo.", ex);
        } catch (ParseException e) {
            throw new ServletException("Lỗi phân tích ngày tháng khi tạo báo cáo.", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }


    private void showRevenueReport(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException, ParseException {
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String viewMode = request.getParameter("viewMode"); // daily, monthly (for chart)

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate, endDate;
        Calendar cal = Calendar.getInstance();

        if (startDateStr == null || startDateStr.isEmpty() || endDateStr == null || endDateStr.isEmpty()) {
            // Mặc định là tháng hiện tại
            cal.set(Calendar.DAY_OF_MONTH, 1);
            startDate = new Date(cal.getTimeInMillis());
            cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
            endDate = new Date(cal.getTimeInMillis());

            startDateStr = sdf.format(startDate);
            endDateStr = sdf.format(endDate);
            if (viewMode == null) viewMode = "monthly"; // Mặc định hiển thị doanh thu theo ngày của tháng
        } else {
            startDate = new Date(sdf.parse(startDateStr).getTime());
            endDate = new Date(sdf.parse(endDateStr).getTime());
            if (viewMode == null) viewMode = "range"; // Tổng doanh thu trong khoảng
        }

        if (startDate.after(endDate)) {
            request.setAttribute("reportError", "Ngày bắt đầu không được sau ngày kết thúc.");
        } else {
            if ("monthly".equals(viewMode)) {
                // Lấy năm và tháng từ startDate (hoặc endDate, hoặc chọn tháng cụ thể)
                cal.setTime(startDate);
                int year = cal.get(Calendar.YEAR);
                int month = cal.get(Calendar.MONTH) + 1; // Calendar.MONTH bắt đầu từ 0
                Map<String, BigDecimal> dailyRevenue = appointmentDAO.getDailyRevenueForMonth(year, month);
                request.setAttribute("dailyRevenueData", dailyRevenue);
                request.setAttribute("reportMonth", month);
                request.setAttribute("reportYear", year);

                BigDecimal totalMonthRevenue = BigDecimal.ZERO;
                for(BigDecimal revenue : dailyRevenue.values()){
                    totalMonthRevenue = totalMonthRevenue.add(revenue);
                }
                request.setAttribute("totalRevenue", totalMonthRevenue);

            } else { // "range" or default
                BigDecimal totalRevenue = appointmentDAO.getTotalRevenueByDateRange(startDate, endDate);
                request.setAttribute("totalRevenue", totalRevenue);
            }
        }

        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        request.setAttribute("viewMode", viewMode);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/report_revenue.jsp");
        dispatcher.forward(request, response);
    }

    private void showPopularServicesReport(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        Map<String, Integer> popularServicesData = new HashMap<>();
        Map<Integer, Integer> serviceUsage = appointmentDetailDAO.getServiceUsageCounts();
        Map<String, Integer> serviceUsageWithName = new LinkedHashMap<>();
        for(Map.Entry<Integer, Integer> entry : serviceUsage.entrySet()){
            com.tiemnail.app.model.Service service = serviceDAO.getServiceById(entry.getKey());
            if(service != null){
                serviceUsageWithName.put(service.getServiceName(), entry.getValue());
            } else {
                serviceUsageWithName.put("Dịch vụ ID: " + entry.getKey(), entry.getValue());
            }
        }


        request.setAttribute("popularServicesData", serviceUsageWithName);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/report_popular_services.jsp");
        dispatcher.forward(request, response);
    }
}