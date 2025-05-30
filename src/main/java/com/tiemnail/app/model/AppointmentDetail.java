package com.tiemnail.app.model;

import java.math.BigDecimal;

public class AppointmentDetail {
    private int appointmentDetailId;
    private int appointmentId;
    private int serviceId;
    private Integer nailArtId; // FK, có thể NULL
    private BigDecimal servicePriceAtBooking;
    private BigDecimal nailArtPriceAtBooking;
    private int quantity;

    // Optional: Tham chiếu đến Service và NailArt
    // private Service service;
    // private NailArt nailArt;

    public AppointmentDetail() {
    }

    public AppointmentDetail(int appointmentDetailId, int appointmentId, int serviceId, Integer nailArtId, BigDecimal servicePriceAtBooking, BigDecimal nailArtPriceAtBooking, int quantity) {
        this.appointmentDetailId = appointmentDetailId;
        this.appointmentId = appointmentId;
        this.serviceId = serviceId;
        this.nailArtId = nailArtId;
        this.servicePriceAtBooking = servicePriceAtBooking;
        this.nailArtPriceAtBooking = nailArtPriceAtBooking;
        this.quantity = quantity;
    }

    // Getters and Setters
    public int getAppointmentDetailId() {
        return appointmentDetailId;
    }

    public void setAppointmentDetailId(int appointmentDetailId) {
        this.appointmentDetailId = appointmentDetailId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public Integer getNailArtId() {
        return nailArtId;
    }

    public void setNailArtId(Integer nailArtId) {
        this.nailArtId = nailArtId;
    }

    public BigDecimal getServicePriceAtBooking() {
        return servicePriceAtBooking;
    }

    public void setServicePriceAtBooking(BigDecimal servicePriceAtBooking) {
        this.servicePriceAtBooking = servicePriceAtBooking;
    }

    public BigDecimal getNailArtPriceAtBooking() {
        return nailArtPriceAtBooking;
    }

    public void setNailArtPriceAtBooking(BigDecimal nailArtPriceAtBooking) {
        this.nailArtPriceAtBooking = nailArtPriceAtBooking;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    /*
    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public NailArt getNailArt() {
        return nailArt;
    }

    public void setNailArt(NailArt nailArt) {
        this.nailArt = nailArt;
    }
    */

    @Override
    public String toString() {
        return "AppointmentDetail{" +
                "appointmentDetailId=" + appointmentDetailId +
                ", appointmentId=" + appointmentId +
                ", serviceId=" + serviceId +
                ", nailArtId=" + nailArtId +
                ", quantity=" + quantity +
                '}';
    }
}