package com.tiemnail.app.model;

import java.sql.Timestamp;

public class Review {
    private int reviewId;
    private int appointmentId;
    private int customerId;
    private int staffId;
    private int ratingScore; // 1 đến 5
    private String comment;
    private Timestamp reviewDate;

    // Optional: Tham chiếu đến User (customer, staff), Appointment
    // private User customer;
    // private User staff;
    // private Appointment appointment;

    public Review() {
    }

    public Review(int reviewId, int appointmentId, int customerId, int staffId, int ratingScore, String comment, Timestamp reviewDate) {
        this.reviewId = reviewId;
        this.appointmentId = appointmentId;
        this.customerId = customerId;
        this.staffId = staffId;
        this.ratingScore = ratingScore;
        this.comment = comment;
        this.reviewDate = reviewDate;
    }

    // Getters and Setters
    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public int getRatingScore() {
        return ratingScore;
    }

    public void setRatingScore(int ratingScore) {
        this.ratingScore = ratingScore;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Timestamp reviewDate) {
        this.reviewDate = reviewDate;
    }

    /*
    public User getCustomer() {
        return customer;
    }

    public void setCustomer(User customer) {
        this.customer = customer;
    }

    public User getStaff() {
        return staff;
    }

    public void setStaff(User staff) {
        this.staff = staff;
    }

    public Appointment getAppointment() {
        return appointment;
    }

    public void setAppointment(Appointment appointment) {
        this.appointment = appointment;
    }
    */

    @Override
    public String toString() {
        return "Review{" +
                "reviewId=" + reviewId +
                ", appointmentId=" + appointmentId +
                ", customerId=" + customerId +
                ", staffId=" + staffId +
                ", ratingScore=" + ratingScore +
                '}';
    }
}