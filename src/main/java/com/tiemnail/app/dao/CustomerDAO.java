package com.tiemnail.app.dao;

import com.tiemnail.app.model.Customer;
import com.tiemnail.app.util.DBUtil;
import com.tiemnail.app.dto.CustomerLoyaltyDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    public Customer getCustomerById(int customerId) throws SQLException {
        String sql = "SELECT c.*, u.full_name, u.email, u.phone_number " +
                "FROM customers c JOIN users u ON c.customer_id = u.user_id " +
                "WHERE c.customer_id = ?";
        Customer customer = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

            if (rs.next()) {
                customer = mapResultSetToCustomer(rs);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return customer;
    }

    public List<Customer> getAllCustomers() throws SQLException {
        String sql = "SELECT c.*, u.full_name, u.email, u.phone_number " +
                "FROM customers c JOIN users u ON c.customer_id = u.user_id " +
                "ORDER BY u.full_name ASC";
        List<Customer> customers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                customers.add(mapResultSetToCustomer(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return customers;
    }

    public boolean addCustomer(Customer customer) throws SQLException {
        String sql = "INSERT INTO customers (customer_id, notes, total_visits, total_spent) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customer.getCustomerId());
            ps.setString(2, customer.getNotes());
            ps.setInt(3, customer.getTotalVisits());
            ps.setBigDecimal(4, customer.getTotalSpent());
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean updateCustomer(Customer customer) throws SQLException {
        String sql = "UPDATE customers SET notes = ?, total_visits = ?, total_spent = ? WHERE customer_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, customer.getNotes());
            ps.setInt(2, customer.getTotalVisits());
            ps.setBigDecimal(3, customer.getTotalSpent());
            ps.setInt(4, customer.getCustomerId());
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean deleteCustomer(int customerId) throws SQLException {
        String sql = "DELETE FROM customers WHERE customer_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerId(rs.getInt("customer_id"));
        customer.setNotes(rs.getString("notes"));
        customer.setTotalVisits(rs.getInt("total_visits"));
        customer.setTotalSpent(rs.getBigDecimal("total_spent"));
        return customer;
    }

    public List<CustomerLoyaltyDTO> getLoyalCustomers(int limit, String orderBy) throws SQLException {
        // orderBy can be "total_visits" or "total_spent"
        List<CustomerLoyaltyDTO> loyalCustomers = new ArrayList<>();
        String orderByClause = "c.total_visits DESC, c.total_spent DESC";
        if ("total_spent".equalsIgnoreCase(orderBy)) {
            orderByClause = "c.total_spent DESC, c.total_visits DESC";
        } else if ("total_visits".equalsIgnoreCase(orderBy)) {
            orderByClause = "c.total_visits DESC, c.total_spent DESC";
        }
        String sql = "SELECT " +
                "    u.user_id as customer_id, " +
                "    u.full_name as customer_name, " +
                "    u.email as customer_email, " +
                "    u.phone_number as customer_phone, " +
                "    COUNT(a.appointment_id) as calculated_total_visits, " +
                "    COALESCE(SUM(a.final_amount), 0) as calculated_total_spent " +
                "FROM users u " +
                "LEFT JOIN appointments a ON u.user_id = a.customer_id AND a.status = 'completed' " +
                "WHERE u.role = 'customer' AND u.is_active = TRUE " +
                "GROUP BY u.user_id, u.full_name, u.email, u.phone_number ";

        if ("total_spent".equalsIgnoreCase(orderBy)) {
            sql += "ORDER BY calculated_total_spent DESC, calculated_total_visits DESC ";
        } else { // Mặc định hoặc total_visits
            sql += "ORDER BY calculated_total_visits DESC, calculated_total_spent DESC ";
        }
        sql += "LIMIT ?";


        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit > 0 ? limit : 10); // Mặc định top 10 nếu limit không hợp lệ
            rs = ps.executeQuery();

            while (rs.next()) {
                CustomerLoyaltyDTO dto = new CustomerLoyaltyDTO();
                dto.setCustomerId(rs.getInt("customer_id"));
                dto.setCustomerName(rs.getString("customer_name"));
                dto.setCustomerEmail(rs.getString("customer_email"));
                dto.setCustomerPhone(rs.getString("customer_phone"));
                dto.setTotalVisits(rs.getLong("calculated_total_visits")); // Lấy từ cột tính toán
                dto.setTotalSpent(rs.getBigDecimal("calculated_total_spent")); // Lấy từ cột tính toán
                loyalCustomers.add(dto);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return loyalCustomers;
    }
}