package com.tiemnail.app.controller;

import com.tiemnail.app.dao.AppointmentDAO;
import com.tiemnail.app.dao.ReviewDAO;
import com.tiemnail.app.dao.StaffDAO;
import com.tiemnail.app.model.Appointment;
import com.tiemnail.app.model.Review;
import com.tiemnail.app.model.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.sql.Timestamp;

@WebServlet("/customer/review/*")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReviewDAO reviewDAO;
    private AppointmentDAO appointmentDAO;
    private StaffDAO staffDAO;

    public void init() {
        reviewDAO = new ReviewDAO();
        appointmentDAO = new AppointmentDAO();
        staffDAO = new StaffDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI());
            return;
        }
        User loggedInCustomer = (User) session.getAttribute("loggedInUser");
        if (!"customer".equals(loggedInCustomer.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chức năng này chỉ dành cho khách hàng.");
            return;
        }

        String action = request.getPathInfo();
        if (action == null || action.equals("/") || action.equals("/new")) {
            try {
                showReviewForm(request, response, loggedInCustomer);
            } catch (SQLException e) {
                throw new ServletException("Lỗi khi hiển thị form đánh giá", e);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
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
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getPathInfo();
        if ("/submit".equals(action)) {
            try {
                submitReview(request, response, loggedInCustomer);
            } catch (SQLException e) {
                throw new ServletException("Lỗi khi lưu đánh giá", e);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }


    private void showReviewForm(HttpServletRequest request, HttpServletResponse response, User customer)
            throws SQLException, ServletException, IOException {
        String appointmentIdStr = request.getParameter("appointmentId");
        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Cần có ID lịch hẹn để đánh giá.");
            response.sendRedirect(request.getContextPath() + "/customer/my-appointments/list");
            return;
        }

        int appointmentId = Integer.parseInt(appointmentIdStr);
        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

        if (appointment == null || appointment.getCustomerId() == null || appointment.getCustomerId() != customer.getUserId()) {
            request.getSession().setAttribute("errorMessage", "Không tìm thấy lịch hẹn hoặc bạn không có quyền đánh giá lịch hẹn này.");
            response.sendRedirect(request.getContextPath() + "/customer/my-appointments/list");
            return;
        }

        if (!"completed".equals(appointment.getStatus())) {
            request.getSession().setAttribute("errorMessage", "Chỉ có thể đánh giá các lịch hẹn đã hoàn tất.");
            response.sendRedirect(request.getContextPath() + "/customer/my-appointments/view?id=" + appointmentId);
            return;
        }

        Review existingReview = reviewDAO.getReviewByAppointmentId(appointmentId);
        if (existingReview != null) {
            request.getSession().setAttribute("infoMessage", "Bạn đã đánh giá lịch hẹn này rồi.");
            response.sendRedirect(request.getContextPath() + "/customer/my-appointments/view?id=" + appointmentId);
            return;
        }

        request.setAttribute("appointment", appointment);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/review_form.jsp");
        dispatcher.forward(request, response);
    }

    private void submitReview(HttpServletRequest request, HttpServletResponse response, User customer)
            throws SQLException, IOException, ServletException {
        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        int ratingScore = Integer.parseInt(request.getParameter("ratingScore"));
        String comment = request.getParameter("comment");

        Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
        if (appointment == null || appointment.getCustomerId() == null || appointment.getCustomerId() != customer.getUserId() || appointment.getStaffId() == null) {
            request.setAttribute("errorMessage", "Lịch hẹn không hợp lệ để đánh giá.");
            showReviewFormOnError(request,response,customer,appointmentId);
            return;
        }
        if (!"completed".equals(appointment.getStatus())) {
            request.setAttribute("errorMessage", "Chỉ có thể đánh giá lịch hẹn đã hoàn tất.");
            showReviewFormOnError(request,response,customer,appointmentId);
            return;
        }
        if (reviewDAO.getReviewByAppointmentId(appointmentId) != null) {
            request.setAttribute("errorMessage", "Bạn đã đánh giá lịch hẹn này.");
            showReviewFormOnError(request,response,customer,appointmentId);
            return;
        }


        Review newReview = new Review();
        newReview.setAppointmentId(appointmentId);
        newReview.setCustomerId(customer.getUserId());
        newReview.setStaffId(appointment.getStaffId());
        newReview.setRatingScore(ratingScore);
        newReview.setComment(comment);
        newReview.setReviewDate(new Timestamp(System.currentTimeMillis()));

        boolean success = reviewDAO.addReview(newReview);

        if (success) {
            // Cập nhật average_rating cho nhân viên
            double newAvgRating = reviewDAO.getAverageRatingForStaff(appointment.getStaffId());
            com.tiemnail.app.model.Staff staffToUpdate = staffDAO.getStaffById(appointment.getStaffId());
            if(staffToUpdate != null) {
                staffToUpdate.setAverageRating(new BigDecimal(newAvgRating).setScale(2, RoundingMode.HALF_UP));
                staffDAO.updateStaff(staffToUpdate);
            }

            request.getSession().setAttribute("successMessage", "Cảm ơn bạn đã gửi đánh giá!");
            response.sendRedirect(request.getContextPath() + "/customer/my-appointments/view?id=" + appointmentId);
        } else {
            request.setAttribute("errorMessage", "Không thể gửi đánh giá. Vui lòng thử lại.");
            showReviewFormOnError(request,response,customer,appointmentId);
        }
    }

    private void showReviewFormOnError(HttpServletRequest request, HttpServletResponse response, User customer, int appointmentId)
            throws ServletException, IOException {
        try {
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            request.setAttribute("appointment", appointment);
        } catch (SQLException e) {
            // ignore, error message is already set
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/review_form.jsp");
        dispatcher.forward(request, response);
    }
}