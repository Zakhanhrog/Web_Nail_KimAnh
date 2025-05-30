package com.tiemnail.app.model;

import java.sql.Date;
import java.sql.Time;

public class StaffSchedule {
    private int scheduleId;
    private int staffId; // FK to users(user_id)
    private Date workDate;
    private Time startTime;
    private Time endTime;
    private boolean isAvailable;

    // Optional: Tham chiếu đến đối tượng Staff/User đầy đủ
    // private User staffMember;

    public StaffSchedule() {
    }

    public StaffSchedule(int scheduleId, int staffId, Date workDate, Time startTime, Time endTime, boolean isAvailable) {
        this.scheduleId = scheduleId;
        this.staffId = staffId;
        this.workDate = workDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.isAvailable = isAvailable;
    }

    // Getters and Setters
    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public Date getWorkDate() {
        return workDate;
    }

    public void setWorkDate(Date workDate) {
        this.workDate = workDate;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }

    /*
    public User getStaffMember() {
        return staffMember;
    }

    public void setStaffMember(User staffMember) {
        this.staffMember = staffMember;
    }
    */

    @Override
    public String toString() {
        return "StaffSchedule{" +
                "scheduleId=" + scheduleId +
                ", staffId=" + staffId +
                ", workDate=" + workDate +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", isAvailable=" + isAvailable +
                '}';
    }
}