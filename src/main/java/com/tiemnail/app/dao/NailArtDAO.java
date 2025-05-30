package com.tiemnail.app.dao;

import com.tiemnail.app.model.NailArt;
import com.tiemnail.app.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NailArtDAO {

    public NailArt getNailArtById(int nailArtId) throws SQLException {
        String sql = "SELECT * FROM nail_arts WHERE nail_art_id = ?";
        NailArt nailArt = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, nailArtId);
            rs = ps.executeQuery();

            if (rs.next()) {
                nailArt = mapResultSetToNailArt(rs);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return nailArt;
    }

    public List<NailArt> getAllNailArts(boolean activeOnly) throws SQLException {
        String sql = "SELECT * FROM nail_arts";
        if (activeOnly) {
            sql += " WHERE is_active = TRUE";
        }
        sql += " ORDER BY nail_art_name ASC";
        List<NailArt> nailArts = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                nailArts.add(mapResultSetToNailArt(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return nailArts;
    }

    public List<NailArt> getNailArtsByCollectionId(int collectionId, boolean activeOnly) throws SQLException {
        String sql = "SELECT * FROM nail_arts WHERE collection_id = ?";
        if (activeOnly) {
            sql += " AND is_active = TRUE";
        }
        sql += " ORDER BY nail_art_name ASC";
        List<NailArt> nailArts = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, collectionId);
            rs = ps.executeQuery();

            while (rs.next()) {
                nailArts.add(mapResultSetToNailArt(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return nailArts;
    }

    public boolean addNailArt(NailArt nailArt) throws SQLException {
        String sql = "INSERT INTO nail_arts (nail_art_name, description, image_url, price_addon, collection_id, likes_count, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, nailArt.getNailArtName());
            ps.setString(2, nailArt.getDescription());
            ps.setString(3, nailArt.getImageUrl());
            ps.setBigDecimal(4, nailArt.getPriceAddon());
            if (nailArt.getCollectionId() != null) {
                ps.setInt(5, nailArt.getCollectionId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setInt(6, nailArt.getLikesCount());
            ps.setBoolean(7, nailArt.isActive());
            rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        nailArt.setNailArtId(generatedKeys.getInt(1));
                    }
                }
            }
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean updateNailArt(NailArt nailArt) throws SQLException {
        String sql = "UPDATE nail_arts SET nail_art_name = ?, description = ?, image_url = ?, price_addon = ?, collection_id = ?, likes_count = ?, is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE nail_art_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, nailArt.getNailArtName());
            ps.setString(2, nailArt.getDescription());
            ps.setString(3, nailArt.getImageUrl());
            ps.setBigDecimal(4, nailArt.getPriceAddon());
            if (nailArt.getCollectionId() != null) {
                ps.setInt(5, nailArt.getCollectionId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setInt(6, nailArt.getLikesCount());
            ps.setBoolean(7, nailArt.isActive());
            ps.setInt(8, nailArt.getNailArtId());
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean incrementNailArtLikes(int nailArtId) throws SQLException {
        String sql = "UPDATE nail_arts SET likes_count = likes_count + 1, updated_at = CURRENT_TIMESTAMP WHERE nail_art_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, nailArtId);
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }


    public boolean deleteNailArt(int nailArtId) throws SQLException {
        String sql = "UPDATE nail_arts SET is_active = FALSE, updated_at = CURRENT_TIMESTAMP WHERE nail_art_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, nailArtId);
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    // Thêm phương thức mẫu để thêm ảnh mẫu vào DB
    public void insertSampleNailArt() throws SQLException {
        NailArt sample = new NailArt();
        sample.setNailArtName("Mẫu Nail Đẹp 1");
        sample.setDescription("Mẫu nail nghệ thuật đẹp, hiện đại.");
        sample.setPriceAddon(new java.math.BigDecimal("50000"));
        sample.setCollectionId(null);
        sample.setImageUrl("uploaded_images/nailarts/sample_nail_1.jpg");
        sample.setActive(true);
        sample.setLikesCount(0);
        addNailArt(sample);
    }

    private NailArt mapResultSetToNailArt(ResultSet rs) throws SQLException {
        NailArt nailArt = new NailArt();
        nailArt.setNailArtId(rs.getInt("nail_art_id"));
        nailArt.setNailArtName(rs.getString("nail_art_name"));
        nailArt.setDescription(rs.getString("description"));
        nailArt.setImageUrl(rs.getString("image_url"));
        nailArt.setPriceAddon(rs.getBigDecimal("price_addon"));
        nailArt.setCollectionId(rs.getObject("collection_id", Integer.class));
        nailArt.setLikesCount(rs.getInt("likes_count"));
        nailArt.setActive(rs.getBoolean("is_active"));
        nailArt.setCreatedAt(rs.getTimestamp("created_at"));
        nailArt.setUpdatedAt(rs.getTimestamp("updated_at"));
        return nailArt;
    }
}

