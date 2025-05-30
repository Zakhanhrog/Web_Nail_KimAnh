package com.tiemnail.app.dao;

import com.tiemnail.app.model.Customer;
import com.tiemnail.app.util.DBUtil;

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
}