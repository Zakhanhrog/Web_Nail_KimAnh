package com.tiemnail.app.dao;

import com.tiemnail.app.model.Staff;
import com.tiemnail.app.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StaffDAO {

    public Staff getStaffById(int staffId) throws SQLException {
        String sql = "SELECT s.*, u.full_name, u.email, u.phone_number " +
                "FROM staff s JOIN users u ON s.staff_id = u.user_id " +
                "WHERE s.staff_id = ?";
        Staff staff = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            rs = ps.executeQuery();

            if (rs.next()) {
                staff = mapResultSetToStaff(rs);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return staff;
    }

    public List<Staff> getAllStaff() throws SQLException {
        String sql = "SELECT s.*, u.full_name, u.email, u.phone_number " +
                "FROM staff s JOIN users u ON s.staff_id = u.user_id " +
                "WHERE u.role IN ('staff', 'admin', 'cashier') AND u.is_active = TRUE " +
                "ORDER BY u.full_name ASC";
        List<Staff> staffList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                staffList.add(mapResultSetToStaff(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return staffList;
    }

    public boolean addStaff(Staff staff) throws SQLException {
        String sql = "INSERT INTO staff (staff_id, specialization, average_rating) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staff.getStaffId());
            ps.setString(2, staff.getSpecialization());
            ps.setBigDecimal(3, staff.getAverageRating());
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean updateStaff(Staff staff) throws SQLException {
        String sql = "UPDATE staff SET specialization = ?, average_rating = ? WHERE staff_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, staff.getSpecialization());
            ps.setBigDecimal(2, staff.getAverageRating());
            ps.setInt(3, staff.getStaffId());
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean deleteStaff(int staffId) throws SQLException {
        String sql = "DELETE FROM staff WHERE staff_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    private Staff mapResultSetToStaff(ResultSet rs) throws SQLException {
        Staff staff = new Staff();
        staff.setStaffId(rs.getInt("staff_id"));
        staff.setSpecialization(rs.getString("specialization"));
        staff.setAverageRating(rs.getBigDecimal("average_rating"));
        return staff;
    }
}