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
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@WebServlet("/customer/book-appointment/*")
public class BookingServlet extends HttpServlet {
    @Serial
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
        System.out.println("BookingServlet initialized.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        System.out.println("BookingServlet doGet called. PathInfo: " + request.getPathInfo());

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            System.out.println("BookingServlet doGet: User not logged in. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
            return;
        }
        User loggedInCustomer = (User) session.getAttribute("loggedInUser");
        if (!"customer".equals(loggedInCustomer.getRole())) {
            System.out.println("BookingServlet doGet: User is not a customer. Role: " + loggedInCustomer.getRole());
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ khách hàng mới được đặt lịch.");
            return;
        }


        String action = request.getPathInfo();
        if (action == null || action.equals("/")) {
            action = "/form";
        }
        System.out.println("BookingServlet doGet: Action is " + action);

        try {
            switch (action) {
                case "/form":
                    showBookingForm(request, response);
                    break;
                case "/get-available-slots":
                    getAvailableSlots(request, response);
                    break;
                default:
                    System.out.println("BookingServlet doGet: Unknown action " + action);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException ex) {
            System.err.println("BookingServlet doGet: SQLException: " + ex.getMessage());
            ex.printStackTrace();
            throw new ServletException("Lỗi cơ sở dữ liệu khi xử lý đặt lịch.", ex);
        } catch (ParseException e) {
            System.err.println("BookingServlet doGet: ParseException: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Lỗi phân tích ngày giờ khi xử lý đặt lịch.", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        System.out.println("BookingServlet doPost called. PathInfo: " + request.getPathInfo());

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            System.out.println("BookingServlet doPost: User not logged in. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User loggedInCustomer = (User) session.getAttribute("loggedInUser");
        if (!"customer".equals(loggedInCustomer.getRole())) {
            System.out.println("BookingServlet doPost: User is not a customer. Role: " + loggedInCustomer.getRole());
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ khách hàng mới được đặt lịch.");
            return;
        }

        String action = request.getPathInfo();
        if (action == null) {
            action = "/submit";
        }
        System.out.println("BookingServlet doPost: Action is " + action);

        try {
            if ("/submit".equals(action)) {
                System.out.println("BookingServlet doPost: Processing booking submission...");
                processBookingSubmission(request, response, loggedInCustomer);
            } else {
                System.out.println("BookingServlet doPost: Invalid action " + action);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ.");
            }
        } catch (SQLException ex) {
            System.err.println("BookingServlet doPost: SQLException: " + ex.getMessage());
            ex.printStackTrace();
            request.setAttribute("bookingErrorMessage", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            showBookingFormOnError(request, response);
        } catch (ParseException ex) {
            System.err.println("BookingServlet doPost: ParseException: " + ex.getMessage());
            ex.printStackTrace();
            request.setAttribute("bookingErrorMessage", "Lỗi định dạng ngày/giờ: " + ex.getMessage());
            showBookingFormOnError(request, response);
        } catch (Exception ex) {
            System.err.println("BookingServlet doPost: Generic Exception: " + ex.getMessage());
            ex.printStackTrace();
            request.setAttribute("bookingErrorMessage", "Đã có lỗi xảy ra: " + ex.getMessage());
            showBookingFormOnError(request, response);
        }
    }


    private void loadCommonDataForBookingForm(HttpServletRequest request) throws SQLException {
        System.out.println("loadCommonDataForBookingForm called.");
        List<Service> serviceList = serviceDAO.getAllServices(true);
        List<NailArt> nailArtList = nailArtDAO.getAllNailArts(true);
        List<User> staffList = userDAO.getUsersByRole("staff");
        staffList.addAll(userDAO.getUsersByRole("admin"));
        staffList.addAll(userDAO.getUsersByRole("cashier"));

        request.setAttribute("serviceList", serviceList);
        request.setAttribute("nailArtList", nailArtList);
        request.setAttribute("staffList", staffList);
        System.out.println("loadCommonDataForBookingForm: Loaded " + serviceList.size() + " services, " + nailArtList.size() + " nail arts, " + staffList.size() + " staff.");
    }

    private void showBookingFormOnError(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        System.out.println("showBookingFormOnError called. Error message: " + request.getAttribute("bookingErrorMessage"));
        try {
            loadCommonDataForBookingForm(request);
        } catch (SQLException e) {
            System.err.println("showBookingFormOnError: SQLException during loadCommonData: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Lỗi tải dữ liệu cho form đặt lịch khi có lỗi trước đó.", e);
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/booking_form.jsp");
        dispatcher.forward(request, response);
    }


    private void showBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        System.out.println("showBookingForm called.");
        loadCommonDataForBookingForm(request);

        String preSelectedServiceId = request.getParameter("serviceId");
        if(preSelectedServiceId != null && !preSelectedServiceId.isEmpty()){
            try{
                request.setAttribute("preSelectedServiceId", Integer.parseInt(preSelectedServiceId));
                System.out.println("showBookingForm: Pre-selected service ID: " + preSelectedServiceId);
            } catch (NumberFormatException e) {
                System.err.println("showBookingForm: NumberFormatException for preSelectedServiceId: " + preSelectedServiceId);
            }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/booking_form.jsp");
        dispatcher.forward(request, response);
    }

    private void processBookingSubmission(HttpServletRequest request, HttpServletResponse response, User customer)
            throws SQLException, IOException, ParseException, ServletException {
        System.out.println("processBookingSubmission started for customer ID: " + customer.getUserId());

        String[] selectedServiceIdParams = request.getParameterValues("selectedServiceIds");
        System.out.println("Received selectedServiceIdParams: " + (selectedServiceIdParams != null ? Arrays.toString(selectedServiceIdParams) : "null"));

        String selectedGlobalNailArtIdStr = request.getParameter("selectedGlobalNailArtId");
        System.out.println("Received selectedGlobalNailArtIdStr: " + selectedGlobalNailArtIdStr);

        String selectedDateStr = request.getParameter("selectedDate");
        String selectedTimeStr = request.getParameter("selectedTime");
        String staffIdStr = request.getParameter("staffId");
        String customerNotes = request.getParameter("customerNotes");
        System.out.println("Received Date: " + selectedDateStr + ", Time: " + selectedTimeStr + ", Staff ID: " + staffIdStr);


        if (selectedServiceIdParams == null || selectedServiceIdParams.length == 0) {
            System.out.println("Validation fail: No service IDs selected.");
            request.setAttribute("bookingErrorMessage", "Vui lòng chọn ít nhất một dịch vụ.");
            showBookingFormOnError(request, response);
            return;
        }
        if (selectedDateStr == null || selectedDateStr.isEmpty() || selectedTimeStr == null || selectedTimeStr.isEmpty()) {
            System.out.println("Validation fail: Date or Time not selected.");
            request.setAttribute("bookingErrorMessage", "Vui lòng chọn ngày và giờ hẹn.");
            showBookingFormOnError(request, response);
            return;
        }

        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        java.util.Date selectedDateTimeUtil = dateTimeFormat.parse(selectedDateStr + " " + selectedTimeStr);
        Timestamp appointmentTimestamp = new Timestamp(selectedDateTimeUtil.getTime());
        System.out.println("Parsed appointmentTimestamp: " + appointmentTimestamp);

        if(appointmentTimestamp.before(new Timestamp(System.currentTimeMillis()))){
            System.out.println("Validation fail: Appointment time is in the past.");
            request.setAttribute("bookingErrorMessage", "Không thể đặt lịch cho thời gian trong quá khứ.");
            showBookingFormOnError(request, response);
            return;
        }

        Integer staffId = null;
        if (staffIdStr != null && !staffIdStr.isEmpty() && !staffIdStr.equals("0")) {
            try {
                staffId = Integer.parseInt(staffIdStr);
                System.out.println("Parsed staffId: " + staffId);
            } catch (NumberFormatException e) {
                System.err.println("NumberFormatException for staffIdStr: " + staffIdStr);
                request.setAttribute("bookingErrorMessage", "Mã nhân viên không hợp lệ.");
                showBookingFormOnError(request, response);
                return;
            }
        }

        Integer globalNailArtId = null;
        if (selectedGlobalNailArtIdStr != null && !selectedGlobalNailArtIdStr.isEmpty() && !selectedGlobalNailArtIdStr.equals("0")) {
            try {
                globalNailArtId = Integer.parseInt(selectedGlobalNailArtIdStr);
                System.out.println("Parsed globalNailArtId: " + globalNailArtId);
            } catch (NumberFormatException e) {
                System.err.println("NumberFormatException for selectedGlobalNailArtIdStr: " + selectedGlobalNailArtIdStr);
                request.setAttribute("bookingErrorMessage", "Mã Nail Art không hợp lệ.");
                showBookingFormOnError(request, response);
                return;
            }
        }


        List<AppointmentDetail> detailsList = new ArrayList<>();
        BigDecimal totalBasePrice = BigDecimal.ZERO;
        BigDecimal totalAddonPriceFromNailArt = BigDecimal.ZERO;
        int totalDurationMinutes = 0;

        for (String serviceIdStr : selectedServiceIdParams) {
            System.out.println("Processing serviceIdStr: '" + serviceIdStr + "'");
            if (serviceIdStr == null || serviceIdStr.trim().isEmpty()) {
                System.out.println("Skipping empty or null serviceIdStr.");
                continue;
            }
            int serviceIdValue;
            try {
                serviceIdValue = Integer.parseInt(serviceIdStr.trim());
                System.out.println("Parsed serviceIdValue: " + serviceIdValue);
            } catch (NumberFormatException e) {
                System.err.println("ERROR: NumberFormatException for serviceIdStr: '" + serviceIdStr.trim() + "'");
                request.setAttribute("debug_parse_error_" + serviceIdStr.trim(), "Lỗi parse ID: " + serviceIdStr.trim());
                continue;
            }

            Service service = serviceDAO.getServiceById(serviceIdValue);
            if (service == null) {
                System.err.println("ERROR: Service not found in DB for ID: " + serviceIdValue);
                request.setAttribute("debug_notfound_" + serviceIdValue, "Dịch vụ ID " + serviceIdValue + " không tồn tại.");
                continue;
            }
            System.out.println("Found service: " + service.getServiceName() + ", isActive: " + service.isActive());

            if (!service.isActive()) {
                System.err.println("ERROR: Service ID: " + serviceIdValue + " is not active.");
                request.setAttribute("debug_inactive_" + serviceIdValue, "Dịch vụ ID " + serviceIdValue + " không hoạt động.");
                continue;
            }

            AppointmentDetail detail = new AppointmentDetail();
            detail.setServiceId(serviceIdValue);
            detail.setServicePriceAtBooking(service.getPrice());
            detail.setQuantity(1);

            detailsList.add(detail);
            System.out.println("Added service ID " + serviceIdValue + " to detailsList. Current detailsList size: " + detailsList.size());

            totalBasePrice = totalBasePrice.add(service.getPrice());
            totalDurationMinutes += service.getDurationMinutes();
        }
        System.out.println("Finished processing service IDs. Total details: " + detailsList.size() + ", Total Base Price: " + totalBasePrice + ", Total Duration: " + totalDurationMinutes);

        if (detailsList.isEmpty()) {
            System.err.println("ERROR: detailsList is empty after processing all service IDs. This will trigger 'Không có dịch vụ hợp lệ...'");
            request.setAttribute("bookingErrorMessage", "Không có dịch vụ hợp lệ nào được chọn.");
            request.setAttribute("submittedServiceIdsForDebug", Arrays.toString(selectedServiceIdParams));
            showBookingFormOnError(request, response);
            return;
        }

        if (globalNailArtId != null) {
            NailArt nailArt = nailArtDAO.getNailArtById(globalNailArtId);
            if (nailArt != null && nailArt.isActive()) {
                totalAddonPriceFromNailArt = nailArt.getPriceAddon();
                System.out.println("Global Nail Art ID " + globalNailArtId + " found. Price: " + totalAddonPriceFromNailArt);
            } else {
                System.out.println("Global Nail Art ID " + globalNailArtId + " not found or not active.");
            }
        }

        Appointment appointment = new Appointment();
        appointment.setCustomerId(customer.getUserId());
        appointment.setStaffId(staffId);
        appointment.setAppointmentDatetime(appointmentTimestamp);
        appointment.setEstimatedDurationMinutes(totalDurationMinutes);
        appointment.setStatus("pending_confirmation");
        appointment.setTotalBasePrice(totalBasePrice);
        appointment.setTotalAddonPrice(totalAddonPriceFromNailArt);
        appointment.setGlobalNailArtId(globalNailArtId);
        appointment.setDiscountAmount(BigDecimal.ZERO);
        appointment.setCustomerNotes(customerNotes);
        System.out.println("Appointment object created. Attempting to add to DB.");

        int newAppointmentId = appointmentDAO.addAppointment(appointment, detailsList);

        if (newAppointmentId > 0) {
            System.out.println("Appointment created successfully. ID: " + newAppointmentId);
            response.sendRedirect(request.getContextPath() + "/customer/booking-success?appointmentId=" + newAppointmentId);
        } else {
            System.err.println("Failed to create appointment. newAppointmentId: " + newAppointmentId);
            request.setAttribute("bookingErrorMessage", "Không thể tạo lịch hẹn. Có thể do lịch đã đầy hoặc lỗi hệ thống. Vui lòng thử lại sau.");
            showBookingFormOnError(request, response);
        }
    }


    private void getAvailableSlots(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ParseException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        System.out.println("getAvailableSlots called.");

        String dateStr = request.getParameter("date");
        String staffIdStr = request.getParameter("staffId");
        String totalDurationRequiredStr = request.getParameter("duration");
        System.out.println("getAvailableSlots params: date=" + dateStr + ", staffId=" + staffIdStr + ", duration=" + totalDurationRequiredStr);


        if (dateStr == null || dateStr.isEmpty() || totalDurationRequiredStr == null || totalDurationRequiredStr.isEmpty()) {
            System.out.println("getAvailableSlots: Missing date or duration.");
            response.getWriter().write("{\"error\":\"Vui lòng chọn ngày và dịch vụ (để tính thời gian).\"}");
            return;
        }

        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date selectedUtilDate = sdfDate.parse(dateStr);
        java.sql.Date selectedSqlDate = new java.sql.Date(selectedUtilDate.getTime());

        int totalDurationRequired = 0;
        try {
            totalDurationRequired = Integer.parseInt(totalDurationRequiredStr);
            if (totalDurationRequired <= 0 && !request.getParameterMap().containsKey("isCheckingInitialDate")) {
                System.out.println("getAvailableSlots: Invalid duration (<=0).");
                response.getWriter().write("{\"error\":\"Thời gian dịch vụ không hợp lệ.\"}");
                return;
            }
        } catch (NumberFormatException e){
            System.err.println("getAvailableSlots: NumberFormatException for duration: " + totalDurationRequiredStr);
            response.getWriter().write("{\"error\":\"Thời gian dịch vụ không hợp lệ (duration).\"}");
            return;
        }
        System.out.println("getAvailableSlots: Parsed selectedSqlDate=" + selectedSqlDate + ", totalDurationRequired=" + totalDurationRequired);

        if (totalDurationRequired <=0) {
            System.out.println("getAvailableSlots: Total duration is <= 0 after all calculations. No slots will be found.");
            response.getWriter().write("{\"error\":\"Vui lòng chọn ít nhất một dịch vụ có thời gian thực hiện.\"}");
            return;
        }


        Integer specificStaffId = null;
        if (staffIdStr != null && !staffIdStr.isEmpty() && !staffIdStr.equals("0")) {
            try{
                specificStaffId = Integer.parseInt(staffIdStr);
                System.out.println("getAvailableSlots: specificStaffId=" + specificStaffId);
            } catch (NumberFormatException e) {
                System.err.println("getAvailableSlots: NumberFormatException for staffId: " + staffIdStr);
                response.getWriter().write("{\"error\":\"Mã nhân viên không hợp lệ.\"}");
                return;
            }
        }

        List<StaffSchedule> candidateSchedules;
        List<String> excludedStatuses = Arrays.asList("cancelled_by_customer", "cancelled_by_staff", "no_show");
        List<Appointment> allAppointmentsForDay = appointmentDAO.getAppointmentsByDateAndStatusNotIn(selectedSqlDate, excludedStatuses);
        System.out.println("getAvailableSlots: Found " + allAppointmentsForDay.size() + " appointments for the day (excluding certain statuses).");


        if (specificStaffId != null) {
            User staffUser = userDAO.getUserById(specificStaffId);
            if (staffUser == null || !staffUser.isActive() || !("staff".equals(staffUser.getRole()) || "admin".equals(staffUser.getRole()) || "cashier".equals(staffUser.getRole()))) {
                System.out.println("getAvailableSlots: Specific staff ID " + specificStaffId + " is invalid or not active.");
                response.getWriter().write("{\"error\":\"Nhân viên không hợp lệ hoặc không hoạt động.\"}");
                return;
            }
            candidateSchedules = staffScheduleDAO.getSchedulesByStaffIdAndDate(specificStaffId, selectedSqlDate);
        } else {
            candidateSchedules = staffScheduleDAO.getAvailableSchedulesByDate(selectedSqlDate);
        }
        System.out.println("getAvailableSlots: Found " + candidateSchedules.size() + " candidate schedules.");

        Set<String> availableTimeSlots = new TreeSet<>();
        int slotIntervalMinutes = 15;
        int bookingBufferHours = 1;

        Calendar now = Calendar.getInstance();
        Calendar minBookingTimeCal = Calendar.getInstance();
        minBookingTimeCal.setTime(selectedUtilDate);
        minBookingTimeCal.set(Calendar.HOUR_OF_DAY, 0); minBookingTimeCal.set(Calendar.MINUTE, 0); minBookingTimeCal.set(Calendar.SECOND, 0);

        Calendar todayCal = Calendar.getInstance();
        boolean isToday = selectedUtilDate.getYear() == todayCal.get(Calendar.YEAR) &&
                selectedUtilDate.getMonth() == todayCal.get(Calendar.MONTH) &&
                selectedUtilDate.getDate() == todayCal.get(Calendar.DATE);

        if (isToday) {
            minBookingTimeCal.setTime(now.getTime());
            minBookingTimeCal.add(Calendar.HOUR_OF_DAY, bookingBufferHours);
            System.out.println("getAvailableSlots: Today is selected. Min booking time (after buffer): " + minBookingTimeCal.getTime());
        }


        for (StaffSchedule schedule : candidateSchedules) {
            System.out.println("getAvailableSlots: Checking schedule for staff ID " + schedule.getStaffId() + " from " + schedule.getStartTime() + " to " + schedule.getEndTime());
            if (!schedule.isAvailable()) {
                System.out.println("getAvailableSlots: Schedule for staff ID " + schedule.getStaffId() + " is not available. Skipping.");
                continue;
            }

            List<TimeRange> staffBookedTimeRanges = new ArrayList<>();
            for(Appointment app : allAppointmentsForDay) {
                if( (specificStaffId != null && app.getStaffId() != null && app.getStaffId().equals(schedule.getStaffId())) ||
                        (specificStaffId == null && app.getStaffId() != null && app.getStaffId().equals(schedule.getStaffId())) ) {
                    staffBookedTimeRanges.add(new TimeRange(app.getAppointmentDatetime(), app.getEstimatedDurationMinutes()));
                }
            }
            System.out.println("getAvailableSlots: Staff ID " + schedule.getStaffId() + " has " + staffBookedTimeRanges.size() + " booked ranges for the day.");

            Calendar currentSlotStartCal = Calendar.getInstance();
            currentSlotStartCal.setTime(schedule.getWorkDate());

            Calendar scheduleStartTimeHelper = Calendar.getInstance();
            scheduleStartTimeHelper.setTime(schedule.getStartTime());
            currentSlotStartCal.set(Calendar.HOUR_OF_DAY, scheduleStartTimeHelper.get(Calendar.HOUR_OF_DAY));
            currentSlotStartCal.set(Calendar.MINUTE, scheduleStartTimeHelper.get(Calendar.MINUTE));
            currentSlotStartCal.set(Calendar.SECOND, 0);
            currentSlotStartCal.set(Calendar.MILLISECOND, 0);

            Calendar scheduleEndTimeHelper = Calendar.getInstance();
            scheduleEndTimeHelper.setTime(schedule.getEndTime());

            Calendar currentSlotEndPotentialCal = Calendar.getInstance();

            while (true) {
                currentSlotEndPotentialCal.setTime(currentSlotStartCal.getTime());
                currentSlotEndPotentialCal.add(Calendar.MINUTE, totalDurationRequired);

                if (currentSlotEndPotentialCal.get(Calendar.HOUR_OF_DAY) > scheduleEndTimeHelper.get(Calendar.HOUR_OF_DAY) ||
                        (currentSlotEndPotentialCal.get(Calendar.HOUR_OF_DAY) == scheduleEndTimeHelper.get(Calendar.HOUR_OF_DAY) &&
                                currentSlotEndPotentialCal.get(Calendar.MINUTE) > scheduleEndTimeHelper.get(Calendar.MINUTE)) ) {
                    System.out.println("getAvailableSlots: Potential slot " + new SimpleDateFormat("HH:mm").format(currentSlotStartCal.getTime()) + " ends after schedule. Breaking loop for staff " + schedule.getStaffId());
                    break;
                }

                if (currentSlotStartCal.before(minBookingTimeCal) && isToday) {
                    currentSlotStartCal.add(Calendar.MINUTE, slotIntervalMinutes);
                    continue;
                }

                boolean isOverlapping = false;
                Timestamp currentSlotStartTS = new Timestamp(currentSlotStartCal.getTimeInMillis());
                Timestamp currentSlotEndPotentialTS = new Timestamp(currentSlotEndPotentialCal.getTimeInMillis());

                for (TimeRange bookedRange : staffBookedTimeRanges) {
                    if (bookedRange.isOverlappingWith(currentSlotStartTS, currentSlotEndPotentialTS)) {
                        isOverlapping = true;
                        break;
                    }
                }

                if (!isOverlapping) {
                    String slotTime = new SimpleDateFormat("HH:mm").format(currentSlotStartTS);
                    availableTimeSlots.add(slotTime);
                    System.out.println("getAvailableSlots: Found available slot: " + slotTime + " for staff " + schedule.getStaffId());
                }

                currentSlotStartCal.add(Calendar.MINUTE, slotIntervalMinutes);
            }
        }
        System.out.println("getAvailableSlots: Total available slots found: " + availableTimeSlots.size());

        StringBuilder jsonResponse = new StringBuilder("{\"slots\":[");
        List<String> slotsList = new ArrayList<>(availableTimeSlots);
        for (int i = 0; i < slotsList.size(); i++) {
            jsonResponse.append("\"").append(slotsList.get(i)).append("\"");
            if (i < slotsList.size() - 1) {
                jsonResponse.append(",");
            }
        }
        jsonResponse.append("]}");
        response.getWriter().write(jsonResponse.toString());
        System.out.println("getAvailableSlots: JSON response sent: " + jsonResponse.toString());
    }

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

        boolean isOverlappingWith(Timestamp slotStartTimestamp, Timestamp slotEndTimestamp) {
            return slotStartTimestamp.before(this.end) && slotEndTimestamp.after(this.start);
        }
    }
}