package com.tiemnail.app.controller;

import com.tiemnail.app.dao.AppointmentDAO;
import com.tiemnail.app.dao.AppointmentDetailDAO;
import com.tiemnail.app.dao.UserDAO;
import com.tiemnail.app.dao.ServiceDAO;
import com.tiemnail.app.dao.NailArtDAO;
import com.tiemnail.app.model.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/admin/appointments/*")
public class AppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    private AppointmentDetailDAO appointmentDetailDAO;
    private UserDAO userDAO;
    private ServiceDAO serviceDAO;
    private NailArtDAO nailArtDAO;


    public void init() {
        appointmentDAO = new AppointmentDAO();
        appointmentDetailDAO = new AppointmentDetailDAO();
        userDAO = new UserDAO();
        serviceDAO = new ServiceDAO();
        nailArtDAO = new NailArtDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }

        try {
            switch (action) {
                case "/new":
                    showNewAppointmentForm(request, response);
                    break;
                case "/insert":
                    insertAppointment(request, response);
                    break;
                case "/edit":
                    showEditAppointmentForm(request, response);
                    break;
                case "/update":
                    updateAppointment(request, response);
                    break;
                case "/view":
                    viewAppointment(request, response);
                    break;
                case "/update_status":
                    updateAppointmentStatus(request, response);
                    break;
                default: // "/list"
                    listAppointments(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException("Database error in AppointmentServlet: " + ex.getMessage(), ex);
        } catch (ParseException e) {
            throw new ServletException("Date parsing error in AppointmentServlet: " + e.getMessage(), e);
        }
    }

    private void listAppointments(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException, ParseException {
        List<Appointment> listAppointment;

        String filterDateStr = request.getParameter("filterDate");
        String filterStaffIdStr = request.getParameter("filterStaffId");
        String filterStatus = request.getParameter("filterStatus");

        // Tạm thời ví dụ lấy tất cả, sẽ thêm filter sau
        if (filterDateStr != null && !filterDateStr.isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date parsedDate = sdf.parse(filterDateStr);
            listAppointment = appointmentDAO.getAppointmentsByDate(new java.sql.Date(parsedDate.getTime()));
        } else if (filterStaffIdStr != null && !filterStaffIdStr.isEmpty()){
            listAppointment = appointmentDAO.getAppointmentsByStaffId(Integer.parseInt(filterStaffIdStr));
        } else if (filterStatus != null && !filterStatus.isEmpty()){
            // Cần thêm phương thức getAppointmentsByStatus trong AppointmentDAO
            // listAppointment = appointmentDAO.getAppointmentsByStatus(filterStatus);
            listAppointment = appointmentDAO.getAllAppointments(); // Tạm thời
            List<Appointment> filteredList = new ArrayList<>();
            for(Appointment app : listAppointment){
                if(app.getStatus().equalsIgnoreCase(filterStatus)){
                    filteredList.add(app);
                }
            }
            listAppointment = filteredList;

        }
        else {
            listAppointment = appointmentDAO.getAllAppointments();
        }


        // Lấy thông tin user (khách hàng, nhân viên) để hiển thị tên thay vì ID
        for (Appointment app : listAppointment) {
            if (app.getCustomerId() != null && app.getCustomerId() > 0) {
                User customer = userDAO.getUserById(app.getCustomerId());
                if (customer != null) {
                    // Tạo một trường tạm trong request hoặc dùng map để truyền tên
                    // Hoặc thêm trường customerName, staffName vào Appointment model (không khuyến khích cho model thuần túy)
                    // request.setAttribute("customerName_" + app.getAppointmentId(), customer.getFullName());
                }
            }
            if (app.getStaffId() != null && app.getStaffId() > 0) {
                User staff = userDAO.getUserById(app.getStaffId());
                if (staff != null) {
                    // request.setAttribute("staffName_" + app.getAppointmentId(), staff.getFullName());
                }
            }
        }

        List<User> staffList = userDAO.getUsersByRole("staff"); // Lấy thêm admin, cashier nếu họ có thể thực hiện dịch vụ
        staffList.addAll(userDAO.getUsersByRole("admin"));
        staffList.addAll(userDAO.getUsersByRole("cashier"));


        request.setAttribute("listAppointment", listAppointment);
        request.setAttribute("staffListForFilter", staffList); // Để filter
        request.setAttribute("userDAO", userDAO); // Truyền userDAO để JSP có thể gọi lấy tên

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/appointment_list.jsp");
        dispatcher.forward(request, response);
    }

    private void viewAppointment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Appointment appointment = appointmentDAO.getAppointmentById(id);

        if (appointment == null) {
            response.sendRedirect(request.getContextPath() + "/admin/appointments/list?error=notfound");
            return;
        }

        List<AppointmentDetail> details = appointmentDetailDAO.getDetailsByAppointmentId(id);
        // Lấy tên cho từng detail
        for(AppointmentDetail detail : details) {
            Service service = serviceDAO.getServiceById(detail.getServiceId());
            // Gán tên service vào detail (có thể thêm trường transient vào model AppointmentDetail)
            // request.setAttribute("serviceName_detail_" + detail.getAppointmentDetailId(), service.getServiceName());
            if (detail.getNailArtId() != null && detail.getNailArtId() > 0) {
                NailArt nailArt = nailArtDAO.getNailArtById(detail.getNailArtId());
                // request.setAttribute("nailArtName_detail_" + detail.getAppointmentDetailId(), nailArt.getNailArtName());
            }
        }

        request.setAttribute("appointment", appointment);
        request.setAttribute("details", details);
        request.setAttribute("userDAO", userDAO); // Để lấy tên customer/staff
        request.setAttribute("serviceDAO", serviceDAO); // Để lấy tên service
        request.setAttribute("nailArtDAO", nailArtDAO); // Để lấy tên nail art

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/appointment_view.jsp");
        dispatcher.forward(request, response);
    }

    private void updateAppointmentStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        String currentStaffId = request.getParameter("currentStaffId"); // Để redirect lại đúng filter

        if (id > 0 && status != null && !status.isEmpty()) {
            appointmentDAO.updateAppointmentStatus(id, status);
        }

        String redirectUrl = request.getContextPath() + "/admin/appointments/list";
        if (currentStaffId != null && !currentStaffId.isEmpty()) {
            redirectUrl += "?filterStaffId=" + currentStaffId;
        }
        // Thêm các filter khác nếu có
        response.sendRedirect(redirectUrl);
    }
    private void loadCommonDataForForm(HttpServletRequest request) throws SQLException {
        // Lấy danh sách khách hàng (role: customer)
        List<User> customerList = userDAO.getUsersByRole("customer");
        request.setAttribute("customerList", customerList);

        // Lấy danh sách nhân viên (staff, admin, cashier)
        List<User> staffList = userDAO.getUsersByRole("staff");
        staffList.addAll(userDAO.getUsersByRole("admin"));
        staffList.addAll(userDAO.getUsersByRole("cashier"));
        request.setAttribute("staffList", staffList);

        // Lấy danh sách dịch vụ (active)
        List<Service> serviceList = serviceDAO.getAllServices(true);
        request.setAttribute("serviceList", serviceList);

        // Lấy danh sách mẫu nail (active)
        List<NailArt> nailArtList = nailArtDAO.getAllNailArts(true);
        request.setAttribute("nailArtList", nailArtList);
    }

    private void showNewAppointmentForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        loadCommonDataForForm(request);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/appointment_form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditAppointmentForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Appointment appointment = appointmentDAO.getAppointmentById(id);
        if (appointment == null) {
            response.sendRedirect(request.getContextPath() + "/admin/appointments/list?error=notfound_edit");
            return;
        }
        List<AppointmentDetail> details = appointmentDetailDAO.getDetailsByAppointmentId(id);

        request.setAttribute("appointment", appointment);
        request.setAttribute("details", details); // Để pre-fill các dịch vụ đã chọn
        loadCommonDataForForm(request);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/appointment_form.jsp");
        dispatcher.forward(request, response);
    }

    private Appointment parseAndValidateAppointmentData(HttpServletRequest request, Appointment appointmentToUpdate)
            throws ParseException, SQLException, ServletException, IOException {

        Appointment appointment = (appointmentToUpdate == null) ? new Appointment() : appointmentToUpdate;

        String customerIdStr = request.getParameter("customerId");
        String guestName = request.getParameter("guestName");
        String guestPhone = request.getParameter("guestPhone");
        String staffIdStr = request.getParameter("staffId");
        String appointmentDateStr = request.getParameter("appointmentDate"); // yyyy-MM-dd
        String appointmentTimeStr = request.getParameter("appointmentTime"); // HH:mm
        String status = request.getParameter("status");
        String customerNotes = request.getParameter("customerNotes");
        String staffNotes = request.getParameter("staffNotes");
        String discountAmountStr = request.getParameter("discountAmount");

        // Xử lý Customer
        if (customerIdStr != null && !customerIdStr.isEmpty() && !customerIdStr.equals("0")) {
            appointment.setCustomerId(Integer.parseInt(customerIdStr));
            appointment.setGuestName(null);
            appointment.setGuestPhone(null);
        } else {
            appointment.setCustomerId(null);
            appointment.setGuestName(guestName);
            appointment.setGuestPhone(guestPhone);
            if ((guestName == null || guestName.trim().isEmpty()) && appointmentToUpdate == null) { // Bắt buộc cho khách vãng lai mới
                request.setAttribute("errorMessage", "Tên khách vãng lai không được để trống.");
                return null; // Trả về null để servlet xử lý hiển thị lại form với lỗi
            }
        }

        if (staffIdStr != null && !staffIdStr.isEmpty() && !staffIdStr.equals("0")) {
            appointment.setStaffId(Integer.parseInt(staffIdStr));
        } else {
            appointment.setStaffId(null); // Hoặc gán nhân viên mặc định nếu có logic
        }

        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        java.util.Date parsedDateTime = dateTimeFormat.parse(appointmentDateStr + " " + appointmentTimeStr);
        appointment.setAppointmentDatetime(new java.sql.Timestamp(parsedDateTime.getTime()));

        appointment.setStatus(status != null ? status : "pending_confirmation"); // Mặc định nếu tạo mới
        appointment.setCustomerNotes(customerNotes);
        appointment.setStaffNotes(staffNotes);

        BigDecimal discountAmount = BigDecimal.ZERO;
        if (discountAmountStr != null && !discountAmountStr.trim().isEmpty()) {
            try {
                discountAmount = new BigDecimal(discountAmountStr);
                if (discountAmount.compareTo(BigDecimal.ZERO) < 0) {
                    request.setAttribute("errorMessage", "Số tiền giảm giá không thể âm.");
                    return null;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Số tiền giảm giá không hợp lệ.");
                return null;
            }
        }
        appointment.setDiscountAmount(discountAmount);

        return appointment;
    }

    private List<AppointmentDetail> parseAppointmentDetails(HttpServletRequest request, int appointmentId) throws SQLException {
        List<AppointmentDetail> details = new ArrayList<>();
        String[] serviceIds = request.getParameterValues("serviceId");
        String[] nailArtIds = request.getParameterValues("nailArtId"); // Sẽ có cùng số lượng với serviceIds
        String[] quantities = request.getParameterValues("quantity");   // Sẽ có cùng số lượng với serviceIds

        BigDecimal totalBasePrice = BigDecimal.ZERO;
        BigDecimal totalAddonPrice = BigDecimal.ZERO;
        int totalDuration = 0;

        if (serviceIds != null) {
            for (int i = 0; i < serviceIds.length; i++) {
                if (serviceIds[i] == null || serviceIds[i].trim().isEmpty()) continue;

                int serviceId = Integer.parseInt(serviceIds[i]);
                Service service = serviceDAO.getServiceById(serviceId);
                if (service == null) continue; // Bỏ qua nếu service không tồn tại

                AppointmentDetail detail = new AppointmentDetail();
                detail.setAppointmentId(appointmentId); // Sẽ được set đúng khi lưu appointment chính
                detail.setServiceId(serviceId);
                detail.setServicePriceAtBooking(service.getPrice());

                int quantity = 1;
                if (quantities != null && quantities.length > i && quantities[i] != null && !quantities[i].isEmpty()) {
                    try {
                        quantity = Integer.parseInt(quantities[i]);
                        if (quantity <=0) quantity = 1;
                    } catch (NumberFormatException e) { quantity = 1; }
                }
                detail.setQuantity(quantity);

                totalBasePrice = totalBasePrice.add(service.getPrice().multiply(new BigDecimal(quantity)));
                totalDuration += (service.getDurationMinutes() * quantity);

                if (nailArtIds != null && nailArtIds.length > i && nailArtIds[i] != null && !nailArtIds[i].trim().isEmpty() && !nailArtIds[i].equals("0")) {
                    int nailArtId = Integer.parseInt(nailArtIds[i]);
                    NailArt nailArt = nailArtDAO.getNailArtById(nailArtId);
                    if (nailArt != null) {
                        detail.setNailArtId(nailArtId);
                        detail.setNailArtPriceAtBooking(nailArt.getPriceAddon());
                        totalAddonPrice = totalAddonPrice.add(nailArt.getPriceAddon().multiply(new BigDecimal(quantity)));
                        // Giả sử thời gian mẫu nail đã bao gồm trong dịch vụ hoặc không đáng kể
                    }
                } else {
                    detail.setNailArtPriceAtBooking(BigDecimal.ZERO);
                }
                details.add(detail);
            }
        }
        // Lưu các tổng này vào request để set cho Appointment object
        request.setAttribute("calculatedBasePrice", totalBasePrice);
        request.setAttribute("calculatedAddonPrice", totalAddonPrice);
        request.setAttribute("calculatedDuration", totalDuration);
        return details;
    }


    private void insertAppointment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ParseException, ServletException {

        Appointment appointment = parseAndValidateAppointmentData(request, null);
        if (appointment == null) { // Có lỗi validate
            loadCommonDataForForm(request); // Nạp lại data cho form
            // Giữ lại các giá trị đã nhập bằng cách setAttribute cho 'appointmentDraft' hoặc từng trường
            request.getRequestDispatcher("/WEB-INF/jsp/admin/appointment_form.jsp").forward(request, response);
            return;
        }

        List<AppointmentDetail> details = parseAppointmentDetails(request, 0); // appointmentId tạm thời là 0
        if (details.isEmpty()) {
            request.setAttribute("errorMessage", "Cần chọn ít nhất một dịch vụ.");
            loadCommonDataForForm(request);
            request.setAttribute("appointmentDraft", appointment); // Gửi lại appointment đã parse
            request.getRequestDispatcher("/WEB-INF/jsp/admin/appointment_form.jsp").forward(request, response);
            return;
        }

        appointment.setTotalBasePrice((BigDecimal) request.getAttribute("calculatedBasePrice"));
        appointment.setTotalAddonPrice((BigDecimal) request.getAttribute("calculatedAddonPrice"));
        appointment.setEstimatedDurationMinutes((Integer) request.getAttribute("calculatedDuration"));
        // finalAmount sẽ được tính bởi DB (GENERATED column) hoặc bạn có thể tính ở đây
        // appointment.setFinalAmount(appointment.getTotalBasePrice().add(appointment.getTotalAddonPrice()).subtract(appointment.getDiscountAmount()));


        int newAppointmentId = appointmentDAO.addAppointment(appointment, details);
        if (newAppointmentId > 0) {
            response.sendRedirect(request.getContextPath() + "/admin/appointments/view?id=" + newAppointmentId);
        } else {
            request.setAttribute("errorMessage", "Không thể tạo lịch hẹn. Vui lòng thử lại.");
            loadCommonDataForForm(request);
            request.setAttribute("appointmentDraft", appointment);
            request.getRequestDispatcher("/WEB-INF/jsp/admin/appointment_form.jsp").forward(request, response);
        }
    }

    private void updateAppointment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ParseException, ServletException {
        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        Appointment existingAppointment = appointmentDAO.getAppointmentById(appointmentId);
        if (existingAppointment == null) {
            response.sendRedirect(request.getContextPath() + "/admin/appointments/list?error=notfound_update");
            return;
        }

        Appointment appointment = parseAndValidateAppointmentData(request, existingAppointment);
        if (appointment == null) { // Có lỗi validate
            // Lấy lại details cũ để hiển thị trên form
            List<AppointmentDetail> oldDetails = appointmentDetailDAO.getDetailsByAppointmentId(appointmentId);
            request.setAttribute("appointment", existingAppointment); // appointment cũ để lấy ID và các giá trị
            request.setAttribute("details", oldDetails);
            loadCommonDataForForm(request);
            request.getRequestDispatcher("/WEB-INF/jsp/admin/appointment_form.jsp").forward(request, response);
            return;
        }

        // Xóa details cũ và thêm details mới (cách đơn giản, có thể tối ưu hơn)
        appointmentDetailDAO.deleteDetailsByAppointmentId(appointmentId, null); // Cần connection nếu muốn transaction
        List<AppointmentDetail> newDetails = parseAppointmentDetails(request, appointmentId);

        if (newDetails.isEmpty()) {
            request.setAttribute("errorMessage", "Cần chọn ít nhất một dịch vụ.");
            request.setAttribute("appointment", existingAppointment);
            request.setAttribute("details", new ArrayList<AppointmentDetail>()); // Hoặc giữ details cũ nếu muốn
            loadCommonDataForForm(request);
            request.getRequestDispatcher("/WEB-INF/jsp/admin/appointment_form.jsp").forward(request, response);
            return;
        }

        for (AppointmentDetail detail : newDetails) {
            appointmentDetailDAO.addAppointmentDetail(detail, null); // Cần connection nếu muốn transaction
        }

        appointment.setAppointmentId(appointmentId); // Đảm bảo ID đúng
        appointment.setTotalBasePrice((BigDecimal) request.getAttribute("calculatedBasePrice"));
        appointment.setTotalAddonPrice((BigDecimal) request.getAttribute("calculatedAddonPrice"));
        appointment.setEstimatedDurationMinutes((Integer) request.getAttribute("calculatedDuration"));

        boolean success = appointmentDAO.updateAppointment(appointment);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/appointments/view?id=" + appointmentId);
        } else {
            request.setAttribute("errorMessage", "Không thể cập nhật lịch hẹn. Vui lòng thử lại.");
            request.setAttribute("appointment", existingAppointment);
            request.setAttribute("details", newDetails); // Gửi lại newDetails để fill form
            loadCommonDataForForm(request);
            request.getRequestDispatcher("/WEB-INF/jsp/admin/appointment_form.jsp").forward(request, response);
        }
    }

}