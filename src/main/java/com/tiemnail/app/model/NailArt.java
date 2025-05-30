package com.tiemnail.app.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class NailArt {
    private int nailArtId;
    private String nailArtName;
    private String description;
    private String imageUrl;
    private BigDecimal priceAddon;
    private Integer collectionId; // Có thể NULL, nên dùng Integer
    private int likesCount;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Optional: Tham chiếu đến NailArtCollection
    // private NailArtCollection collection;

    public NailArt() {
    }

    public NailArt(int nailArtId, String nailArtName, String description, String imageUrl, BigDecimal priceAddon, Integer collectionId, int likesCount, boolean isActive, Timestamp createdAt, Timestamp updatedAt) {
        this.nailArtId = nailArtId;
        this.nailArtName = nailArtName;
        this.description = description;
        this.imageUrl = imageUrl;
        this.priceAddon = priceAddon;
        this.collectionId = collectionId;
        this.likesCount = likesCount;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getNailArtId() {
        return nailArtId;
    }

    public void setNailArtId(int nailArtId) {
        this.nailArtId = nailArtId;
    }

    public String getNailArtName() {
        return nailArtName;
    }

    public void setNailArtName(String nailArtName) {
        this.nailArtName = nailArtName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public BigDecimal getPriceAddon() {
        return priceAddon;
    }

    public void setPriceAddon(BigDecimal priceAddon) {
        this.priceAddon = priceAddon;
    }

    public Integer getCollectionId() {
        return collectionId;
    }

    public void setCollectionId(Integer collectionId) {
        this.collectionId = collectionId;
    }

    public int getLikesCount() {
        return likesCount;
    }

    public void setLikesCount(int likesCount) {
        this.likesCount = likesCount;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
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
    public NailArtCollection getCollection() {
        return collection;
    }

    public void setCollection(NailArtCollection collection) {
        this.collection = collection;
    }
    */

    @Override
    public String toString() {
        return "NailArt{" +
                "nailArtId=" + nailArtId +
                ", nailArtName='" + nailArtName + '\'' +
                ", priceAddon=" + priceAddon +
                '}';
    }
}