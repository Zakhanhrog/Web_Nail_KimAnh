package com.tiemnail.app.controller;

import com.tiemnail.app.dao.ServiceDAO;
import com.tiemnail.app.model.Service;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/services")
public class CustomerServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ServiceDAO serviceDAO;

    public void init() {
        serviceDAO = new ServiceDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String categoryFilter = request.getParameter("category");

        try {
            List<Service> listService;
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                listService = serviceDAO.getServicesByCategory(categoryFilter, true); // Chỉ lấy active services
            } else {
                listService = serviceDAO.getAllServices(true);
            }

            request.setAttribute("listService", listService);
            request.setAttribute("selectedCategory", categoryFilter);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/service_catalog.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException ex) {
            ex.printStackTrace();
            throw new ServletException("Lỗi truy cập cơ sở dữ liệu khi lấy danh sách dịch vụ.", ex);
        }
    }
}