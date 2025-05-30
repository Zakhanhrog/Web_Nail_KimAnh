package com.tiemnail.app.dao;

import com.tiemnail.app.model.StaffSchedule;
import com.tiemnail.app.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Statement;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

public class StaffScheduleDAO {

    public StaffSchedule getScheduleById(int scheduleId) throws SQLException {
        String sql = "SELECT * FROM staff_schedules WHERE schedule_id = ?";
        StaffSchedule schedule = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, scheduleId);
            rs = ps.executeQuery();

            if (rs.next()) {
                schedule = mapResultSetToStaffSchedule(rs);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return schedule;
    }

    public List<StaffSchedule> getSchedulesByStaffId(int staffId) throws SQLException {
        String sql = "SELECT * FROM staff_schedules WHERE staff_id = ? ORDER BY work_date, start_time";
        List<StaffSchedule> schedules = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            rs = ps.executeQuery();

            while (rs.next()) {
                schedules.add(mapResultSetToStaffSchedule(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return schedules;
    }

    public List<StaffSchedule> getSchedulesByStaffIdAndDate(int staffId, Date workDate) throws SQLException {
        String sql = "SELECT ss.*, u.full_name as staff_name " +
                "FROM staff_schedules ss " +
                "JOIN users u ON ss.staff_id = u.user_id " +
                "WHERE ss.staff_id = ? AND ss.work_date = ? AND ss.is_available = TRUE AND u.is_active = TRUE " +
                "ORDER BY ss.start_time ASC";
        List<StaffSchedule> schedules = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            ps.setDate(2, workDate);
            rs = ps.executeQuery();

            while (rs.next()) {
                StaffSchedule schedule = mapResultSetToStaffSchedule(rs);
                schedules.add(schedule);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return schedules;
    }

    public List<StaffSchedule> getAvailableSchedulesByDate(Date workDate) throws SQLException {
        String sql = "SELECT ss.*, u.user_id as actual_staff_id, u.full_name as staff_name " +
                "FROM staff_schedules ss " +
                "JOIN users u ON ss.staff_id = u.user_id " +
                "WHERE ss.work_date = ? AND ss.is_available = TRUE AND u.is_active = TRUE " +
                "ORDER BY u.user_id, ss.start_time ASC";
        List<StaffSchedule> schedules = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, workDate);
            rs = ps.executeQuery();

            while (rs.next()) {
                StaffSchedule schedule = mapResultSetToStaffSchedule(rs);
                schedules.add(schedule);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return schedules;
    }


    public boolean addSchedule(StaffSchedule schedule) throws SQLException {
        String sql = "INSERT INTO staff_schedules (staff_id, work_date, start_time, end_time, is_available) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, schedule.getStaffId());
            ps.setDate(2, schedule.getWorkDate());
            ps.setTime(3, schedule.getStartTime());
            ps.setTime(4, schedule.getEndTime());
            ps.setBoolean(5, schedule.isAvailable());
            rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        schedule.setScheduleId(generatedKeys.getInt(1));
                    }
                }
            }
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean updateSchedule(StaffSchedule schedule) throws SQLException {
        String sql = "UPDATE staff_schedules SET staff_id = ?, work_date = ?, start_time = ?, end_time = ?, is_available = ? WHERE schedule_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, schedule.getStaffId());
            ps.setDate(2, schedule.getWorkDate());
            ps.setTime(3, schedule.getStartTime());
            ps.setTime(4, schedule.getEndTime());
            ps.setBoolean(5, schedule.isAvailable());
            ps.setInt(6, schedule.getScheduleId());
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean deleteSchedule(int scheduleId) throws SQLException {
        String sql = "DELETE FROM staff_schedules WHERE schedule_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, scheduleId);
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    private StaffSchedule mapResultSetToStaffSchedule(ResultSet rs) throws SQLException {
        StaffSchedule schedule = new StaffSchedule();
        schedule.setScheduleId(rs.getInt("schedule_id"));
        schedule.setStaffId(rs.getInt("staff_id"));
        schedule.setWorkDate(rs.getDate("work_date"));
        schedule.setStartTime(rs.getTime("start_time"));
        schedule.setEndTime(rs.getTime("end_time"));
        schedule.setAvailable(rs.getBoolean("is_available"));
        return schedule;
    }
}