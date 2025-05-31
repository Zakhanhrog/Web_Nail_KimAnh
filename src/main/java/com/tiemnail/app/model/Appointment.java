package com.tiemnail.app.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
// Bỏ import java.util.List; nếu không dùng trực tiếp trường details trong model này nữa

public class Appointment {
    private int appointmentId;
    private Integer customerId;
    private String guestName;
    private String guestPhone;
    private Integer staffId;
    private Timestamp appointmentDatetime;
    private int estimatedDurationMinutes;
    private String status;
    private BigDecimal totalBasePrice;
    private BigDecimal totalAddonPrice; // Sẽ là giá của globalNailArtId nếu có
    private BigDecimal discountAmount;
    private BigDecimal finalAmount;
    private String customerNotes;
    private String staffNotes;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Integer globalNailArtId; // TRƯỜNG MỚI

    public Appointment() {
    }

    // Constructor có thể cần cập nhật nếu bạn muốn khởi tạo globalNailArtId
    public Appointment(int appointmentId, Integer customerId, String guestName, String guestPhone, Integer staffId, Timestamp appointmentDatetime, int estimatedDurationMinutes, String status, BigDecimal totalBasePrice, BigDecimal totalAddonPrice, Integer globalNailArtId, BigDecimal discountAmount, BigDecimal finalAmount, String customerNotes, String staffNotes, Timestamp createdAt, Timestamp updatedAt) {
        this.appointmentId = appointmentId;
        this.customerId = customerId;
        this.guestName = guestName;
        this.guestPhone = guestPhone;
        this.staffId = staffId;
        this.appointmentDatetime = appointmentDatetime;
        this.estimatedDurationMinutes = estimatedDurationMinutes;
        this.status = status;
        this.totalBasePrice = totalBasePrice;
        this.totalAddonPrice = totalAddonPrice;
        this.globalNailArtId = globalNailArtId; // THÊM VÀO CONSTRUCTOR
        this.discountAmount = discountAmount;
        this.finalAmount = finalAmount;
        this.customerNotes = customerNotes;
        this.staffNotes = staffNotes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }


    // Getters and Setters
    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getGuestPhone() {
        return guestPhone;
    }

    public void setGuestPhone(String guestPhone) {
        this.guestPhone = guestPhone;
    }

    public Integer getStaffId() {
        return staffId;
    }

    public void setStaffId(Integer staffId) {
        this.staffId = staffId;
    }

    public Timestamp getAppointmentDatetime() {
        return appointmentDatetime;
    }

    public void setAppointmentDatetime(Timestamp appointmentDatetime) {
        this.appointmentDatetime = appointmentDatetime;
    }

    public int getEstimatedDurationMinutes() {
        return estimatedDurationMinutes;
    }

    public void setEstimatedDurationMinutes(int estimatedDurationMinutes) {
        this.estimatedDurationMinutes = estimatedDurationMinutes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotalBasePrice() {
        return totalBasePrice;
    }

    public void setTotalBasePrice(BigDecimal totalBasePrice) {
        this.totalBasePrice = totalBasePrice;
    }

    public BigDecimal getTotalAddonPrice() {
        return totalAddonPrice;
    }

    public void setTotalAddonPrice(BigDecimal totalAddonPrice) {
        this.totalAddonPrice = totalAddonPrice;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getFinalAmount() {
        // Logic tính finalAmount nên được thực hiện ở service hoặc DAO khi set các giá trị
        // Hoặc có một phương thức riêng để tính toán dựa trên base, addon, discount
        if (this.totalBasePrice != null && this.totalAddonPrice != null && this.discountAmount != null) {
            return this.totalBasePrice.add(this.totalAddonPrice).subtract(this.discountAmount);
        }
        return finalAmount; // Trả về giá trị đã được set nếu các thành phần kia null
    }

    public void setFinalAmount(BigDecimal finalAmount) {
        this.finalAmount = finalAmount;
    }

    public String getCustomerNotes() {
        return customerNotes;
    }

    public void setCustomerNotes(String customerNotes) {
        this.customerNotes = customerNotes;
    }

    public String getStaffNotes() {
        return staffNotes;
    }

    public void setStaffNotes(String staffNotes) {
        this.staffNotes = staffNotes;
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

    public Integer getGlobalNailArtId() { // GETTER MỚI
        return globalNailArtId;
    }

    public void setGlobalNailArtId(Integer globalNailArtId) { // SETTER MỚI
        this.globalNailArtId = globalNailArtId;
    }


    @Override
    public String toString() {
        return "Appointment{" +
                "appointmentId=" + appointmentId +
                ", customerId=" + customerId +
                ", staffId=" + staffId +
                ", appointmentDatetime=" + appointmentDatetime +
                ", status='" + status + '\'' +
                ", globalNailArtId=" + globalNailArtId + // THÊM VÀO TOSTRING
                ", finalAmount=" + getFinalAmount() + // Sửa thành getFinalAmount() để đảm bảo tính toán đúng
                '}';
    }
}