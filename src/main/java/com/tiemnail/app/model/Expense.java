package com.tiemnail.app.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Expense {
    private int expenseId;
    private Date expenseDate;
    private String description;
    private BigDecimal amount;
    private String category;
    private String supplier;
    private String receiptUrl;
    private Integer recordedByUserId; // FK, có thể NULL
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Optional: Tham chiếu đến User (recordedBy)
    // private User recordedByUser;

    public Expense() {
    }

    public Expense(int expenseId, Date expenseDate, String description, BigDecimal amount, String category, String supplier, String receiptUrl, Integer recordedByUserId, Timestamp createdAt, Timestamp updatedAt) {
        this.expenseId = expenseId;
        this.expenseDate = expenseDate;
        this.description = description;
        this.amount = amount;
        this.category = category;
        this.supplier = supplier;
        this.receiptUrl = receiptUrl;
        this.recordedByUserId = recordedByUserId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getExpenseId() {
        return expenseId;
    }

    public void setExpenseId(int expenseId) {
        this.expenseId = expenseId;
    }

    public Date getExpenseDate() {
        return expenseDate;
    }

    public void setExpenseDate(Date expenseDate) {
        this.expenseDate = expenseDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSupplier() {
        return supplier;
    }

    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }

    public String getReceiptUrl() {
        return receiptUrl;
    }

    public void setReceiptUrl(String receiptUrl) {
        this.receiptUrl = receiptUrl;
    }

    public Integer getRecordedByUserId() {
        return recordedByUserId;
    }

    public void setRecordedByUserId(Integer recordedByUserId) {
        this.recordedByUserId = recordedByUserId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    /*
    public User getRecordedByUser() {
        return recordedByUser;
    }

    public void setRecordedByUser(User recordedByUser) {
        this.recordedByUser = recordedByUser;
    }
    */

    @Override
    public String toString() {
        return "Expense{" +
                "expenseId=" + expenseId +
                ", expenseDate=" + expenseDate +
                ", description='" + description + '\'' +
                ", amount=" + amount +
                ", category='" + category + '\'' +
                '}';
    }
}