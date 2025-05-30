package com.tiemnail.app.controller;

import com.tiemnail.app.dao.AppointmentDAO;
import com.tiemnail.app.dao.AppointmentDetailDAO;
import com.tiemnail.app.dao.ServiceDAO;
import com.tiemnail.app.dao.CustomerDAO;
import com.tiemnail.app.dto.StaffPerformanceDTO;
import com.tiemnail.app.dto.CustomerLoyaltyDTO;


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
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;


@WebServlet("/admin/reports/*")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    private AppointmentDetailDAO appointmentDetailDAO;
    private ServiceDAO serviceDAO;
    private CustomerDAO customerDAO;


    public void init() {
        appointmentDAO = new AppointmentDAO();
        appointmentDetailDAO = new AppointmentDetailDAO();
        serviceDAO = new ServiceDAO();
        customerDAO = new CustomerDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getPathInfo();

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/reports/revenue");
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
                case "/staff-performance":
                    showStaffPerformanceReport(request, response);
                    break;
                case "/loyal-customers":
                    showLoyalCustomersReport(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(); // In ra console để debug
            throw new ServletException("Lỗi cơ sở dữ liệu khi tạo báo cáo: " + ex.getMessage(), ex);
        } catch (ParseException e) {
            e.printStackTrace(); // In ra console để debug
            throw new ServletException("Lỗi phân tích ngày tháng khi tạo báo cáo: " + e.getMessage(), e);
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
        String viewMode = request.getParameter("viewMode");

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate, endDate;
        Calendar cal = Calendar.getInstance();

        if (startDateStr == null || startDateStr.isEmpty() || ("monthly".equals(viewMode) && startDateStr.length() < 7) ) {
            cal.set(Calendar.DAY_OF_MONTH, 1);
            startDate = new Date(cal.getTimeInMillis());
            cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
            endDate = new Date(cal.getTimeInMillis());

            startDateStr = sdf.format(startDate);
            // endDateStr sẽ được tính lại nếu viewMode là monthly, hoặc giữ nguyên nếu là lần đầu load
            if (!"monthly".equals(viewMode) && (endDateStr == null || endDateStr.isEmpty())) {
                endDateStr = sdf.format(endDate);
            }
            if (viewMode == null) viewMode = "monthly";
        } else {
            if ("monthly".equals(viewMode)) {
                // Input type="month" sẽ gửi về "YYYY-MM", ta cần ngày đầu và cuối tháng đó
                String[] yearMonth = startDateStr.split("-");
                cal.set(Calendar.YEAR, Integer.parseInt(yearMonth[0]));
                cal.set(Calendar.MONTH, Integer.parseInt(yearMonth[1]) - 1); // Calendar.MONTH là 0-indexed
                cal.set(Calendar.DAY_OF_MONTH, 1);
                startDate = new Date(cal.getTimeInMillis());
                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                endDate = new Date(cal.getTimeInMillis());
                startDateStr = sdf.format(startDate); // Cập nhật lại startDateStr cho đúng ngày đầu tháng
                endDateStr = sdf.format(endDate);     // Cập nhật endDateStr cho đúng ngày cuối tháng
            } else { // viewMode là "range"
                startDate = new Date(sdf.parse(startDateStr).getTime());
                if (endDateStr == null || endDateStr.isEmpty()){ // Nếu chỉ có startDate cho range
                    endDate = startDate; // Mặc định endDate bằng startDate
                    endDateStr = startDateStr;
                } else {
                    endDate = new Date(sdf.parse(endDateStr).getTime());
                }
            }
        }


        if (startDate.after(endDate)) {
            request.setAttribute("reportError", "Ngày bắt đầu không được sau ngày kết thúc.");
        } else {
            if ("monthly".equals(viewMode)) {
                cal.setTime(startDate); // startDate đã là ngày đầu tháng
                int year = cal.get(Calendar.YEAR);
                int month = cal.get(Calendar.MONTH) + 1;
                Map<String, BigDecimal> dailyRevenue = appointmentDAO.getDailyRevenueForMonth(year, month);
                request.setAttribute("dailyRevenueData", dailyRevenue);
                request.setAttribute("reportMonth", month);
                request.setAttribute("reportYear", year);

                BigDecimal totalMonthRevenue = BigDecimal.ZERO;
                for(BigDecimal revenue : dailyRevenue.values()){
                    totalMonthRevenue = totalMonthRevenue.add(revenue);
                }
                request.setAttribute("totalRevenue", totalMonthRevenue);

            } else {
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
        Map<Integer, Integer> serviceUsage = appointmentDetailDAO.getServiceUsageCounts();
        Map<String, Integer> serviceUsageWithName = new LinkedHashMap<>();
        for(Map.Entry<Integer, Integer> entry : serviceUsage.entrySet()){
            com.tiemnail.app.model.Service service = serviceDAO.getServiceById(entry.getKey());
            if(service != null){
                serviceUsageWithName.put(service.getServiceName(), entry.getValue());
            } else {
                serviceUsageWithName.put("Dịch vụ ID: " + entry.getKey() + " (Đã xóa)", entry.getValue());
            }
        }

        request.setAttribute("popularServicesData", serviceUsageWithName);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/report_popular_services.jsp");
        dispatcher.forward(request, response);
    }

    private void showStaffPerformanceReport(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException, ParseException {
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate, endDate;
        Calendar cal = Calendar.getInstance();

        if (startDateStr == null || startDateStr.isEmpty() || endDateStr == null || endDateStr.isEmpty()) {
            cal.add(Calendar.DAY_OF_MONTH, -29);
            startDate = new Date(cal.getTimeInMillis());
            endDate = new Date(Calendar.getInstance().getTimeInMillis());

            startDateStr = sdf.format(startDate);
            endDateStr = sdf.format(endDate);
        } else {
            startDate = new Date(sdf.parse(startDateStr).getTime());
            endDate = new Date(sdf.parse(endDateStr).getTime());
        }

        if (startDate.after(endDate)) {
            request.setAttribute("reportError", "Ngày bắt đầu không được sau ngày kết thúc.");
        } else {
            List<StaffPerformanceDTO> staffPerformanceList = appointmentDAO.getStaffPerformanceByDateRange(startDate, endDate);
            request.setAttribute("staffPerformanceList", staffPerformanceList);
        }

        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/report_staff_performance.jsp");
        dispatcher.forward(request, response);
    }

    private void showLoyalCustomersReport(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String orderBy = request.getParameter("orderBy");
        String limitStr = request.getParameter("limit");
        int limit = 10;

        if (orderBy == null || (!orderBy.equals("total_visits") && !orderBy.equals("total_spent"))) {
            orderBy = "total_visits";
        }
        if(limitStr != null && !limitStr.isEmpty()){
            try {
                limit = Integer.parseInt(limitStr);
                if(limit <=0) limit = 10;
            } catch (NumberFormatException e){
                limit = 10;
            }
        }

        List<CustomerLoyaltyDTO> loyalCustomersList = this.customerDAO.getLoyalCustomers(limit, orderBy);

        request.setAttribute("loyalCustomersList", loyalCustomersList);
        request.setAttribute("currentOrderBy", orderBy);
        request.setAttribute("currentLimit", limit);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/report_loyal_customers.jsp");
        dispatcher.forward(request, response);
    }
}