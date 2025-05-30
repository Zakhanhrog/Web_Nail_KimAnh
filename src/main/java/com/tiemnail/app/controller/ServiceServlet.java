package com.tiemnail.app.controller;

import com.tiemnail.app.dao.ServiceDAO;
import com.tiemnail.app.model.Service;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/services/*")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50)
public class ServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ServiceDAO serviceDAO;

    // Đường dẫn tuyệt đối tới thư mục lưu trữ ngoài cho dịch vụ
    private static final String ABSOLUTE_SERVICE_STORAGE_PATH = "/Users/ngogiakhanh/Documents/TiemNailApp/images_app/TiemNailUploadStorage/services";
    private static final String RELATIVE_SERVICE_ACCESS_PATH_FOR_DB = "uploads/services";
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
            throws SQLException, IOException, ServletException {
        String name = request.getParameter("serviceName");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int duration = Integer.parseInt(request.getParameter("durationMinutes"));
        String category = request.getParameter("category");
        boolean isActive = "on".equalsIgnoreCase(request.getParameter("isActive"));

        String imageUrl = null;
        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            try {
                imageUrl = saveUploadedFile(filePart);
            } catch (IOException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi khi tải ảnh lên: " + e.getMessage());
                request.setAttribute("serviceName", name);
                request.setAttribute("description", description);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/service_form.jsp");
                dispatcher.forward(request, response);
                return;
            }
        }

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
            throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("serviceId"));
        String name = request.getParameter("serviceName");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int duration = Integer.parseInt(request.getParameter("durationMinutes"));
        String category = request.getParameter("category");
        boolean isActive = "on".equalsIgnoreCase(request.getParameter("isActive"));
        String existingImageUrl = request.getParameter("existingImageUrl");

        String imageUrl = existingImageUrl;
        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            try {
                imageUrl = saveUploadedFile(filePart);
            } catch (IOException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi khi tải ảnh mới lên: " + e.getMessage());
                request.setAttribute("service", serviceDAO.getServiceById(id));
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/service_form.jsp");
                dispatcher.forward(request, response);
                return;
            }
        }

        Service service = new Service();
        service.setServiceId(id);
        service.setServiceName(name);
        service.setDescription(description);
        service.setPrice(price);
        service.setDurationMinutes(duration);
        service.setCategory(category);
        service.setImageUrl(imageUrl);
        service.setActive(isActive);

        serviceDAO.updateService(service);
        response.sendRedirect(request.getContextPath() + "/admin/services/list");
    }

    private void deleteService(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        serviceDAO.deleteService(id); // Xóa mềm
        response.sendRedirect(request.getContextPath() + "/admin/services/list");
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                String originalFileName = s.substring(s.indexOf("=") + 2, s.length() - 1);
                return java.nio.file.Paths.get(originalFileName).getFileName().toString();
            }
        }
        return "";
    }

    private String saveUploadedFile(Part filePart) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        String originalFileName = extractFileName(filePart);
        if (originalFileName.isEmpty()) {
            return null;
        }
        String uniqueFileName = System.currentTimeMillis() + "_" + originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
        File uploadDir = new File(ABSOLUTE_SERVICE_STORAGE_PATH);
        if (!uploadDir.exists()) {
            if (!uploadDir.mkdirs()) {
                System.err.println("Không thể tạo thư mục upload: " + ABSOLUTE_SERVICE_STORAGE_PATH);
                throw new IOException("Không thể tạo thư mục upload tại: " + ABSOLUTE_SERVICE_STORAGE_PATH);
            }
        }
        String absoluteFilePath = ABSOLUTE_SERVICE_STORAGE_PATH + File.separator + uniqueFileName;
        try {
            filePart.write(absoluteFilePath);
        } catch (IOException e) {
            System.err.println("Lỗi khi ghi file: " + absoluteFilePath);
            throw e;
        }
        return RELATIVE_SERVICE_ACCESS_PATH_FOR_DB + "/" + uniqueFileName;
    }
}

