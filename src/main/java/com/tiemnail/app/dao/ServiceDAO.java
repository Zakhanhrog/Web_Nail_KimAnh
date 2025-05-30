package com.tiemnail.app.dao;

import com.tiemnail.app.model.Service;
import com.tiemnail.app.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public Service getServiceById(int serviceId) throws SQLException {
        String sql = "SELECT * FROM services WHERE service_id = ?";
        Service service = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, serviceId);
            rs = ps.executeQuery();

            if (rs.next()) {
                service = mapResultSetToService(rs);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return service;
    }

    public List<Service> getAllServices(boolean activeOnly) throws SQLException {
        String sql = "SELECT * FROM services";
        if (activeOnly) {
            sql += " WHERE is_active = TRUE";
        }
        sql += " ORDER BY service_name ASC";

        List<Service> services = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                services.add(mapResultSetToService(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return services;
    }

    public List<Service> getServicesByCategory(String category, boolean activeOnly) throws SQLException {
        String sql = "SELECT * FROM services WHERE category = ?";
        if (activeOnly) {
            sql += " AND is_active = TRUE";
        }
        sql += " ORDER BY service_name ASC";

        List<Service> services = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, category);
            rs = ps.executeQuery();

            while (rs.next()) {
                services.add(mapResultSetToService(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return services;
    }

    public boolean addService(Service service) throws SQLException {
        String sql = "INSERT INTO services (service_name, description, price, duration_minutes, category, image_url, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            // Lấy ID tự tăng trả về
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setBigDecimal(3, service.getPrice());
            ps.setInt(4, service.getDurationMinutes());
            ps.setString(5, service.getCategory());
            ps.setString(6, service.getImageUrl());
            ps.setBoolean(7, service.isActive());

            rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        service.setServiceId(generatedKeys.getInt(1));
                    }
                }
            }
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean updateService(Service service) throws SQLException {
        String sql = "UPDATE services SET service_name = ?, description = ?, price = ?, duration_minutes = ?, category = ?, image_url = ?, is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE service_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setBigDecimal(3, service.getPrice());
            ps.setInt(4, service.getDurationMinutes());
            ps.setString(5, service.getCategory());
            ps.setString(6, service.getImageUrl());
            ps.setBoolean(7, service.isActive());
            ps.setInt(8, service.getServiceId());

            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean deleteService(int serviceId) throws SQLException {
        // Cân nhắc: Thay vì xóa, có thể chỉ đặt is_active = false để giữ lại lịch sử
        // Nếu xóa, cần đảm bảo các bảng tham chiếu (vd: appointment_details) cho phép ON DELETE SET NULL hoặc ON DELETE RESTRICT
        // Hiện tại, appointment_details có ON DELETE RESTRICT với service_id, nên không xóa được service nếu có appointment_detail dùng nó.
        // Nên chuyển sang xóa mềm (cập nhật is_active = false)
        String sql = "UPDATE services SET is_active = FALSE, updated_at = CURRENT_TIMESTAMP WHERE service_id = ?";
        // String sql = "DELETE FROM services WHERE service_id = ?"; // Nếu muốn xóa cứng
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, serviceId);
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    // Helper method to map ResultSet to Service object
    private Service mapResultSetToService(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setServiceId(rs.getInt("service_id"));
        service.setServiceName(rs.getString("service_name"));
        service.setDescription(rs.getString("description"));
        service.setPrice(rs.getBigDecimal("price"));
        service.setDurationMinutes(rs.getInt("duration_minutes"));
        service.setCategory(rs.getString("category"));
        service.setImageUrl(rs.getString("image_url"));
        service.setActive(rs.getBoolean("is_active"));
        service.setCreatedAt(rs.getTimestamp("created_at"));
        service.setUpdatedAt(rs.getTimestamp("updated_at"));
        return service;
    }
}