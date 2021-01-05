package it.magnobevoeprogrammo.model;

import lombok.EqualsAndHashCode;

import java.io.Serializable;

@EqualsAndHashCode
public class PK implements Serializable {
    protected Long userId;
    protected Long amicoId;

    public PK() {
    }

    public PK(Long userId, Long amicoId) {
        this.userId = userId;
        this.amicoId = amicoId;
    }
    // equals, hashCode
}
