package com.tiemnail.app.controller;

import com.tiemnail.app.dao.UserDAO;
import com.tiemnail.app.model.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/customer/profile/*")
public class UserProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
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
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        String action = request.getPathInfo();
        if (action == null || action.equals("/") || action.equals("/view")) {
            showProfile(request, response, loggedInUser);
        } else if (action.equals("/edit")) {
            showEditProfileForm(request, response, loggedInUser);
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
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        String action = request.getPathInfo();
        if ("/update".equals(action)) {
            try {
                updateProfile(request, response, loggedInUser);
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu khi cập nhật hồ sơ.");
                showEditProfileForm(request, response, loggedInUser);
            }
        } else if ("/change-password".equals(action)) { // Sẽ làm ở phần sau
            try {
                processChangePassword(request, response, loggedInUser);
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("passwordErrorMessage", "Lỗi cơ sở dữ liệu khi đổi mật khẩu.");
                showEditProfileForm(request, response, loggedInUser); // Hiển thị lại form với tab mật khẩu
            }
        }
        else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response, User loggedInUser)
            throws ServletException, IOException {
        request.setAttribute("userProfile", loggedInUser); // User từ session là đủ
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/profile_view.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditProfileForm(HttpServletRequest request, HttpServletResponse response, User loggedInUser)
            throws ServletException, IOException {
        request.setAttribute("userProfile", loggedInUser);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/profile_edit.jsp");
        dispatcher.forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User loggedInUser)
            throws SQLException, IOException, ServletException {
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        // Email thường không cho đổi hoặc cần quy trình xác minh phức tạp hơn
        // String email = request.getParameter("email");

        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Họ tên không được để trống.");
            request.setAttribute("userProfile", loggedInUser); // Gửi lại user cũ để form không trống
            showEditProfileForm(request, response, loggedInUser);
            return;
        }

        // Tạo một bản sao để cập nhật, không thay đổi trực tiếp user trong session trừ khi thành công
        User userToUpdate = userDAO.getUserById(loggedInUser.getUserId()); // Lấy bản mới nhất từ DB
        userToUpdate.setFullName(fullName);
        userToUpdate.setPhoneNumber(phoneNumber);
        // if (email != null && !email.trim().isEmpty() && !email.equals(userToUpdate.getEmail())) {
        //     User existingByNewEmail = userDAO.getUserByEmail(email);
        //     if (existingByNewEmail != null) {
        //         request.setAttribute("errorMessage", "Email mới đã được sử dụng.");
        //         showEditProfileForm(request, response, userToUpdate); // Hiển thị lại form với dữ liệu đã nhập
        //         return;
        //     }
        //     userToUpdate.setEmail(email); // Nếu cho phép đổi email
        // }


        boolean success = userDAO.updateUser(userToUpdate); // updateUser chỉ cập nhật các trường được phép

        if (success) {
            // Cập nhật lại thông tin user trong session
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", userToUpdate);
            request.getSession().setAttribute("successMessage", "Cập nhật thông tin hồ sơ thành công!");
            response.sendRedirect(request.getContextPath() + "/customer/profile/view");
        } else {
            request.setAttribute("errorMessage", "Không thể cập nhật hồ sơ. Vui lòng thử lại.");
            showEditProfileForm(request, response, userToUpdate);
        }
    }

    // --- PHẦN ĐỔI MẬT KHẨU SẼ THÊM VÀO ĐÂY ---
    private void processChangePassword(HttpServletRequest request, HttpServletResponse response, User loggedInUser)
            throws SQLException, IOException, ServletException {
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        if (newPassword == null || newPassword.trim().isEmpty() || newPassword.length() < 6) {
            request.setAttribute("passwordErrorMessage", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            showEditProfileForm(request, response, loggedInUser);
            return;
        }
        if (!newPassword.equals(confirmNewPassword)) {
            request.setAttribute("passwordErrorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
            showEditProfileForm(request, response, loggedInUser);
            return;
        }

        User userToUpdate = userDAO.getUserById(loggedInUser.getUserId());
        userToUpdate.setPasswordHash(com.tiemnail.app.util.PasswordUtil.hashPassword(newPassword)); // Sử dụng PasswordUtil

        boolean success = userDAO.updateUser(userToUpdate); // updateUser cần cập nhật cả password hash

        if (success) {
            request.getSession().setAttribute("passwordSuccessMessage", "Đổi mật khẩu thành công!");
            response.sendRedirect(request.getContextPath() + "/customer/profile/view");
        } else {
            request.setAttribute("passwordErrorMessage", "Không thể đổi mật khẩu. Vui lòng thử lại.");
            showEditProfileForm(request, response, loggedInUser);
        }
    }
}