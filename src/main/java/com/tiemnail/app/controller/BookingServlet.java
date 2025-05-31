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
// import java.sql.Time; // Không còn dùng trực tiếp
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
    private AppointmentDetailDAO appointmentDetailDAO; // Vẫn giữ nếu bạn dùng để lưu details


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
                case "/get-available-slots":
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
            action = "/submit"; // Mặc định là submit nếu không có pathInfo
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
        List<NailArt> nailArtList = nailArtDAO.getAllNailArts(true); // Vẫn cần nailArtList cho dropdown chung
        List<User> staffList = userDAO.getUsersByRole("staff");
        // Cân nhắc việc gộp các vai trò khác nếu họ thực sự có thể được chọn làm nhân viên thực hiện
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
            // Log lỗi này kỹ hơn
            e.printStackTrace();
            throw new ServletException("Lỗi tải dữ liệu cho form đặt lịch khi có lỗi trước đó.", e);
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
            } catch (NumberFormatException e) {
                // Bỏ qua lỗi parse ở đây, không cần thiết phải throw exception
            }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/booking_form.jsp");
        dispatcher.forward(request, response);
    }

    private void processBookingSubmission(HttpServletRequest request, HttpServletResponse response, User customer)
            throws SQLException, IOException, ParseException, ServletException {

        String[] selectedServiceIdParams = request.getParameterValues("selectedServiceIds"); // Từ input ẩn name="selectedServiceIds"
        String selectedGlobalNailArtIdStr = request.getParameter("selectedGlobalNailArtId"); // Tên của select nail art chung

        String selectedDateStr = request.getParameter("selectedDate");
        String selectedTimeStr = request.getParameter("selectedTime");
        String staffIdStr = request.getParameter("staffId");
        String customerNotes = request.getParameter("customerNotes");

        if (selectedServiceIdParams == null || selectedServiceIdParams.length == 0) {
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
        java.util.Date selectedDateTimeUtil = dateTimeFormat.parse(selectedDateStr + " " + selectedTimeStr);
        Timestamp appointmentTimestamp = new Timestamp(selectedDateTimeUtil.getTime());

        if(appointmentTimestamp.before(new Timestamp(System.currentTimeMillis()))){ // Có thể thêm buffer nhỏ
            request.setAttribute("bookingErrorMessage", "Không thể đặt lịch cho thời gian trong quá khứ.");
            showBookingFormOnError(request, response);
            return;
        }

        Integer staffId = null;
        if (staffIdStr != null && !staffIdStr.isEmpty() && !staffIdStr.equals("0")) {
            try {
                staffId = Integer.parseInt(staffIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("bookingErrorMessage", "Mã nhân viên không hợp lệ.");
                showBookingFormOnError(request, response);
                return;
            }
        }

        Integer globalNailArtId = null;
        if (selectedGlobalNailArtIdStr != null && !selectedGlobalNailArtIdStr.isEmpty() && !selectedGlobalNailArtIdStr.equals("0")) {
            try {
                globalNailArtId = Integer.parseInt(selectedGlobalNailArtIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("bookingErrorMessage", "Mã Nail Art không hợp lệ.");
                showBookingFormOnError(request, response);
                return;
            }
        }


        List<AppointmentDetail> detailsList = new ArrayList<>();
        BigDecimal totalBasePrice = BigDecimal.ZERO;
        // totalAddonPrice sẽ được tính từ globalNailArtId
        BigDecimal totalAddonPriceFromNailArt = BigDecimal.ZERO;
        int totalDurationMinutes = 0;

        for (String serviceIdStr : selectedServiceIdParams) {
            if (serviceIdStr == null || serviceIdStr.trim().isEmpty()) {
                continue;
            }
            int serviceId;
            try {
                serviceId = Integer.parseInt(serviceIdStr.trim());
            } catch (NumberFormatException e) {
                System.err.println("Lỗi parse serviceId trong submit: " + serviceIdStr);
                continue;
            }

            Service service = serviceDAO.getServiceById(serviceId);
            if (service == null || !service.isActive()) continue;

            AppointmentDetail detail = new AppointmentDetail();
            detail.setServiceId(serviceId);
            detail.setServicePriceAtBooking(service.getPrice());
            detail.setQuantity(1);
            // Không set NailArtId và NailArtPriceAtBooking cho từng detail nữa
            // Nếu bảng AppointmentDetail có cột nail_art_id, bạn có thể để nó là NULL
            // hoặc quyết định không lưu nail art vào từng detail nữa mà chỉ lưu ở Appointment.
            // Trong ví dụ này, giả sử AppointmentDetail không còn lưu nail_art_id riêng.

            detailsList.add(detail);

            totalBasePrice = totalBasePrice.add(service.getPrice());
            totalDurationMinutes += service.getDurationMinutes();
        }

        if (detailsList.isEmpty()) {
            request.setAttribute("bookingErrorMessage", "Không có dịch vụ hợp lệ nào được chọn.");
            showBookingFormOnError(request, response);
            return;
        }

        // Tính giá cho Global Nail Art (nếu có)
        if (globalNailArtId != null) {
            NailArt nailArt = nailArtDAO.getNailArtById(globalNailArtId);
            if (nailArt != null && nailArt.isActive()) {
                totalAddonPriceFromNailArt = nailArt.getPriceAddon();
                // Nếu nail art có thời gian riêng, bạn có thể cộng vào totalDurationMinutes ở đây
                // totalDurationMinutes += nailArt.getDuration(); // Giả sử NailArt có thuộc tính duration
            }
        }

        Appointment appointment = new Appointment();
        appointment.setCustomerId(customer.getUserId());
        // appointment.setGuestName(...); // Nếu bạn có form cho khách vãng lai
        // appointment.setGuestPhone(...);
        appointment.setStaffId(staffId);
        appointment.setAppointmentDatetime(appointmentTimestamp);
        appointment.setEstimatedDurationMinutes(totalDurationMinutes); // Thời gian này chưa bao gồm nail art nếu nail art có thời gian riêng
        appointment.setStatus("pending_confirmation");
        appointment.setTotalBasePrice(totalBasePrice);
        appointment.setTotalAddonPrice(totalAddonPriceFromNailArt); // Giá của global nail art
        appointment.setGlobalNailArtId(globalNailArtId); // Lưu ID của global nail art
        appointment.setDiscountAmount(BigDecimal.ZERO); // Xử lý discount nếu có
        // finalAmount sẽ được tính dựa trên base + addon - discount
        appointment.setCustomerNotes(customerNotes);
        // appointment.setStaffNotes(...);

        int newAppointmentId = appointmentDAO.addAppointment(appointment, detailsList);

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

        String dateStr = request.getParameter("date");
        String staffIdStr = request.getParameter("staffId");
        String totalDurationRequiredStr = request.getParameter("duration");
        // String globalNailArtIdStr = request.getParameter("globalNailArtId"); // Nếu thời gian nail art ảnh hưởng slot

        if (dateStr == null || dateStr.isEmpty() || totalDurationRequiredStr == null || totalDurationRequiredStr.isEmpty()) {
            response.getWriter().write("{\"error\":\"Vui lòng chọn ngày và dịch vụ (để tính thời gian).\"}");
            return;
        }

        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date selectedUtilDate = sdfDate.parse(dateStr);
        java.sql.Date selectedSqlDate = new java.sql.Date(selectedUtilDate.getTime());

        int totalDurationRequired = 0;
        try {
            totalDurationRequired = Integer.parseInt(totalDurationRequiredStr);
            if (totalDurationRequired <= 0 && !request.getParameterMap().containsKey("isCheckingInitialDate")) { // Chỉ báo lỗi nếu không phải kiểm tra ngày ban đầu
                // Nếu isCheckingInitialDate là true, có thể duration là 0 nhưng vẫn muốn lấy lịch nhân viên
                response.getWriter().write("{\"error\":\"Thời gian dịch vụ không hợp lệ.\"}");
                return;
            }
        } catch (NumberFormatException e){
            response.getWriter().write("{\"error\":\"Thời gian dịch vụ không hợp lệ (duration).\"}");
            return;
        }

        // Nếu bạn muốn thời gian của NailArt ảnh hưởng đến việc tìm slot, bạn cần lấy globalNailArtId ở đây
        // và cộng thêm thời gian của nó vào totalDurationRequired
        /*
        if (globalNailArtIdStr != null && !globalNailArtIdStr.isEmpty() && !globalNailArtIdStr.equals("0")) {
            try {
                int nailArtId = Integer.parseInt(globalNailArtIdStr);
                NailArt nailArt = nailArtDAO.getNailArtById(nailArtId);
                if (nailArt != null && nailArt.isActive() && nailArt.getDurationMinutes() > 0) { // Giả sử NailArt có getDurationMinutes()
                    totalDurationRequired += nailArt.getDurationMinutes();
                }
            } catch (NumberFormatException e) {
                // Bỏ qua nếu ID không hợp lệ
            }
        }
        */
        // Nếu totalDurationRequired vẫn là 0 sau khi tính cả nail art (nếu có) thì không tìm slot
        if (totalDurationRequired <=0) {
            response.getWriter().write("{\"error\":\"Vui lòng chọn ít nhất một dịch vụ có thời gian thực hiện.\"}");
            return;
        }


        Integer specificStaffId = null;
        if (staffIdStr != null && !staffIdStr.isEmpty() && !staffIdStr.equals("0")) {
            try{
                specificStaffId = Integer.parseInt(staffIdStr);
            } catch (NumberFormatException e) {
                response.getWriter().write("{\"error\":\"Mã nhân viên không hợp lệ.\"}");
                return;
            }
        }

        List<StaffSchedule> candidateSchedules;
        List<String> excludedStatuses = Arrays.asList("cancelled_by_customer", "cancelled_by_staff", "no_show");
        List<Appointment> allAppointmentsForDay = appointmentDAO.getAppointmentsByDateAndStatusNotIn(selectedSqlDate, excludedStatuses);


        if (specificStaffId != null) {
            User staffUser = userDAO.getUserById(specificStaffId);
            if (staffUser == null || !staffUser.isActive() || !("staff".equals(staffUser.getRole()) || "admin".equals(staffUser.getRole()) || "cashier".equals(staffUser.getRole()))) {
                response.getWriter().write("{\"error\":\"Nhân viên không hợp lệ hoặc không hoạt động.\"}");
                return;
            }
            candidateSchedules = staffScheduleDAO.getSchedulesByStaffIdAndDate(specificStaffId, selectedSqlDate);
        } else {
            candidateSchedules = staffScheduleDAO.getAvailableSchedulesByDate(selectedSqlDate);
        }

        Set<String> availableTimeSlots = new TreeSet<>();
        int slotIntervalMinutes = 15;
        int bookingBufferHours = 1;

        Calendar now = Calendar.getInstance();
        Calendar minBookingTimeCal = Calendar.getInstance();
        minBookingTimeCal.setTime(selectedUtilDate); // Bắt đầu từ ngày đã chọn
        minBookingTimeCal.set(Calendar.HOUR_OF_DAY, 0); minBookingTimeCal.set(Calendar.MINUTE, 0); minBookingTimeCal.set(Calendar.SECOND, 0);

        Calendar todayCal = Calendar.getInstance(); // Ngày hiện tại
        boolean isToday = selectedUtilDate.getYear() == todayCal.get(Calendar.YEAR) &&
                selectedUtilDate.getMonth() == todayCal.get(Calendar.MONTH) &&
                selectedUtilDate.getDate() == todayCal.get(Calendar.DATE);

        if (isToday) { // Nếu là ngày hôm nay, thì mới áp dụng buffer
            minBookingTimeCal.setTime(now.getTime());
            minBookingTimeCal.add(Calendar.HOUR_OF_DAY, bookingBufferHours);
        }


        for (StaffSchedule schedule : candidateSchedules) {
            if (!schedule.isAvailable()) continue;

            List<TimeRange> staffBookedTimeRanges = new ArrayList<>();
            for(Appointment app : allAppointmentsForDay) {
                // Chỉ lấy các cuộc hẹn của nhân viên đang xét (nếu specificStaffId được chọn)
                // Hoặc nếu không chọn nhân viên cụ thể, thì lịch trống của nhân viên này không nên bị ảnh hưởng bởi lịch của nhân viên khác
                if( (specificStaffId != null && app.getStaffId() != null && app.getStaffId().equals(schedule.getStaffId())) ||
                        (specificStaffId == null && app.getStaffId() != null && app.getStaffId().equals(schedule.getStaffId())) ) { // Thêm điều kiện cho TH ko chọn NV cụ thể
                    staffBookedTimeRanges.add(new TimeRange(app.getAppointmentDatetime(), app.getEstimatedDurationMinutes()));
                }
            }

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
                    break;
                }

                if (currentSlotStartCal.before(minBookingTimeCal) && isToday) { // Chỉ áp dụng buffer cho ngày hôm nay
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
                    availableTimeSlots.add(new SimpleDateFormat("HH:mm").format(currentSlotStartTS));
                }

                currentSlotStartCal.add(Calendar.MINUTE, slotIntervalMinutes);
            }
        }

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