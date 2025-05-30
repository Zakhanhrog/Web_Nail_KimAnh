package com.tiemnail.app.controller;

import com.tiemnail.app.dao.StaffScheduleDAO;
import com.tiemnail.app.dao.UserDAO; // Để lấy danh sách nhân viên
import com.tiemnail.app.model.StaffSchedule;
import com.tiemnail.app.model.User; // Model User

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/admin/staff-schedules/*")
public class StaffScheduleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StaffScheduleDAO scheduleDAO;
    private UserDAO userDAO;

    public void init() {
        scheduleDAO = new StaffScheduleDAO();
        userDAO = new UserDAO();
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
                    showNewScheduleForm(request, response);
                    break;
                case "/insert":
                    insertSchedule(request, response);
                    break;
                case "/delete":
                    deleteSchedule(request, response);
                    break;
                case "/edit":
                    showEditScheduleForm(request, response);
                    break;
                case "/update":
                    updateSchedule(request, response);
                    break;
                default: // "/list"
                    listSchedules(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        } catch (ParseException e) {
            throw new ServletException("Error parsing date/time", e);
        }
    }

    private void loadStaffList(HttpServletRequest request) throws SQLException {
        // Lấy danh sách nhân viên (staff, admin, cashier) để chọn
        List<User> staffList = userDAO.getUsersByRole("staff");
        List<User> adminList = userDAO.getUsersByRole("admin");
        List<User> cashierList = userDAO.getUsersByRole("cashier");
        staffList.addAll(adminList);
        staffList.addAll(cashierList);
        request.setAttribute("staffList", staffList);
    }

    private void listSchedules(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Lấy tất cả lịch làm việc hoặc có thể filter theo ngày/tuần/nhân viên
        // Tạm thời lấy tất cả
        String staffIdParam = request.getParameter("staffId");
        List<StaffSchedule> listSchedule;
        if (staffIdParam != null && !staffIdParam.isEmpty()) {
            listSchedule = scheduleDAO.getSchedulesByStaffId(Integer.parseInt(staffIdParam));
            User staffMember = userDAO.getUserById(Integer.parseInt(staffIdParam));
            request.setAttribute("selectedStaffName", staffMember != null ? staffMember.getFullName() : "Không rõ");
        } else {
            // Không có DAO để lấy tất cả, nên cần bổ sung hoặc hiển thị theo từng nhân viên
            // Để đơn giản, ta yêu cầu chọn nhân viên
            listSchedule = new java.util.ArrayList<>(); // danh sách rỗng nếu chưa chọn
        }

        loadStaffList(request); // Load danh sách nhân viên cho dropdown filter
        request.setAttribute("listSchedule", listSchedule);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/staff_schedule_list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewScheduleForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        loadStaffList(request);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/staff_schedule_form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditScheduleForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        StaffSchedule existingSchedule = scheduleDAO.getScheduleById(id);
        request.setAttribute("schedule", existingSchedule);
        loadStaffList(request);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/staff_schedule_form.jsp");
        dispatcher.forward(request, response);
    }

    private void insertSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ParseException, ServletException {
        int staffId = Integer.parseInt(request.getParameter("staffId"));
        String workDateStr = request.getParameter("workDate"); // yyyy-MM-dd
        String startTimeStr = request.getParameter("startTime"); // HH:mm
        String endTimeStr = request.getParameter("endTime"); // HH:mm
        boolean isAvailable = "on".equalsIgnoreCase(request.getParameter("isAvailable"));

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

        Date workDate = new Date(dateFormat.parse(workDateStr).getTime());
        Time startTime = new Time(timeFormat.parse(startTimeStr).getTime());
        Time endTime = new Time(timeFormat.parse(endTimeStr).getTime());

        if (startTime.after(endTime) || startTime.equals(endTime)) {
            request.setAttribute("errorMessage", "Giờ bắt đầu phải trước giờ kết thúc.");
            loadStaffList(request);
            // Giữ lại giá trị đã nhập để fill lại form
            StaffSchedule scheduleToFill = new StaffSchedule();
            scheduleToFill.setStaffId(staffId);
            scheduleToFill.setWorkDate(workDate);
            // startTime, endTime không set lại vì đã có lỗi
            scheduleToFill.setAvailable(isAvailable);
            request.setAttribute("schedule", scheduleToFill);
            request.getRequestDispatcher("/WEB-INF/jsp/admin/staff_schedule_form.jsp").forward(request, response);
            return;
        }

        StaffSchedule newSchedule = new StaffSchedule();
        newSchedule.setStaffId(staffId);
        newSchedule.setWorkDate(workDate);
        newSchedule.setStartTime(startTime);
        newSchedule.setEndTime(endTime);
        newSchedule.setAvailable(isAvailable);

        try {
            scheduleDAO.addSchedule(newSchedule);
        } catch (SQLException e) {
            // Kiểm tra lỗi UNIQUE constraint (trùng lịch)
            if (e.getErrorCode() == 1062) { // Mã lỗi cho duplicate entry của MySQL
                request.setAttribute("errorMessage", "Lịch làm việc này đã tồn tại cho nhân viên.");
                loadStaffList(request);
                request.setAttribute("schedule", newSchedule); // Gửi lại dữ liệu đã nhập
                request.getRequestDispatcher("/WEB-INF/jsp/admin/staff_schedule_form.jsp").forward(request, response);
                return;
            } else {
                throw e; // Ném lại lỗi khác
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/staff-schedules/list?staffId=" + staffId);
    }

    private void updateSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ParseException, ServletException {
        int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
        int staffId = Integer.parseInt(request.getParameter("staffId"));
        String workDateStr = request.getParameter("workDate");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        boolean isAvailable = "on".equalsIgnoreCase(request.getParameter("isAvailable"));

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

        Date workDate = new Date(dateFormat.parse(workDateStr).getTime());
        Time startTime = new Time(timeFormat.parse(startTimeStr).getTime());
        Time endTime = new Time(timeFormat.parse(endTimeStr).getTime());

        StaffSchedule schedule = scheduleDAO.getScheduleById(scheduleId);
        if (schedule == null) {
            response.sendRedirect(request.getContextPath() + "/admin/staff-schedules/list?error=notfound");
            return;
        }

        if (startTime.after(endTime) || startTime.equals(endTime)) {
            request.setAttribute("errorMessage", "Giờ bắt đầu phải trước giờ kết thúc.");
            loadStaffList(request);
            request.setAttribute("schedule", schedule); // Giữ lại schedule cũ để edit
            request.getRequestDispatcher("/WEB-INF/jsp/admin/staff_schedule_form.jsp").forward(request, response);
            return;
        }

        schedule.setStaffId(staffId);
        schedule.setWorkDate(workDate);
        schedule.setStartTime(startTime);
        schedule.setEndTime(endTime);
        schedule.setAvailable(isAvailable);

        try {
            scheduleDAO.updateSchedule(schedule);
        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) {
                request.setAttribute("errorMessage", "Lịch làm việc cập nhật bị trùng với lịch khác.");
                loadStaffList(request);
                request.setAttribute("schedule", schedule);
                request.getRequestDispatcher("/WEB-INF/jsp/admin/staff_schedule_form.jsp").forward(request, response);
                return;
            } else {
                throw e;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/staff-schedules/list?staffId=" + staffId);
    }

    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        StaffSchedule schedule = scheduleDAO.getScheduleById(id);
        int staffIdToRedirect = (schedule != null) ? schedule.getStaffId() : 0;

        scheduleDAO.deleteSchedule(id);

        String redirectUrl = request.getContextPath() + "/admin/staff-schedules/list";
        if (staffIdToRedirect != 0) {
            redirectUrl += "?staffId=" + staffIdToRedirect;
        }
        response.sendRedirect(redirectUrl);
    }
}