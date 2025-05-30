package com.tiemnail.app.model;

import java.math.BigDecimal;

public class Customer {
    private int customerId; // Trùng với user_id
    private String notes;
    private int totalVisits;
    private BigDecimal totalSpent;
    public Customer() {
    }

    public Customer(int customerId, String notes, int totalVisits, BigDecimal totalSpent) {
        this.customerId = customerId;
        this.notes = notes;
        this.totalVisits = totalVisits;
        this.totalSpent = totalSpent;
    }

    // Getters and Setters
    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public int getTotalVisits() {
        return totalVisits;
    }

    public void setTotalVisits(int totalVisits) {
        this.totalVisits = totalVisits;
    }

    public BigDecimal getTotalSpent() {
        return totalSpent;
    }

    public void setTotalSpent(BigDecimal totalSpent) {
        this.totalSpent = totalSpent;
    }

    /*
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
    */

    @Override
    public String toString() {
        return "Customer{" +
                "customerId=" + customerId +
                ", totalVisits=" + totalVisits +
                ", totalSpent=" + totalSpent +
                '}';
    }
}