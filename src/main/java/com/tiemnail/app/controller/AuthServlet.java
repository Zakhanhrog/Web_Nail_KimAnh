package com.tiemnail.app.controller;

import com.tiemnail.app.dao.UserDAO;
import com.tiemnail.app.model.User;
import com.tiemnail.app.util.PasswordUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/login":
                    processLogin(request, response);
                    break;
                case "/register":
                    processRegister(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException("Database error in AuthServlet: " + ex.getMessage(), ex);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getServletPath();

        switch (action) {
            case "/login":
                showLoginPage(request, response);
                break;
            case "/register":
                showRegisterPage(request, response);
                break;
            case "/logout":
                processLogout(request, response);
                break;
        }
    }

    private void showLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/login.jsp");
        dispatcher.forward(request, response);
    }

    private void showRegisterPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/register.jsp");
        dispatcher.forward(request, response);
    }

    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.getUserByEmail(email);

        if (user != null && user.isActive() && PasswordUtil.checkPassword(password, user.getPasswordHash())) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);

            // Phân luồng dựa trên vai trò
            if ("admin".equals(user.getRole()) || "staff".equals(user.getRole()) || "cashier".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard"); // Hoặc trang admin mặc định
            } else { // customer
                response.sendRedirect(request.getContextPath() + "/"); // Trang chủ khách hàng
            }
        } else {
            String errorMessage = "Email hoặc mật khẩu không đúng, hoặc tài khoản chưa được kích hoạt.";
            if (user != null && !user.isActive()) {
                errorMessage = "Tài khoản của bạn đã bị vô hiệu hóa.";
            }
            request.setAttribute("errorMessage", errorMessage);
            request.setAttribute("email", email); // Giữ lại email đã nhập
            showLoginPage(request, response);
        }
    }

    private void processRegister(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phoneNumber = request.getParameter("phoneNumber");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu và xác nhận mật khẩu không khớp.");
            fillRegisterFormOnError(request);
            showRegisterPage(request, response);
            return;
        }

        if (userDAO.getUserByEmail(email) != null) {
            request.setAttribute("errorMessage", "Email này đã được sử dụng.");
            fillRegisterFormOnError(request);
            showRegisterPage(request, response);
            return;
        }

        // Validate thêm các trường khác nếu cần
        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPasswordHash(PasswordUtil.hashPassword(password));
        newUser.setPhoneNumber(phoneNumber);
        newUser.setRole("customer");
        newUser.setActive(true);

        boolean success = userDAO.addUser(newUser);

        if (success) {
             HttpSession session = request.getSession();
             session.setAttribute("loggedInUser", newUser);
             response.sendRedirect(request.getContextPath() + "/");
            request.setAttribute("successMessage", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
            showLoginPage(request, response);
        } else {
            request.setAttribute("errorMessage", "Đã có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại.");
            fillRegisterFormOnError(request);
            showRegisterPage(request, response);
        }
    }

    private void fillRegisterFormOnError(HttpServletRequest request){
        request.setAttribute("fullName", request.getParameter("fullName"));
        request.setAttribute("email", request.getParameter("email"));
        request.setAttribute("phoneNumber", request.getParameter("phoneNumber"));
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false); // false: không tạo session mới nếu chưa có
        if (session != null) {
            session.invalidate(); // Xóa session
        }
        response.sendRedirect(request.getContextPath() + "/login"); // Chuyển về trang đăng nhập
    }
}