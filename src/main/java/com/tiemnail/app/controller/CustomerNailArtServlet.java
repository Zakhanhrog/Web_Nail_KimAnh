package com.tiemnail.app.controller;

import com.tiemnail.app.dao.NailArtDAO;
import com.tiemnail.app.dao.NailArtCollectionDAO;
import com.tiemnail.app.model.NailArt;
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

@WebServlet("/nail-arts") // URL cho khách hàng xem mẫu nail
public class CustomerNailArtServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NailArtDAO nailArtDAO;
    private NailArtCollectionDAO collectionDAO;

    public void init() {
        nailArtDAO = new NailArtDAO();
        collectionDAO = new NailArtCollectionDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String collectionIdParam = request.getParameter("collectionId");

        try {
            List<NailArt> listNailArt;
            if (collectionIdParam != null && !collectionIdParam.isEmpty() && !collectionIdParam.equals("0")) {
                listNailArt = nailArtDAO.getNailArtsByCollectionId(Integer.parseInt(collectionIdParam), true); // Chỉ active
            } else {
                listNailArt = nailArtDAO.getAllNailArts(true); // Chỉ active
            }

            List<NailArtCollection> collections = collectionDAO.getAllCollections();

            request.setAttribute("listNailArt", listNailArt);
            request.setAttribute("collections", collections);
            request.setAttribute("selectedCollectionId", collectionIdParam);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/customer/nail_art_catalog.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException ex) {
            ex.printStackTrace();
            throw new ServletException("Lỗi truy cập cơ sở dữ liệu khi lấy danh sách mẫu nail.", ex);
        }
    }
}