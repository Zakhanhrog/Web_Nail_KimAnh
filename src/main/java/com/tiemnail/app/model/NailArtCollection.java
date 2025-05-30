package com.tiemnail.app.model;

import java.sql.Timestamp;

public class NailArtCollection {
    private int collectionId;
    private String collectionName;
    private String description;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public NailArtCollection() {
    }

    public NailArtCollection(int collectionId, String collectionName, String description, Timestamp createdAt, Timestamp updatedAt) {
        this.collectionId = collectionId;
        this.collectionName = collectionName;
        this.description = description;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getCollectionId() {
        return collectionId;
    }

    public void setCollectionId(int collectionId) {
        this.collectionId = collectionId;
    }

    public String getCollectionName() {
        return collectionName;
    }

    public void setCollectionName(String collectionName) {
        this.collectionName = collectionName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    @Override
    public String toString() {
        return "NailArtCollection{" +
                "collectionId=" + collectionId +
                ", collectionName='" + collectionName + '\'' +
                '}';
    }
}