package com.tiemnail.app.dao;

import com.tiemnail.app.model.Review;
import com.tiemnail.app.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public Review getReviewById(int reviewId) throws SQLException {
        String sql = "SELECT * FROM reviews WHERE review_id = ?";
        Review review = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, reviewId);
            rs = ps.executeQuery();

            if (rs.next()) {
                review = mapResultSetToReview(rs);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return review;
    }

    public Review getReviewByAppointmentId(int appointmentId) throws SQLException {
        String sql = "SELECT * FROM reviews WHERE appointment_id = ?";
        Review review = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                review = mapResultSetToReview(rs);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return review;
    }

    public List<Review> getReviewsByStaffId(int staffId) throws SQLException {
        String sql = "SELECT r.*, u_customer.full_name AS customer_name " +
                "FROM reviews r " +
                "JOIN users u_customer ON r.customer_id = u_customer.user_id " +
                "WHERE r.staff_id = ? ORDER BY r.review_date DESC";
        List<Review> reviews = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Review review = mapResultSetToReview(rs);
                // Optionally set customer_name if added to Review model
                reviews.add(review);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return reviews;
    }

    public List<Review> getReviewsByCustomerId(int customerId) throws SQLException {
        String sql = "SELECT r.*, u_staff.full_name AS staff_name " +
                "FROM reviews r " +
                "JOIN users u_staff ON r.staff_id = u_staff.user_id " +
                "WHERE r.customer_id = ? ORDER BY r.review_date DESC";
        List<Review> reviews = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Review review = mapResultSetToReview(rs);
                // Optionally set staff_name if added to Review model
                reviews.add(review);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return reviews;
    }


    public boolean addReview(Review review) throws SQLException {
        String sql = "INSERT INTO reviews (appointment_id, customer_id, staff_id, rating_score, comment, review_date) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, review.getAppointmentId());
            ps.setInt(2, review.getCustomerId());
            ps.setInt(3, review.getStaffId());
            ps.setInt(4, review.getRatingScore());
            ps.setString(5, review.getComment());
            ps.setTimestamp(6, review.getReviewDate() != null ? review.getReviewDate() : new Timestamp(System.currentTimeMillis()));
            rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        review.setReviewId(generatedKeys.getInt(1));
                    }
                }
            }
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean updateReview(Review review) throws SQLException {
        String sql = "UPDATE reviews SET rating_score = ?, comment = ?, review_date = ? WHERE review_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, review.getRatingScore());
            ps.setString(2, review.getComment());
            ps.setTimestamp(3, review.getReviewDate() != null ? review.getReviewDate() : new Timestamp(System.currentTimeMillis()));
            ps.setInt(4, review.getReviewId());
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean deleteReview(int reviewId) throws SQLException {
        String sql = "DELETE FROM reviews WHERE review_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, reviewId);
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public double getAverageRatingForStaff(int staffId) throws SQLException {
        String sql = "SELECT AVG(rating_score) as avg_rating FROM reviews WHERE staff_id = ?";
        double avgRating = 0.0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffId);
            rs = ps.executeQuery();

            if (rs.next()) {
                avgRating = rs.getDouble("avg_rating");
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return avgRating;
    }


    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("review_id"));
        review.setAppointmentId(rs.getInt("appointment_id"));
        review.setCustomerId(rs.getInt("customer_id"));
        review.setStaffId(rs.getInt("staff_id"));
        review.setRatingScore(rs.getInt("rating_score"));
        review.setComment(rs.getString("comment"));
        review.setReviewDate(rs.getTimestamp("review_date"));
        return review;
    }
}