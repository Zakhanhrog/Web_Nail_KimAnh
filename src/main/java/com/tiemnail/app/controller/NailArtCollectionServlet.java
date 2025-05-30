package com.tiemnail.app.controller;

import com.tiemnail.app.dao.NailArtCollectionDAO;
import com.tiemnail.app.model.NailArtCollection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/nail-collections/*")
public class NailArtCollectionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NailArtCollectionDAO collectionDAO;

    public void init() {
        collectionDAO = new NailArtCollectionDAO();
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
                    showNewCollectionForm(request, response);
                    break;
                case "/insert":
                    insertCollection(request, response);
                    break;
                case "/delete":
                    deleteCollection(request, response);
                    break;
                case "/edit":
                    showEditCollectionForm(request, response);
                    break;
                case "/update":
                    updateCollection(request, response);
                    break;
                default: // "/list"
                    listCollections(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listCollections(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<NailArtCollection> listCollection = collectionDAO.getAllCollections();
        request.setAttribute("listCollection", listCollection);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/collection_list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewCollectionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/collection_form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditCollectionForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        NailArtCollection existingCollection = collectionDAO.getCollectionById(id);
        request.setAttribute("collection", existingCollection);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/collection_form.jsp");
        dispatcher.forward(request, response);
    }

    private void insertCollection(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String name = request.getParameter("collectionName");
        String description = request.getParameter("description");

        NailArtCollection newCollection = new NailArtCollection();
        newCollection.setCollectionName(name);
        newCollection.setDescription(description);

        collectionDAO.addCollection(newCollection);
        response.sendRedirect(request.getContextPath() + "/admin/nail-collections/list");
    }

    private void updateCollection(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("collectionId"));
        String name = request.getParameter("collectionName");
        String description = request.getParameter("description");

        NailArtCollection collection = new NailArtCollection();
        collection.setCollectionId(id);
        collection.setCollectionName(name);
        collection.setDescription(description);

        collectionDAO.updateCollection(collection);
        response.sendRedirect(request.getContextPath() + "/admin/nail-collections/list");
    }

    private void deleteCollection(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        // Cân nhắc: Kiểm tra xem có NailArt nào thuộc collection này không trước khi xóa
        // Hoặc để DB xử lý (ví dụ ON DELETE SET NULL cho collection_id trong bảng nail_arts)
        try {
            collectionDAO.deleteCollection(id);
        } catch (SQLException e) {
            // Xử lý lỗi nếu không xóa được do ràng buộc khóa ngoại (nếu có nail art đang dùng)
            // Ví dụ: Gửi thông báo lỗi về JSP
            request.getSession().setAttribute("errorMessage", "Không thể xóa bộ sưu tập vì có mẫu nail đang sử dụng. Lỗi: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/nail-collections/list");
    }
}