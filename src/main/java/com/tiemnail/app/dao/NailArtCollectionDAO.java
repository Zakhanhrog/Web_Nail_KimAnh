package com.tiemnail.app.dao;

import com.tiemnail.app.model.NailArtCollection;
import com.tiemnail.app.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NailArtCollectionDAO {

    public NailArtCollection getCollectionById(int collectionId) throws SQLException {
        String sql = "SELECT * FROM nail_art_collections WHERE collection_id = ?";
        NailArtCollection collection = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, collectionId);
            rs = ps.executeQuery();

            if (rs.next()) {
                collection = mapResultSetToCollection(rs);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return collection;
    }

    public List<NailArtCollection> getAllCollections() throws SQLException {
        String sql = "SELECT * FROM nail_art_collections ORDER BY collection_name ASC";
        List<NailArtCollection> collections = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                collections.add(mapResultSetToCollection(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return collections;
    }

    public boolean addCollection(NailArtCollection collection) throws SQLException {
        String sql = "INSERT INTO nail_art_collections (collection_name, description) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, collection.getCollectionName());
            ps.setString(2, collection.getDescription());
            rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        collection.setCollectionId(generatedKeys.getInt(1));
                    }
                }
            }
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean updateCollection(NailArtCollection collection) throws SQLException {
        String sql = "UPDATE nail_art_collections SET collection_name = ?, description = ?, updated_at = CURRENT_TIMESTAMP WHERE collection_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, collection.getCollectionName());
            ps.setString(2, collection.getDescription());
            ps.setInt(3, collection.getCollectionId());
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean deleteCollection(int collectionId) throws SQLException {
        String sql = "DELETE FROM nail_art_collections WHERE collection_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, collectionId);
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    private NailArtCollection mapResultSetToCollection(ResultSet rs) throws SQLException {
        NailArtCollection collection = new NailArtCollection();
        collection.setCollectionId(rs.getInt("collection_id"));
        collection.setCollectionName(rs.getString("collection_name"));
        collection.setDescription(rs.getString("description"));
        collection.setCreatedAt(rs.getTimestamp("created_at"));
        collection.setUpdatedAt(rs.getTimestamp("updated_at"));
        return collection;
    }
}