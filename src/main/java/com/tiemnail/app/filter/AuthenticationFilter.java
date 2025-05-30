package com.tiemnail.app.filter;

import com.tiemnail.app.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    private ServletContext context;
    private static final Set<String> ALLOWED_PATHS = new HashSet<>(Arrays.asList(
            "/login", "/register", "/logout", "/index.jsp", "/"
    ));
    private static final Set<String> ALLOWED_PREFIXES = new HashSet<>(Arrays.asList(
            "/css", "/js", "/images", "/fonts", "/uploads"
    ));

    public void init(FilterConfig fConfig) throws ServletException {
        this.context = fConfig.getServletContext();
        this.context.log("AuthenticationFilter initialized");
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        this.context.log("Requested Path: " + path);

        boolean isLoggedIn = (session != null && session.getAttribute("loggedInUser") != null);
        User loggedInUser = isLoggedIn ? (User) session.getAttribute("loggedInUser") : null;

        // 1. Kiểm tra các đường dẫn được phép truy cập công khai hoặc các file tĩnh
        if (isPathAllowed(path)) {
            this.context.log("Public path, allowing request.");
            chain.doFilter(request, response);
            return;
        }

        // 2. Nếu chưa đăng nhập và request một trang cần bảo vệ
        if (!isLoggedIn) {
            this.context.log("User not logged in, redirecting to login page.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // 3. Đã đăng nhập, kiểm tra quyền truy cập các trang admin
        if (path.startsWith("/admin")) {
            if (loggedInUser != null && ("admin".equals(loggedInUser.getRole()) || "staff".equals(loggedInUser.getRole()) || "cashier".equals(loggedInUser.getRole()))) {
                // Người dùng là admin, staff hoặc cashier, cho phép truy cập trang admin
                this.context.log("Admin/Staff/Cashier access to admin path, allowing request.");
                chain.doFilter(request, response);
            } else {
                // Không có quyền admin/staff/cashier, chuyển hướng hoặc báo lỗi
                this.context.log("User does not have admin/staff/cashier role, access denied to admin path.");
                // Có thể chuyển về trang chủ của customer hoặc trang lỗi "Access Denied"
                // httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/"); // Chuyển về trang chủ customer
            }
            return;
        }

        // 4. Các trang khác yêu cầu đăng nhập (ví dụ: trang quản lý lịch hẹn của customer)
        // Ví dụ: if (path.startsWith("/customer/profile") || path.startsWith("/customer/appointments")) { ... }
        // Hiện tại, nếu đã đăng nhập và không phải trang admin, cho qua
        this.context.log("Logged in user, allowing access to non-admin protected path.");
        chain.doFilter(request, response);
    }

    private boolean isPathAllowed(String path) {
        if (ALLOWED_PATHS.contains(path)) {
            return true;
        }
        for (String prefix : ALLOWED_PREFIXES) {
            if (path.startsWith(prefix)) {
                return true;
            }
        }
        return false;
    }

    public void destroy() {
        //cleanup operations
    }
}