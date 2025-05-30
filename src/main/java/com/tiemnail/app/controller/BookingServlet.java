package com.tiemnail.app.controller;

import com.tiemnail.app.dao.ServiceDAO;
import com.tiemnail.app.dao.NailArtDAO;
import com.tiemnail.app.dao.UserDAO;
import com.tiemnail.app.dao.StaffScheduleDAO;
import com.tiemnail.app.dao.AppointmentDAO;
import com.tiemnail.app.dao.AppointmentDetailDAO;
import java.io.Serial;
import com.tiemnail.app.model.Service;
import com.tiemnail.app.model.NailArt;
import com.tiemnail.app.model.User;
import com.tiemnail.app.model.StaffSchedule;
import com.tiemnail.app.model.Appointment;
import com.tiemnail.app.model.AppointmentDetail;


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@WebServlet("/customer/book-appointment/*")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ServiceDAO serviceDAO;
    private NailArtDAO nailArtDAO;
    private UserDAO userDAO;
    private StaffScheduleDAO staffScheduleDAO;
    private AppointmentDAO appointmentDAO;
    private AppointmentDetailDAO appointmentDetailDAO;


    public void init() {
        serviceDAO = new ServiceDAO();
        nailArtDAO = new NailArtDAO();
        userDAO = new UserDAO();
        staffScheduleDAO = new StaffScheduleDAO();
        appointmentDAO = new AppointmentDAO();
        appointmentDetailDAO = new AppointmentDetailDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
            return;
        }
        User loggedInCustomer = (User) session.getAttribute("loggedInUser");
        if (!"customer".equals(loggedInCustomer.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ khách hàng mới được đặt lịch.");
            return;
        }


        String action = request.getPathInfo();
        if (action == null || action.equals("/")) {
            action = "/form";
        }

        try {
            switch (action) {
                case "/form":
                    showBookingForm(request, response);
                    break;
                case "/get-available-slots": // AJAX call
                    getAvailableSlots(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            throw new ServletException("Lỗi cơ sở dữ liệu khi xử lý đặt lịch.", ex);
        } catch (ParseException e) {
            e.printStackTrace();
            throw new ServletException("Lỗi phân tích ngày giờ khi xử lý đặt lịch.", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User loggedInCustomer = (User) session.getAttribute("loggedInUser");
        if (!"customer".equals(loggedInCustomer.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ khách hàng mới được đặt lịch.");
            return;
        }

        String action = request.getPathInfo();
        if (action == null) {
            action = "/submit";
        }

        try {
            if ("/submit".equals(action)) {
                processBookingSubmission(request, response, loggedInCustomer);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ.");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("bookingErrorMessage", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            showBookingFormOnError(request, response);
        } catch (ParseException ex) {
            ex.printStackTrace();
            request.setAttribute("bookingErrorMessage", "Lỗi định dạng ngày/giờ: " + ex.getMessage());
            showBookingFormOnError(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("bookingErrorMessage", "Đã có lỗi xảy ra: " + ex.getMessage());
            showBookingFormOnError(request, response);
        }
    }


    private void loadCommonDataForBookingForm(HttpServletRequest request) throws SQLException {
        List<Service> serviceList = serviceDAO.getAllServices(true);
        List<NailArt> nailArtList = nailArtDAO.getAllNailArts(true);
        List<User> staffList = userDAO.getUsersByRole("staff");
        staffList.addAll(userDAO.getUsersByRole("admin"));
        staffList.addAll(userDAO.getUsersByRole("cashier"));


        request.setAttribute("serviceList", serviceList);
        request.setAttribute("nailArtList", nailArtList);
        request.setAttribute("staffList", staffList);
    }

    private void showBookingFormOnError(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        try {
            loadCommonDataForBookingForm(request);
        } catch (SQLException e) {
            throw new ServletException("Lỗi tải dữ liệu cho form đặt lịch", e);
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/booking_form.jsp");
        dispatcher.forward(request, response);
    }


    private void showBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        loadCommonDataForBookingForm(request);

        String preSelectedServiceId = request.getParameter("serviceId");
        if(preSelectedServiceId != null && !preSelectedServiceId.isEmpty()){
            try{
                request.setAttribute("preSelectedServiceId", Integer.parseInt(preSelectedServiceId));
            } catch (NumberFormatException e) { /* Bỏ qua nếu không phải số */ }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/booking_form.jsp");
        dispatcher.forward(request, response);
    }

    private void processBookingSubmission(HttpServletRequest request, HttpServletResponse response, User customer)
            throws SQLException, IOException, ParseException, ServletException {

        String[] selectedServiceIds = request.getParameterValues("selectedServiceIds");
        String selectedDateStr = request.getParameter("selectedDate");
        String selectedTimeStr = request.getParameter("selectedTime"); // HH:mm
        String staffIdStr = request.getParameter("staffId");
        String customerNotes = request.getParameter("customerNotes");

        if (selectedServiceIds == null || selectedServiceIds.length == 0) {
            request.setAttribute("bookingErrorMessage", "Vui lòng chọn ít nhất một dịch vụ.");
            showBookingFormOnError(request, response);
            return;
        }
        if (selectedDateStr == null || selectedDateStr.isEmpty() || selectedTimeStr == null || selectedTimeStr.isEmpty()) {
            request.setAttribute("bookingErrorMessage", "Vui lòng chọn ngày và giờ hẹn.");
            showBookingFormOnError(request, response);
            return;
        }

        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Date selectedDateTimeUtil = dateTimeFormat.parse(selectedDateStr + " " + selectedTimeStr);
        Timestamp appointmentTimestamp = new Timestamp(selectedDateTimeUtil.getTime());

        if(appointmentTimestamp.before(new Timestamp(System.currentTimeMillis()))){
            request.setAttribute("bookingErrorMessage", "Không thể đặt lịch cho thời gian trong quá khứ.");
            showBookingFormOnError(request, response);
            return;
        }

        Integer staffId = null;
        if (staffIdStr != null && !staffIdStr.isEmpty() && !staffIdStr.equals("0")) {
            staffId = Integer.parseInt(staffIdStr);
        }

        List<AppointmentDetail> details = new ArrayList<>();
        BigDecimal totalBasePrice = BigDecimal.ZERO;
        BigDecimal totalAddonPrice = BigDecimal.ZERO;
        int totalDurationMinutes = 0;

        for (String serviceIdStr : selectedServiceIds) {
            int serviceId = Integer.parseInt(serviceIdStr);
            Service service = serviceDAO.getServiceById(serviceId);
            if (service == null || !service.isActive()) continue;

            AppointmentDetail detail = new AppointmentDetail();
            detail.setServiceId(serviceId);
            detail.setServicePriceAtBooking(service.getPrice());
            detail.setQuantity(1);

            totalBasePrice = totalBasePrice.add(service.getPrice());
            totalDurationMinutes += service.getDurationMinutes();

            String nailArtIdParamName = "nailArtForService_" + serviceId;
            String nailArtIdStr = request.getParameter(nailArtIdParamName);
            if (nailArtIdStr != null && !nailArtIdStr.isEmpty() && !nailArtIdStr.equals("0")) {
                int nailArtId = Integer.parseInt(nailArtIdStr);
                NailArt nailArt = nailArtDAO.getNailArtById(nailArtId);
                if (nailArt != null && nailArt.isActive()) {
                    detail.setNailArtId(nailArtId);
                    detail.setNailArtPriceAtBooking(nailArt.getPriceAddon());
                    totalAddonPrice = totalAddonPrice.add(nailArt.getPriceAddon());
                } else {
                    detail.setNailArtPriceAtBooking(BigDecimal.ZERO);
                }
            } else {
                detail.setNailArtPriceAtBooking(BigDecimal.ZERO);
            }
            details.add(detail);
        }

        if (details.isEmpty()) {
            request.setAttribute("bookingErrorMessage", "Không có dịch vụ hợp lệ nào được chọn.");
            showBookingFormOnError(request, response);
            return;
        }

        Appointment appointment = new Appointment();
        appointment.setCustomerId(customer.getUserId());
        appointment.setStaffId(staffId);
        appointment.setAppointmentDatetime(appointmentTimestamp);
        appointment.setEstimatedDurationMinutes(totalDurationMinutes);
        appointment.setStatus("pending_confirmation");
        appointment.setTotalBasePrice(totalBasePrice);
        appointment.setTotalAddonPrice(totalAddonPrice);
        appointment.setDiscountAmount(BigDecimal.ZERO);
        appointment.setCustomerNotes(customerNotes);

        int newAppointmentId = appointmentDAO.addAppointment(appointment, details);

        if (newAppointmentId > 0) {
            response.sendRedirect(request.getContextPath() + "/customer/booking-success?appointmentId=" + newAppointmentId);
        } else {
            request.setAttribute("bookingErrorMessage", "Không thể tạo lịch hẹn. Có thể do lịch đã đầy hoặc lỗi hệ thống. Vui lòng thử lại sau.");
            showBookingFormOnError(request, response);
        }
    }


    private void getAvailableSlots(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ParseException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String dateStr = request.getParameter("date"); // yyyy-MM-dd
        String staffIdStr = request.getParameter("staffId"); // Tùy chọn
        // String totalDurationStr = request.getParameter("duration"); // Tổng thời gian các dịch vụ đã chọn (phút)

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.sql.Date selectedDate = new java.sql.Date(sdf.parse(dateStr).getTime());

        Integer staffId = null;
        if (staffIdStr != null && !staffIdStr.isEmpty() && !staffIdStr.equals("0")) {
            staffId = Integer.parseInt(staffIdStr);
        }

        List<String> availableTimeSlots = new ArrayList<>();
        List<StaffSchedule> staffSchedules;

        if (staffId != null) {
            User staffUser = userDAO.getUserById(staffId);
            if (staffUser == null || !staffUser.isActive() || !("staff".equals(staffUser.getRole()) || "admin".equals(staffUser.getRole()) || "cashier".equals(staffUser.getRole()))) {
                response.getWriter().write("{\"error\":\"Nhân viên không hợp lệ.\"}");
                return;
            }
            staffSchedules = staffScheduleDAO.getSchedulesByStaffIdAndDate(staffId, selectedDate); // Cần thêm phương thức này vào DAO
        } else {
            staffSchedules = staffScheduleDAO.getAvailableSchedulesByDate(selectedDate);
        }

        List<Appointment> existingAppointments = appointmentDAO.getAppointmentsByDate(selectedDate);

        // Logic tính toán slot trống rất phức tạp, đây là ví dụ đơn giản hóa
        // Cần xem xét: giờ làm việc, các lịch hẹn đã có, thời gian nghỉ giữa các ca, thời gian dịch vụ
        // Giả sử mỗi slot cách nhau 30 phút và chỉ kiểm tra lịch làm việc của nhân viên (nếu được chọn)

        Map<Integer, List<TimeRange>> staffBookedSlots = new HashMap<>();
        for (Appointment app : existingAppointments) {
            if (app.getStaffId() != null) {
                staffBookedSlots.computeIfAbsent(app.getStaffId(), k -> new ArrayList<>())
                        .add(new TimeRange(app.getAppointmentDatetime(), app.getEstimatedDurationMinutes()));
            }
        }

        for (StaffSchedule schedule : staffSchedules) {
            if (!schedule.isAvailable()) continue;

            Calendar cal = Calendar.getInstance();
            cal.setTime(schedule.getStartTime());
            Time slotTime = new Time(cal.getTimeInMillis());

            while (slotTime.before(schedule.getEndTime())) {
                boolean isBooked = false;
                List<TimeRange> bookedRanges = staffBookedSlots.get(schedule.getStaffId());
                if(bookedRanges != null){
                    for(TimeRange booked : bookedRanges){
                        if(booked.overlaps(slotTime, 30)){ // Giả sử thời gian dịch vụ tối thiểu là 30p
                            isBooked = true;
                            break;
                        }
                    }
                }

                if(!isBooked){
                    // Chỉ thêm slot nếu nó nằm trong tương lai gần (vd: sau 1 tiếng kể từ bây giờ)
                    Calendar slotCalCheck = Calendar.getInstance();
                    slotCalCheck.setTime(selectedDate);
                    String[] timeParts = new SimpleDateFormat("HH:mm").format(slotTime).split(":");
                    slotCalCheck.set(Calendar.HOUR_OF_DAY, Integer.parseInt(timeParts[0]));
                    slotCalCheck.set(Calendar.MINUTE, Integer.parseInt(timeParts[1]));

                    Calendar nowPlusBuffer = Calendar.getInstance();
                    nowPlusBuffer.add(Calendar.HOUR_OF_DAY, 1); // Buffer 1 tiếng

                    if(slotCalCheck.after(nowPlusBuffer)){
                        availableTimeSlots.add(new SimpleDateFormat("HH:mm").format(slotTime));
                    }
                }
                cal.add(Calendar.MINUTE, 30); // Bước nhảy slot
                slotTime.setTime(cal.getTimeInMillis());
            }
        }

        // Loại bỏ trùng lặp và sắp xếp (nếu cần từ nhiều nhân viên)
        List<String> uniqueSortedSlots = new ArrayList<>(new HashSet<>(availableTimeSlots));
        java.util.Collections.sort(uniqueSortedSlots);


        // Chuyển thành JSON (cần thư viện JSON như Gson hoặc Jackson, hoặc tự build chuỗi JSON đơn giản)
        StringBuilder jsonResponse = new StringBuilder("{\"slots\":[");
        for (int i = 0; i < uniqueSortedSlots.size(); i++) {
            jsonResponse.append("\"").append(uniqueSortedSlots.get(i)).append("\"");
            if (i < uniqueSortedSlots.size() - 1) {
                jsonResponse.append(",");
            }
        }
        jsonResponse.append("]}");
        response.getWriter().write(jsonResponse.toString());
    }

    // Lớp tiện ích nội bộ để biểu diễn khoảng thời gian
    private static class TimeRange {
        Timestamp start;
        Timestamp end;

        TimeRange(Timestamp appointmentTime, int durationMinutes) {
            this.start = appointmentTime;
            Calendar cal = Calendar.getInstance();
            cal.setTimeInMillis(appointmentTime.getTime());
            cal.add(Calendar.MINUTE, durationMinutes);
            this.end = new Timestamp(cal.getTimeInMillis());
        }
        // Kiểm tra xem một slot (slotStartTime với duration) có chồng lấn với khoảng này không
        boolean overlaps(Time slotStartTime, int slotDurationMinutes) {
            Calendar slotStartCal = Calendar.getInstance();
            slotStartCal.setTime(this.start); // Lấy ngày từ this.start
            String[] timeParts = new SimpleDateFormat("HH:mm").format(slotStartTime).split(":");
            slotStartCal.set(Calendar.HOUR_OF_DAY, Integer.parseInt(timeParts[0]));
            slotStartCal.set(Calendar.MINUTE, Integer.parseInt(timeParts[1]));
            slotStartCal.set(Calendar.SECOND, 0);
            slotStartCal.set(Calendar.MILLISECOND, 0);

            Timestamp slotStartTimestamp = new Timestamp(slotStartCal.getTimeInMillis());

            Calendar slotEndCal = (Calendar) slotStartCal.clone();
            slotEndCal.add(Calendar.MINUTE, slotDurationMinutes);
            Timestamp slotEndTimestamp = new Timestamp(slotEndCal.getTimeInMillis());

            return slotStartTimestamp.before(this.end) && slotEndTimestamp.after(this.start);
        }
    }
}