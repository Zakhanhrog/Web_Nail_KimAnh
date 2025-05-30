package com.tiemnail.app.controller;

import com.tiemnail.app.dao.UserDAO;
import com.tiemnail.app.model.User;
import com.tiemnail.app.util.PasswordUtil; // Import PasswordUtil

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/users/*")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
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
                    showNewUserForm(request, response);
                    break;
                case "/insert":
                    insertUser(request, response);
                    break;
                case "/edit":
                    showEditUserForm(request, response);
                    break;
                case "/update":
                    updateUser(request, response);
                    break;
                case "/toggle_status":
                    toggleUserStatus(request, response);
                    break;
                default:
                    listUsers(request, response);
                    break;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            throw new ServletException("Database error: " + ex.getMessage(), ex);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<User> listUser = userDAO.getAllUsers();
        request.setAttribute("listUser", listUser);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/user_list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewUserForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/user_form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditUserForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User existingUser = userDAO.getUserById(id);
        if (existingUser == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            return;
        }
        request.setAttribute("user", existingUser);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/user_form.jsp");
        dispatcher.forward(request, response);
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String role = request.getParameter("role");
        boolean isActive = "on".equalsIgnoreCase(request.getParameter("isActive"));

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty() || fullName == null || fullName.trim().isEmpty() || role == null || role.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ các trường bắt buộc (Email, Mật khẩu, Họ tên, Vai trò).");
            showNewUserForm(request, response);
            return;
        }

        User existingUserByEmail = userDAO.getUserByEmail(email);
        if (existingUserByEmail != null) {
            request.setAttribute("errorMessage", "Email đã tồn tại trong hệ thống.");
            User userToFillForm = new User();
            userToFillForm.setEmail(email);
            userToFillForm.setFullName(fullName);
            userToFillForm.setPhoneNumber(phoneNumber);
            userToFillForm.setRole(role);
            userToFillForm.setActive(isActive);
            request.setAttribute("user", userToFillForm);
            showNewUserForm(request, response);
            return;
        }

        User newUser = new User();
        newUser.setEmail(email);
        String hashedPassword = PasswordUtil.hashPassword(password); // HASH MẬT KHẨU
        newUser.setPasswordHash(hashedPassword);
        newUser.setFullName(fullName);
        newUser.setPhoneNumber(phoneNumber);
        newUser.setRole(role);
        newUser.setActive(isActive);

        userDAO.addUser(newUser);
        response.sendRedirect(request.getContextPath() + "/admin/users/list");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("userId"));
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String role = request.getParameter("role");
        boolean isActive = "on".equalsIgnoreCase(request.getParameter("isActive"));

        if (email == null || email.trim().isEmpty() || fullName == null || fullName.trim().isEmpty() || role == null || role.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ các trường bắt buộc (Email, Họ tên, Vai trò).");
            User existingUser = userDAO.getUserById(id);
            request.setAttribute("user", existingUser);
            showEditUserForm(request, response);
            return;
        }

        User existingUser = userDAO.getUserById(id);
        if (existingUser == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found for update");
            return;
        }

        User userByNewEmail = userDAO.getUserByEmail(email);
        if (userByNewEmail != null && userByNewEmail.getUserId() != id) {
            request.setAttribute("errorMessage", "Email '" + email + "' đã được sử dụng bởi một tài khoản khác.");
            request.setAttribute("user", existingUser);
            showEditUserForm(request, response);
            return;
        }

        existingUser.setEmail(email);
        existingUser.setFullName(fullName);
        existingUser.setPhoneNumber(phoneNumber);
        existingUser.setRole(role);
        existingUser.setActive(isActive);

        if (password != null && !password.trim().isEmpty()) {
            String hashedPassword = PasswordUtil.hashPassword(password); // HASH MẬT KHẨU MỚI
            existingUser.setPasswordHash(hashedPassword);
        }

        userDAO.updateUser(existingUser);
        response.sendRedirect(request.getContextPath() + "/admin/users/list");
    }

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User user = userDAO.getUserById(id);
        if (user != null) {
            user.setActive(!user.isActive());
            userDAO.updateUser(user);
        }
        response.sendRedirect(request.getContextPath() + "/admin/users/list");
    }
}