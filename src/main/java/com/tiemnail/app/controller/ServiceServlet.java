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
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/services/*")
public class ServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ServiceDAO serviceDAO;

    public void init() {
        serviceDAO = new ServiceDAO();
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
            action = "/list"; // Mặc định là list
        }

        try {
            switch (action) {
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/insert":
                    insertService(request, response);
                    break;
                case "/delete":
                    deleteService(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateService(request, response);
                    break;
                default: // "/list" hoặc các trường hợp khác
                    listServices(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listServices(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<Service> listService = serviceDAO.getAllServices(false); // Lấy cả active và inactive
        request.setAttribute("listService", listService);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/service_list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/service_form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Service existingService = serviceDAO.getServiceById(id);
        request.setAttribute("service", existingService);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/service_form.jsp");
        dispatcher.forward(request, response);
    }

    private void insertService(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String name = request.getParameter("serviceName");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int duration = Integer.parseInt(request.getParameter("durationMinutes"));
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("imageUrl");
        boolean isActive = "on".equalsIgnoreCase(request.getParameter("isActive")); // Checkbox

        Service newService = new Service();
        newService.setServiceName(name);
        newService.setDescription(description);
        newService.setPrice(price);
        newService.setDurationMinutes(duration);
        newService.setCategory(category);
        newService.setImageUrl(imageUrl);
        newService.setActive(isActive);

        serviceDAO.addService(newService);
        response.sendRedirect(request.getContextPath() + "/admin/services/list");
    }

    private void updateService(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("serviceId"));
        String name = request.getParameter("serviceName");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int duration = Integer.parseInt(request.getParameter("durationMinutes"));
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("imageUrl");
        boolean isActive = "on".equalsIgnoreCase(request.getParameter("isActive"));

        Service service = new Service();
        service.setServiceId(id);
        service.setServiceName(name);
        service.setDescription(description);
        service.setPrice(price);
        service.setDurationMinutes(duration);
        service.setCategory(category);
        service.setImageUrl(imageUrl);
        service.setActive(isActive);
        // Lấy giá trị createdAt, updatedAt từ DB nếu không muốn nó bị reset
        // Hoặc để DB tự cập nhật updatedAt

        serviceDAO.updateService(service);
        response.sendRedirect(request.getContextPath() + "/admin/services/list");
    }

    private void deleteService(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        serviceDAO.deleteService(id); // Xóa mềm
        response.sendRedirect(request.getContextPath() + "/admin/services/list");
    }
}