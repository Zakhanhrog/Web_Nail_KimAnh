package com.tiemnail.app.dao;

import com.tiemnail.app.model.AppointmentDetail;
import com.tiemnail.app.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;

public class AppointmentDetailDAO {

    public AppointmentDetail getAppointmentDetailById(int appointmentDetailId) throws SQLException {
        String sql = "SELECT * FROM appointment_details WHERE appointment_detail_id = ?";
        AppointmentDetail detail = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentDetailId);
            rs = ps.executeQuery();

            if (rs.next()) {
                detail = mapResultSetToAppointmentDetail(rs);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return detail;
    }

    public List<AppointmentDetail> getDetailsByAppointmentId(int appointmentId) throws SQLException {
        String sql = "SELECT ad.*, s.service_name, na.nail_art_name " +
                "FROM appointment_details ad " +
                "JOIN services s ON ad.service_id = s.service_id " +
                "LEFT JOIN nail_arts na ON ad.nail_art_id = na.nail_art_id " +
                "WHERE ad.appointment_id = ?";
        List<AppointmentDetail> details = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                AppointmentDetail detail = mapResultSetToAppointmentDetail(rs);
                // Optionally set service_name and nail_art_name if you add them to the model
                details.add(detail);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return details;
    }

    public boolean addAppointmentDetail(AppointmentDetail detail, Connection conn) throws SQLException {
        String sql = "INSERT INTO appointment_details (appointment_id, service_id, nail_art_id, service_price_at_booking, nail_art_price_at_booking, quantity) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = null;
        int rowsAffected = 0;
        boolean closeConn = false;

        try {
            if (conn == null || conn.isClosed()) {
                conn = DBUtil.getConnection();
                closeConn = true;
            }

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, detail.getAppointmentId());
            ps.setInt(2, detail.getServiceId());
            if (detail.getNailArtId() != null) {
                ps.setInt(3, detail.getNailArtId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setBigDecimal(4, detail.getServicePriceAtBooking());
            ps.setBigDecimal(5, detail.getNailArtPriceAtBooking());
            ps.setInt(6, detail.getQuantity());
            rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        detail.setAppointmentDetailId(generatedKeys.getInt(1));
                    }
                }
            }
        } finally {
            DBUtil.closeStatement(ps);
            if (closeConn && conn != null) {
                DBUtil.closeConnection(conn);
            }
        }
        return rowsAffected > 0;
    }


    public boolean updateAppointmentDetail(AppointmentDetail detail, Connection conn) throws SQLException {
        String sql = "UPDATE appointment_details SET service_id = ?, nail_art_id = ?, service_price_at_booking = ?, nail_art_price_at_booking = ?, quantity = ? WHERE appointment_detail_id = ?";
        PreparedStatement ps = null;
        int rowsAffected = 0;
        boolean closeConn = false;

        try {
            if (conn == null || conn.isClosed()) {
                conn = DBUtil.getConnection();
                closeConn = true;
            }
            ps = conn.prepareStatement(sql);
            ps.setInt(1, detail.getServiceId());
            if (detail.getNailArtId() != null) {
                ps.setInt(2, detail.getNailArtId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setBigDecimal(3, detail.getServicePriceAtBooking());
            ps.setBigDecimal(4, detail.getNailArtPriceAtBooking());
            ps.setInt(5, detail.getQuantity());
            ps.setInt(6, detail.getAppointmentDetailId());
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            if (closeConn && conn != null) {
                DBUtil.closeConnection(conn);
            }
        }
        return rowsAffected > 0;
    }

    public boolean deleteAppointmentDetail(int appointmentDetailId, Connection conn) throws SQLException {
        String sql = "DELETE FROM appointment_details WHERE appointment_detail_id = ?";
        PreparedStatement ps = null;
        int rowsAffected = 0;
        boolean closeConn = false;

        try {
            if (conn == null || conn.isClosed()) {
                conn = DBUtil.getConnection();
                closeConn = true;
            }
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentDetailId);
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            if (closeConn && conn != null) {
                DBUtil.closeConnection(conn);
            }
        }
        return rowsAffected > 0;
    }

    public boolean deleteDetailsByAppointmentId(int appointmentId, Connection conn) throws SQLException {
        String sql = "DELETE FROM appointment_details WHERE appointment_id = ?";
        PreparedStatement ps = null;
        int rowsAffected = 0;
        boolean closeConn = false;

        try {
            if (conn == null || conn.isClosed()) {
                conn = DBUtil.getConnection();
                closeConn = true;
            }
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            if (closeConn && conn != null) {
                DBUtil.closeConnection(conn);
            }
        }
        return rowsAffected > 0;
    }

    public Map<Integer, Integer> getServiceUsageCounts() throws SQLException {
        Map<Integer, Integer> serviceCounts = new LinkedHashMap<>();
        String sql = "SELECT ad.service_id, COUNT(ad.service_id) as usage_count " +
                "FROM appointment_details ad " +
                "JOIN appointments a ON ad.appointment_id = a.appointment_id " +
                "WHERE a.status = 'completed' " +
                "GROUP BY ad.service_id " +
                "ORDER BY usage_count DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                serviceCounts.put(rs.getInt("service_id"), rs.getInt("usage_count"));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return serviceCounts;
    }

    private AppointmentDetail mapResultSetToAppointmentDetail(ResultSet rs) throws SQLException {
        AppointmentDetail detail = new AppointmentDetail();
        detail.setAppointmentDetailId(rs.getInt("appointment_detail_id"));
        detail.setAppointmentId(rs.getInt("appointment_id"));
        detail.setServiceId(rs.getInt("service_id"));
        detail.setNailArtId(rs.getObject("nail_art_id", Integer.class));
        detail.setServicePriceAtBooking(rs.getBigDecimal("service_price_at_booking"));
        detail.setNailArtPriceAtBooking(rs.getBigDecimal("nail_art_price_at_booking"));
        detail.setQuantity(rs.getInt("quantity"));
        return detail;
    }
}