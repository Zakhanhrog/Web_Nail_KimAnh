package com.tiemnail.app.dao;

import com.tiemnail.app.model.Expense;
import com.tiemnail.app.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExpenseDAO {

    public Expense getExpenseById(int expenseId) throws SQLException {
        String sql = "SELECT * FROM expenses WHERE expense_id = ?";
        Expense expense = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, expenseId);
            rs = ps.executeQuery();

            if (rs.next()) {
                expense = mapResultSetToExpense(rs);
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return expense;
    }

    public List<Expense> getAllExpenses() throws SQLException {
        String sql = "SELECT * FROM expenses ORDER BY expense_date DESC, created_at DESC";
        List<Expense> expenses = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                expenses.add(mapResultSetToExpense(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return expenses;
    }

    public List<Expense> getExpensesByDateRange(Date startDate, Date endDate) throws SQLException {
        String sql = "SELECT * FROM expenses WHERE expense_date BETWEEN ? AND ? ORDER BY expense_date DESC, created_at DESC";
        List<Expense> expenses = new ArrayList<>();
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
                expenses.add(mapResultSetToExpense(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return expenses;
    }

    public List<Expense> getExpensesByCategory(String category) throws SQLException {
        String sql = "SELECT * FROM expenses WHERE category = ? ORDER BY expense_date DESC, created_at DESC";
        List<Expense> expenses = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, category);
            rs = ps.executeQuery();

            while (rs.next()) {
                expenses.add(mapResultSetToExpense(rs));
            }
        } finally {
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return expenses;
    }


    public boolean addExpense(Expense expense) throws SQLException {
        String sql = "INSERT INTO expenses (expense_date, description, amount, category, supplier, receipt_url, recorded_by_user_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setDate(1, expense.getExpenseDate());
            ps.setString(2, expense.getDescription());
            ps.setBigDecimal(3, expense.getAmount());
            ps.setString(4, expense.getCategory());
            ps.setString(5, expense.getSupplier());
            ps.setString(6, expense.getReceiptUrl());
            if (expense.getRecordedByUserId() != null) {
                ps.setInt(7, expense.getRecordedByUserId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        expense.setExpenseId(generatedKeys.getInt(1));
                    }
                }
            }
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean updateExpense(Expense expense) throws SQLException {
        String sql = "UPDATE expenses SET expense_date = ?, description = ?, amount = ?, category = ?, supplier = ?, receipt_url = ?, recorded_by_user_id = ?, updated_at = CURRENT_TIMESTAMP WHERE expense_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, expense.getExpenseDate());
            ps.setString(2, expense.getDescription());
            ps.setBigDecimal(3, expense.getAmount());
            ps.setString(4, expense.getCategory());
            ps.setString(5, expense.getSupplier());
            ps.setString(6, expense.getReceiptUrl());
            if (expense.getRecordedByUserId() != null) {
                ps.setInt(7, expense.getRecordedByUserId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setInt(8, expense.getExpenseId());
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    public boolean deleteExpense(int expenseId) throws SQLException {
        String sql = "DELETE FROM expenses WHERE expense_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        int rowsAffected = 0;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, expenseId);
            rowsAffected = ps.executeUpdate();
        } finally {
            DBUtil.closeStatement(ps);
            DBUtil.closeConnection(conn);
        }
        return rowsAffected > 0;
    }

    private Expense mapResultSetToExpense(ResultSet rs) throws SQLException {
        Expense expense = new Expense();
        expense.setExpenseId(rs.getInt("expense_id"));
        expense.setExpenseDate(rs.getDate("expense_date"));
        expense.setDescription(rs.getString("description"));
        expense.setAmount(rs.getBigDecimal("amount"));
        expense.setCategory(rs.getString("category"));
        expense.setSupplier(rs.getString("supplier"));
        expense.setReceiptUrl(rs.getString("receipt_url"));
        expense.setRecordedByUserId(rs.getObject("recorded_by_user_id", Integer.class));
        expense.setCreatedAt(rs.getTimestamp("created_at"));
        expense.setUpdatedAt(rs.getTimestamp("updated_at"));
        return expense;
    }
}