package com.tiemnail.app.controller;

import com.tiemnail.app.dao.NailArtCollectionDAO;
import com.tiemnail.app.dao.NailArtDAO;
import com.tiemnail.app.model.NailArt;
import com.tiemnail.app.model.NailArtCollection;

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

@WebServlet("/admin/nail-arts/*")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50)
public class NailArtServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NailArtDAO nailArtDAO;
    private NailArtCollectionDAO collectionDAO;
    private static final String ABSOLUTE_NAILART_STORAGE_PATH = "/Users/ngogiakhanh/Documents/TiemNailApp/images_app/TiemNailUploadStorage/nailarts";
    private static final String RELATIVE_NAILART_ACCESS_PATH_FOR_DB = "uploads/nailarts";

    public void init() {
        nailArtDAO = new NailArtDAO();
        collectionDAO = new NailArtCollectionDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }
        try {
            switch (action) {
                case "/insert":
                    insertNailArt(request, response);
                    break;
                case "/update":
                    updateNailArt(request, response);
                    break;
                default:
                    doGet(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
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
                    showNewNailArtForm(request, response);
                    break;
                case "/insert":
                    insertNailArt(request, response);
                    break;
                case "/delete":
                    deleteNailArt(request, response);
                    break;
                case "/edit":
                    showEditNailArtForm(request, response);
                    break;
                case "/update":
                    updateNailArt(request, response);
                    break;
                default: // "/list"
                    listNailArts(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listNailArts(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<NailArt> listNailArt = nailArtDAO.getAllNailArts(false); // Lấy cả active và inactive
        request.setAttribute("listNailArt", listNailArt);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/nail_art_list.jsp");
        dispatcher.forward(request, response);
    }

    private void loadCollectionsForForm(HttpServletRequest request) throws SQLException {
        List<NailArtCollection> listCollection = collectionDAO.getAllCollections();
        request.setAttribute("listCollection", listCollection);
    }

    private void showNewNailArtForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        loadCollectionsForForm(request);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/nail_art_form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditNailArtForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        NailArt existingNailArt = nailArtDAO.getNailArtById(id);
        request.setAttribute("nailArt", existingNailArt);
        loadCollectionsForForm(request);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/nail_art_form.jsp");
        dispatcher.forward(request, response);
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
        File uploadDir = new File(ABSOLUTE_NAILART_STORAGE_PATH);
        if (!uploadDir.exists()) {
            if (!uploadDir.mkdirs()) {
                System.err.println("Không thể tạo thư mục upload: " + ABSOLUTE_NAILART_STORAGE_PATH);
                throw new IOException("Không thể tạo thư mục upload tại: " + ABSOLUTE_NAILART_STORAGE_PATH);
            }
        }
        String absoluteFilePath = ABSOLUTE_NAILART_STORAGE_PATH + File.separator + uniqueFileName;
        try {
            filePart.write(absoluteFilePath);
        } catch (IOException e) {
            System.err.println("Lỗi khi ghi file: " + absoluteFilePath);
            throw e;
        }
        return RELATIVE_NAILART_ACCESS_PATH_FOR_DB + "/" + uniqueFileName;
    }

    private void insertNailArt(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String name = request.getParameter("nailArtName");
        String description = request.getParameter("description");
        BigDecimal priceAddon = new BigDecimal(request.getParameter("priceAddon"));
        String collectionIdStr = request.getParameter("collectionId");
        boolean isActive = "on".equalsIgnoreCase(request.getParameter("isActive"));

        Integer collectionId = null;
        if (collectionIdStr != null && !collectionIdStr.isEmpty() && !collectionIdStr.equals("0")) {
            collectionId = Integer.parseInt(collectionIdStr);
        }

        String imageUrl = null;
        Part filePart = request.getPart("imageFile"); // "imageFile" là name của input type="file"
        if (filePart != null && filePart.getSize() > 0) {
            try {
                imageUrl = saveUploadedFile(filePart);
            } catch (IOException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi khi tải ảnh lên: " + e.getMessage());
                loadCollectionsForForm(request);
                request.setAttribute("nailArtName", name);
                request.setAttribute("description", description);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/nail_art_form.jsp");
                dispatcher.forward(request, response);
                return;
            }
        }

        NailArt newNailArt = new NailArt();
        newNailArt.setNailArtName(name);
        newNailArt.setDescription(description);
        newNailArt.setPriceAddon(priceAddon);
        newNailArt.setCollectionId(collectionId);
        newNailArt.setImageUrl(imageUrl); // Sẽ là null nếu không có ảnh mới
        newNailArt.setActive(isActive);
        newNailArt.setLikesCount(0); // Mặc định

        nailArtDAO.addNailArt(newNailArt);
        response.sendRedirect(request.getContextPath() + "/admin/nail-arts/list");
    }

    private void updateNailArt(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("nailArtId"));
        String name = request.getParameter("nailArtName");
        String description = request.getParameter("description");
        BigDecimal priceAddon = new BigDecimal(request.getParameter("priceAddon"));
        String collectionIdStr = request.getParameter("collectionId");
        boolean isActive = "on".equalsIgnoreCase(request.getParameter("isActive"));
        String existingImageUrl = request.getParameter("existingImageUrl"); // Lấy URL ảnh hiện tại

        Integer collectionId = null;
        if (collectionIdStr != null && !collectionIdStr.isEmpty() && !collectionIdStr.equals("0")) {
            collectionId = Integer.parseInt(collectionIdStr);
        }

        NailArt nailArt = nailArtDAO.getNailArtById(id); // Lấy thông tin hiện tại từ DB
        if (nailArt == null) {
            response.sendRedirect(request.getContextPath() + "/admin/nail-arts/list?error=notfound");
            return;
        }

        String imageUrl = existingImageUrl; // Mặc định giữ ảnh cũ
        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            try {
                imageUrl = saveUploadedFile(filePart);
            } catch (IOException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi khi tải ảnh mới lên: " + e.getMessage());
                request.setAttribute("nailArt", nailArtDAO.getNailArtById(id));
                loadCollectionsForForm(request);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/nail_art_form.jsp");
                dispatcher.forward(request, response);
                return;
            }
        }

        nailArt.setNailArtName(name);
        nailArt.setDescription(description);
        nailArt.setPriceAddon(priceAddon);
        nailArt.setCollectionId(collectionId);
        nailArt.setImageUrl(imageUrl);
        nailArt.setActive(isActive);
        // likesCount không thay đổi khi update

        nailArtDAO.updateNailArt(nailArt);
        response.sendRedirect(request.getContextPath() + "/admin/nail-arts/list");
    }

    private void deleteNailArt(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        // Thay vì xóa cứng, chúng ta cập nhật is_active = false
        nailArtDAO.deleteNailArt(id);
        response.sendRedirect(request.getContextPath() + "/admin/nail-arts/list");
    }
}

