package com.tiemnail.app.controller;

import com.tiemnail.app.dao.AppointmentDAO;
import com.tiemnail.app.dao.AppointmentDetailDAO; // Thêm nếu muốn lấy chi tiết dịch vụ
import com.tiemnail.app.model.Appointment;
import com.tiemnail.app.model.AppointmentDetail; // Thêm nếu muốn lấy chi tiết dịch vụ
import com.tiemnail.app.model.Service; // Thêm nếu muốn lấy tên dịch vụ từ chi tiết
import com.tiemnail.app.model.User;    // Để kiểm tra người dùng đăng nhập

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List; // Thêm nếu muốn lấy chi tiết dịch vụ

@WebServlet("/customer/booking-success") // Đảm bảo URL pattern này khớp với redirect
public class BookingSuccessServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    private AppointmentDetailDAO appointmentDetailDAO; // Khai báo
    // private ServiceDAO serviceDAO; // Nếu cần lấy thông tin Service đầy đủ từ AppointmentDetail

    public void init() {
        appointmentDAO = new AppointmentDAO();
        appointmentDetailDAO = new AppointmentDetailDAO(); // Khởi tạo
        // serviceDAO = new ServiceDAO();
        System.out.println("BookingSuccessServlet initialized.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        System.out.println("BookingSuccessServlet doGet called.");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            System.out.println("BookingSuccessServlet: User not logged in. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        String appointmentIdStr = request.getParameter("appointmentId");
        System.out.println("BookingSuccessServlet: Received appointmentId parameter: " + appointmentIdStr);

        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            System.out.println("BookingSuccessServlet: No appointmentId parameter found. Redirecting to customer dashboard.");
            // Nếu không có appointmentId, có thể redirect về trang dashboard của customer
            response.sendRedirect(request.getContextPath() + "/customer/dashboard"); // Hoặc trang chủ
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            System.out.println("BookingSuccessServlet: Parsed appointmentId: " + appointmentId);
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

            if (appointment != null) {
                System.out.println("BookingSuccessServlet: Found appointment with ID: " + appointment.getAppointmentId());
                // Bảo mật: Chỉ cho phép chủ nhân của lịch hẹn hoặc admin xem
                if (loggedInUser.getUserId() == appointment.getCustomerId() || "admin".equals(loggedInUser.getRole())) {
                    request.setAttribute("appointment", appointment); // Set appointment để JSP có thể dùng (nếu cần)

                    // Lấy chi tiết dịch vụ cho lịch hẹn này (tùy chọn, nếu JSP của bạn cần)
                    // List<AppointmentDetail> details = appointmentDetailDAO.getDetailsByAppointmentId(appointmentId);
                    // if (details != null && !details.isEmpty()) {
                    //    // Nếu AppointmentDetail của bạn không chứa tên dịch vụ, bạn có thể cần lặp qua và lấy từ ServiceDAO
                    //    // Hoặc sửa AppointmentDetailDAO.getDetailsByAppointmentId để join và lấy luôn tên dịch vụ
                    //    System.out.println("BookingSuccessServlet: Found " + details.size() + " details for appointment " + appointmentId);
                    //    request.setAttribute("appointmentDetails", details);
                    // } else {
                    //    System.out.println("BookingSuccessServlet: No details found for appointment " + appointmentId);
                    // }

                } else {
                    System.out.println("BookingSuccessServlet: User " + loggedInUser.getUserId() + " (role: " + loggedInUser.getRole() + ") attempted to access appointment " + appointmentId + " owned by customer " + appointment.getCustomerId());
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem chi tiết lịch hẹn này.");
                    return;
                }
            } else {
                System.out.println("BookingSuccessServlet: Appointment with ID " + appointmentId + " not found.");
                request.setAttribute("errorMessage", "Không tìm thấy thông tin lịch hẹn với mã cung cấp.");
            }

        } catch (NumberFormatException e) {
            System.err.println("BookingSuccessServlet: Invalid appointmentId format: " + appointmentIdStr + ". Error: " + e.getMessage());
            request.setAttribute("errorMessage", "Mã lịch hẹn không hợp lệ.");
        } catch (SQLException e) {
            System.err.println("BookingSuccessServlet: SQLException while retrieving appointment data. Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi truy vấn dữ liệu lịch hẹn.");
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/booking-success.jsp");
        dispatcher.forward(request, response);
    }
}