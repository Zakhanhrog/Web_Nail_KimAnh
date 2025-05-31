package com.tiemnail.app.dao;

import com.tiemnail.app.model.Appointment;
import com.tiemnail.app.model.AppointmentDetail;
import com.tiemnail.app.util.DBUtil;
import com.tiemnail.app.dto.StaffPerformanceDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;


public class AppointmentDAO {

    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setAppointmentId(rs.getInt("appointment_id"));
        appointment.setCustomerId(rs.getObject("customer_id", Integer.class));
        appointment.setGuestName(rs.getString("guest_name"));
        appointment.setGuestPhone(rs.getString("guest_phone"));
        appointment.setStaffId(rs.getObject("staff_id", Integer.class));
        appointment.setAppointmentDatetime(rs.getTimestamp("appointment_datetime"));
        appointment.setEstimatedDurationMinutes(rs.getInt("estimated_duration_minutes"));
        appointment.setStatus(rs.getString("status"));
        appointment.setTotalBasePrice(rs.getBigDecimal("total_base_price"));
        appointment.setTotalAddonPrice(rs.getBigDecimal("total_addon_price"));
        appointment.setGlobalNailArtId(rs.getObject("global_nail_art_id", Integer.class));
        appointment.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        appointment.setFinalAmount(rs.getBigDecimal("final_amount"));
        appointment.setCustomerNotes(rs.getString("customer_notes"));
        appointment.setStaffNotes(rs.getString("staff_notes"));
        appointment.setCreatedAt(rs.getTimestamp("created_at"));
        appointment.setUpdatedAt(rs.getTimestamp("updated_at"));
        return appointment;
    }

    public Appointment getAppointmentById(int appointmentId) throws SQLException {
        String sql = "SELECT *, global_nail_art_id FROM appointments WHERE appointment_id = ?";
        Appointment appointment = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                appointment = mapResultSetToAppointment(rs);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return appointment;
    }

    public List<Appointment> getAllAppointments() throws SQLException {
        String sql = "SELECT *, global_nail_art_id FROM appointments ORDER BY appointment_datetime DESC";
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return appointments;
    }

    public List<Appointment> getAppointmentsByCustomerId(int customerId) throws SQLException {
        String sql = "SELECT *, global_nail_art_id FROM appointments WHERE customer_id = ? ORDER BY appointment_datetime DESC";
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return appointments;
    }

    public List<Appointment> getAppointmentsByStaffId(int staffId) throws SQLException {
        String sql = "SELECT *, global_nail_art_id FROM appointments WHERE staff_id = ? ORDER BY appointment_datetime DESC";
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            rs = ps.executeQuery();
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return appointments;
    }

    public List<Appointment> getAppointmentsByDate(Date date) throws SQLException {
        String sql = "SELECT *, global_nail_art_id FROM appointments WHERE DATE(appointment_datetime) = ? ORDER BY appointment_datetime ASC";
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, date);
            rs = ps.executeQuery();

            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return appointments;
    }

    public List<Appointment> getUpcomingAppointmentsByStaff(int staffId) throws SQLException {
        String sql = "SELECT *, global_nail_art_id FROM appointments WHERE staff_id = ? AND appointment_datetime >= CURDATE() AND status NOT IN ('completed', 'cancelled_by_customer', 'cancelled_by_staff', 'no_show') ORDER BY appointment_datetime ASC";
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            rs = ps.executeQuery();

            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return appointments;
    }

    public List<Appointment> getAppointmentsByStaffIdAndDate(int staffId, Date date) throws SQLException {
        String sql = "SELECT *, global_nail_art_id FROM appointments " +
                "WHERE staff_id = ? AND DATE(appointment_datetime) = ? " +
                "AND status NOT IN ('cancelled_by_customer', 'cancelled_by_staff', 'no_show') " +
                "ORDER BY appointment_datetime ASC";
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            ps.setDate(2, date);
            rs = ps.executeQuery();

            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return appointments;
    }

    public List<Appointment> getAppointmentsByDateAndStatusNotIn(Date date, List<String> excludedStatuses) throws SQLException {
        if (excludedStatuses == null || excludedStatuses.isEmpty()) {
            String sql = "SELECT *, global_nail_art_id FROM appointments WHERE DATE(appointment_datetime) = ? ORDER BY appointment_datetime ASC";
            List<Appointment> appointments = new ArrayList<>();
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                conn = DBUtil.getConnection();
                ps = conn.prepareStatement(sql);
                ps.setDate(1,date);
                rs = ps.executeQuery();
                while(rs.next()){
                    appointments.add(mapResultSetToAppointment(rs));
                }
            } finally {
                DBUtil.closeResultSet(rs);
                DBUtil.closeStatement(ps);
                DBUtil.closeConnection(conn);
            }
            return appointments;
        }

        StringBuilder sqlBuilder = new StringBuilder("SELECT *, global_nail_art_id FROM appointments WHERE DATE(appointment_datetime) = ? AND status NOT IN (");
        for (int i = 0; i < excludedStatuses.size(); i++) {
            sqlBuilder.append("?");
            if (i < excludedStatuses.size() - 1) {
                sqlBuilder.append(",");
            }
        }
        sqlBuilder.append(") ORDER BY appointment_datetime ASC");

        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sqlBuilder.toString());
            ps.setDate(1, date);
            for (int i = 0; i < excludedStatuses.size(); i++) {
                ps.setString(i + 2, excludedStatuses.get(i));
            }
            rs = ps.executeQuery();

            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return appointments;
    }

    public int addAppointment(Appointment appointment, List<AppointmentDetail> details) throws SQLException {
        String sqlAppointment = "INSERT INTO appointments (customer_id, guest_name, guest_phone, staff_id, appointment_datetime, estimated_duration_minutes, status, total_base_price, total_addon_price, global_nail_art_id, discount_amount, customer_notes, staff_notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement psAppointment = null;
        int appointmentId = -1;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            psAppointment = conn.prepareStatement(sqlAppointment, Statement.RETURN_GENERATED_KEYS);
            if (appointment.getCustomerId() != null) {
                psAppointment.setInt(1, appointment.getCustomerId());
            } else {
                psAppointment.setNull(1, Types.INTEGER);
            }
            psAppointment.setString(2, appointment.getGuestName());
            psAppointment.setString(3, appointment.getGuestPhone());
            if (appointment.getStaffId() != null) {
                psAppointment.setInt(4, appointment.getStaffId());
            } else {
                psAppointment.setNull(4, Types.INTEGER);
            }
            psAppointment.setTimestamp(5, appointment.getAppointmentDatetime());
            psAppointment.setInt(6, appointment.getEstimatedDurationMinutes());
            psAppointment.setString(7, appointment.getStatus());
            psAppointment.setBigDecimal(8, appointment.getTotalBasePrice());
            psAppointment.setBigDecimal(9, appointment.getTotalAddonPrice());

            if (appointment.getGlobalNailArtId() != null) {
                psAppointment.setInt(10, appointment.getGlobalNailArtId());
            } else {
                psAppointment.setNull(10, Types.INTEGER);
            }

            psAppointment.setBigDecimal(11, appointment.getDiscountAmount());
            psAppointment.setString(12, appointment.getCustomerNotes());
            psAppointment.setString(13, appointment.getStaffNotes());

            int rowsAffected = psAppointment.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = psAppointment.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        appointmentId = generatedKeys.getInt(1);

                        if (details != null && !details.isEmpty()) {
                            AppointmentDetailDAO detailDAO = new AppointmentDetailDAO();
                            for (AppointmentDetail detail : details) {
                                detail.setAppointmentId(appointmentId);
                                detailDAO.addAppointmentDetail(detail, conn);
                            }
                        }
                    } else {
                        conn.rollback();
                        throw new SQLException("Creating appointment failed, no ID obtained.");
                    }
                }
            } else {
                conn.rollback();
                throw new SQLException("Creating appointment failed, no rows affected.");
            }
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            DBUtil.closeStatement(psAppointment);
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                DBUtil.closeConnection(conn);
            }
        }
        return appointmentId;
    }

    public boolean updateAppointment(Appointment appointment) throws SQLException {
        String sql = "UPDATE appointments SET customer_id = ?, guest_name = ?, guest_phone = ?, staff_id = ?, appointment_datetime = ?, estimated_duration_minutes = ?, status = ?, total_base_price = ?, total_addon_price = ?, global_nail_art_id = ?, discount_amount = ?, customer_notes = ?, staff_notes = ?, updated_at = CURRENT_TIMESTAMP WHERE appointment_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            if (appointment.getCustomerId() != null) {
                ps.setInt(1, appointment.getCustomerId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, appointment.getGuestName());
            ps.setString(3, appointment.getGuestPhone());
            if (appointment.getStaffId() != null) {
                ps.setInt(4, appointment.getStaffId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setTimestamp(5, appointment.getAppointmentDatetime());
            ps.setInt(6, appointment.getEstimatedDurationMinutes());
            ps.setString(7, appointment.getStatus());
            ps.setBigDecimal(8, appointment.getTotalBasePrice());
            ps.setBigDecimal(9, appointment.getTotalAddonPrice());

            if (appointment.getGlobalNailArtId() != null) {
                ps.setInt(10, appointment.getGlobalNailArtId());
            } else {
                ps.setNull(10, Types.INTEGER);
            }

            ps.setBigDecimal(11, appointment.getDiscountAmount());
            ps.setString(12, appointment.getCustomerNotes());
            ps.setString(13, appointment.getStaffNotes());
            ps.setInt(14, appointment.getAppointmentId());

            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean updateAppointmentStatus(int appointmentId, String newStatus) throws SQLException {
        String sql = "UPDATE appointments SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE appointment_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, appointmentId);
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }


    public boolean deleteAppointment(int appointmentId) throws SQLException {
        String sql = "DELETE FROM appointments WHERE appointment_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            AppointmentDetailDAO detailDAO = new AppointmentDetailDAO();
            detailDAO.deleteDetailsByAppointmentId(appointmentId, conn);

            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            rowsAffected = ps.executeUpdate();

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            DBUtil.closeStatement(ps);
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                DBUtil.closeConnection(conn);
            }
        }
        return rowsAffected > 0;
    }

    public BigDecimal getTotalRevenueByDateRange(Date startDate, Date endDate) throws SQLException {
        String sql = "SELECT SUM(final_amount) as total_revenue FROM appointments " +
                "WHERE status = 'completed' AND DATE(appointment_datetime) BETWEEN ? AND ?";
        BigDecimal totalRevenue = BigDecimal.ZERO;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
            rs = ps.executeQuery();

            if (rs.next()) {
                BigDecimal revenue = rs.getBigDecimal("total_revenue");
                if (revenue != null) {
                    totalRevenue = revenue;
                }
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return totalRevenue;
    }

    public Map<String, BigDecimal> getDailyRevenueForMonth(int year, int month) throws SQLException {
        Map<String, BigDecimal> dailyRevenue = new LinkedHashMap<>();
        String sql = "SELECT DATE(appointment_datetime) as appointment_day, SUM(final_amount) as daily_revenue " +
                "FROM appointments " +
                "WHERE status = 'completed' AND YEAR(appointment_datetime) = ? AND MONTH(appointment_datetime) = ? " +
                "GROUP BY DATE(appointment_datetime) " +
                "ORDER BY appointment_day ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, year);
            ps.setInt(2, month);
            rs = ps.executeQuery();

            while (rs.next()) {
                String day = rs.getString("appointment_day");
                BigDecimal revenue = rs.getBigDecimal("daily_revenue");
                dailyRevenue.put(day, revenue != null ? revenue : BigDecimal.ZERO);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return dailyRevenue;
    }

    public List<StaffPerformanceDTO> getStaffPerformanceByDateRange(Date startDate, Date endDate) throws SQLException {
        List<StaffPerformanceDTO> performanceList = new ArrayList<>();
        String sql = "SELECT " +
                "    u.user_id as staff_id, " +
                "    u.full_name as staff_name, " +
                "    COUNT(DISTINCT a.appointment_id) as completed_appointments, " + // Sử dụng DISTINCT
                "    COALESCE(SUM(a.final_amount), 0) as total_revenue, " +
                "    s.average_rating " +
                "FROM users u " +
                "JOIN staff s ON u.user_id = s.staff_id " +
                "LEFT JOIN appointments a ON u.user_id = a.staff_id " +
                "    AND a.status = 'completed' " +
                "    AND DATE(a.appointment_datetime) BETWEEN ? AND ? " +
                "WHERE u.role IN ('staff', 'admin', 'cashier') AND u.is_active = TRUE " +
                "GROUP BY u.user_id, u.full_name, s.average_rating " +
                "ORDER BY total_revenue DESC, completed_appointments DESC, u.full_name ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
            rs = ps.executeQuery();

            while (rs.next()) {
                StaffPerformanceDTO dto = new StaffPerformanceDTO();
                dto.setStaffId(rs.getInt("staff_id"));
                dto.setStaffName(rs.getString("staff_name"));
                dto.setCompletedAppointments(rs.getInt("completed_appointments"));
                dto.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                dto.setAverageRating(rs.getBigDecimal("average_rating"));
                performanceList.add(dto);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return performanceList;
    }
}