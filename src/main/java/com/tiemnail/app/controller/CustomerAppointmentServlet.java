package com.tiemnail.app.controller;

import com.tiemnail.app.dao.AppointmentDAO;
import com.tiemnail.app.dao.AppointmentDetailDAO;
import com.tiemnail.app.dao.ServiceDAO;
import com.tiemnail.app.dao.NailArtDAO;
import com.tiemnail.app.dao.UserDAO;
import com.tiemnail.app.dao.ReviewDAO;
import com.tiemnail.app.model.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Calendar;
import java.util.Map;

@WebServlet("/customer/my-appointments/*")
public class CustomerAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    private AppointmentDetailDAO appointmentDetailDAO;
    private UserDAO userDAO;
    private ServiceDAO serviceDAO;
    private NailArtDAO nailArtDAO;
    private ReviewDAO reviewDAO;

    public void init() {
        appointmentDAO = new AppointmentDAO();
        appointmentDetailDAO = new AppointmentDetailDAO();
        userDAO = new UserDAO();
        serviceDAO = new ServiceDAO();
        nailArtDAO = new NailArtDAO();
        reviewDAO = new ReviewDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            String targetUrl = request.getRequestURI();
            if (request.getQueryString() != null) {
                targetUrl += "?" + request.getQueryString();
            }
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + java.net.URLEncoder.encode(targetUrl, "UTF-8"));
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"customer".equals(loggedInUser.getRole())) {
            request.setAttribute("pageErrorMessage", "Chức năng này chỉ dành cho khách hàng. Tài khoản của bạn có vai trò: " + loggedInUser.getRole());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/my_appointment_list.jsp");
            dispatcher.forward(request, response);
            return;
        }

        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }

        try {
            switch (action) {
                case "/view":
                    viewMyAppointmentDetail(request, response, loggedInUser);
                    break;
                case "/cancel":
                    cancelMyAppointment(request, response, loggedInUser);
                    break;
                default:
                    listMyAppointmentHistory(request, response, loggedInUser);
                    break;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("pageErrorMessage", "Lỗi cơ sở dữ liệu khi xử lý lịch hẹn của bạn: " + ex.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/my_appointment_list.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException ex) {
            ex.printStackTrace();
            request.setAttribute("pageErrorMessage", "Mã lịch hẹn không hợp lệ.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/my_appointment_list.jsp");
            dispatcher.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            String targetUrl = request.getRequestURI();
            if (request.getQueryString() != null) {
                targetUrl += "?" + request.getQueryString();
            }
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + java.net.URLEncoder.encode(targetUrl, "UTF-8"));
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"customer".equals(loggedInUser.getRole())) {
            request.setAttribute("pageErrorMessage", "Chức năng này chỉ dành cho khách hàng. Tài khoản của bạn có vai trò: " + loggedInUser.getRole());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/my_appointment_list.jsp");
            dispatcher.forward(request, response);
            return;
        }
        doGet(request, response);
    }

    private void listMyAppointmentHistory(HttpServletRequest request, HttpServletResponse response, User customer)
            throws SQLException, IOException, ServletException {
        List<Appointment> myAppointments = appointmentDAO.getAppointmentsByCustomerId(customer.getUserId());
        Map<Integer, Review> reviewsMap = new HashMap<>();

        if (myAppointments != null) {
            for (Appointment app : myAppointments) {
                if ("completed".equals(app.getStatus())) {
                    Review review = reviewDAO.getReviewByAppointmentId(app.getAppointmentId());
                    if (review != null) {
                        reviewsMap.put(app.getAppointmentId(), review);
                    }
                }
            }
        }

        request.setAttribute("myAppointments", myAppointments);
        request.setAttribute("reviewsMap", reviewsMap);
        request.setAttribute("userDAO", userDAO);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/my_appointment_list.jsp");
        dispatcher.forward(request, response);
    }

    private void viewMyAppointmentDetail(HttpServletRequest request, HttpServletResponse response, User customer)
            throws SQLException, IOException, ServletException {
        int appointmentId = 0;
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            request.setAttribute("pageErrorMessage", "Thiếu mã lịch hẹn.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/my_appointment_list.jsp");
            dispatcher.forward(request, response);
            return;
        }
        try {
            appointmentId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            request.setAttribute("pageErrorMessage", "Mã lịch hẹn không hợp lệ.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/my_appointment_list.jsp");
            dispatcher.forward(request, response);
            return;
        }

        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

        if (appointment == null || appointment.getCustomerId() == null || appointment.getCustomerId() != customer.getUserId()) {
            request.setAttribute("pageErrorMessage", "Không tìm thấy lịch hẹn hoặc bạn không có quyền xem lịch hẹn này.");
            listMyAppointmentHistory(request, response, customer);
            return;
        }

        List<AppointmentDetail> details = appointmentDetailDAO.getDetailsByAppointmentId(appointmentId);
        request.setAttribute("appointment", appointment);
        request.setAttribute("details", details);
        request.setAttribute("userDAO", userDAO);
        request.setAttribute("serviceDAO", serviceDAO);
        request.setAttribute("nailArtDAO", nailArtDAO);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/my_appointment_view.jsp");
        dispatcher.forward(request, response);
    }


    private void cancelMyAppointment(HttpServletRequest request, HttpServletResponse response, User customer)
            throws SQLException, IOException, ServletException {
        int appointmentId = 0;
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            request.setAttribute("pageErrorMessage", "Thiếu mã lịch hẹn để hủy.");
            listMyAppointmentHistory(request, response, customer);
            return;
        }
        try {
            appointmentId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            request.setAttribute("pageErrorMessage", "Mã lịch hẹn không hợp lệ để hủy.");
            listMyAppointmentHistory(request, response, customer);
            return;
        }

        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

        if (appointment == null || appointment.getCustomerId() == null || appointment.getCustomerId() != customer.getUserId()) {
            request.setAttribute("pageErrorMessage", "Không tìm thấy lịch hẹn hoặc bạn không có quyền hủy lịch hẹn này.");
            listMyAppointmentHistory(request, response, customer);
            return;
        }

        boolean canCancel = false;
        String currentStatus = appointment.getStatus();
        if ("pending_confirmation".equals(currentStatus) || "confirmed".equals(currentStatus)) {
            Timestamp appointmentTime = appointment.getAppointmentDatetime();
            Calendar nowPlusBuffer = Calendar.getInstance();
            nowPlusBuffer.add(Calendar.HOUR_OF_DAY, 24);

            Calendar appointmentCal = Calendar.getInstance();
            appointmentCal.setTime(appointmentTime);

            if (appointmentCal.after(nowPlusBuffer)) {
                canCancel = true;
            } else {
                request.getSession().setAttribute("errorMessage", "Đã quá thời gian cho phép hủy lịch hẹn này. Bạn chỉ có thể hủy trước ít nhất 24 giờ.");
            }
        } else {
            request.getSession().setAttribute("errorMessage", "Lịch hẹn này không thể hủy do trạng thái hiện tại ('" + currentStatus + "').");
        }

        if (canCancel) {
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, "cancelled_by_customer");
            if (success) {
                request.getSession().setAttribute("successMessage", "Lịch hẹn (ID: " + appointmentId + ") đã được hủy thành công.");
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể hủy lịch hẹn. Vui lòng thử lại hoặc liên hệ hỗ trợ.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/customer/my-appointments/list");
    }
}