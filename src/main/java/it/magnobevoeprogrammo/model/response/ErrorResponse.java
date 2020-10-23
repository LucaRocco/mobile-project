package it.magnobevoeprogrammo.model.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode
@AllArgsConstructor
public class ErrorResponse {
    private int code;
    private String message;
}
