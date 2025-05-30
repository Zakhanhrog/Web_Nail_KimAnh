package com.tiemnail.app.model;

import java.math.BigDecimal;

public class Staff {
    private int staffId; // Trùng với user_id
    private String specialization;
    private BigDecimal averageRating;

    // Thêm một tham chiếu đến User object nếu bạn muốn load thông tin user cùng lúc
    // private User user;

    public Staff() {
    }

    public Staff(int staffId, String specialization, BigDecimal averageRating) {
        this.staffId = staffId;
        this.specialization = specialization;
        this.averageRating = averageRating;
    }

    // Getters and Setters
    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public BigDecimal getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(BigDecimal averageRating) {
        this.averageRating = averageRating;
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
        return "Staff{" +
                "staffId=" + staffId +
                ", specialization='" + specialization + '\'' +
                ", averageRating=" + averageRating +
                '}';
    }
}