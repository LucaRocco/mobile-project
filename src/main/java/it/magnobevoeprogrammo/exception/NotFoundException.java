package it.magnobevoeprogrammo.exception;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class NotFoundException extends RuntimeException {
    private int code;
    private String message;
    public NotFoundException(int code, String message) {
        super(message);
        this.code = code;
        this.message = message;
    }
}
