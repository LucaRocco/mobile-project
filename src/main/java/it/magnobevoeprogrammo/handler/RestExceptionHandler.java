package it.magnobevoeprogrammo.handler;

import it.magnobevoeprogrammo.exception.NotFoundException;
import it.magnobevoeprogrammo.exception.TokenValidationException;
import it.magnobevoeprogrammo.model.response.ErrorResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import javax.xml.ws.Response;

@ControllerAdvice
public class RestExceptionHandler extends ResponseEntityExceptionHandler {
    @ExceptionHandler(value = NotFoundException.class)
    public ResponseEntity<ErrorResponse> notFoundExceptionHandler(NotFoundException e, WebRequest request) {
        return ResponseEntity.status(403).body(new ErrorResponse(e.getCode(), e.getMessage()));
    }

    @ExceptionHandler(TokenValidationException.class)
    public ResponseEntity<ErrorResponse> tokenValidationExceptionHandler(TokenValidationException e, WebRequest request) {
        return ResponseEntity.status(400).body(new ErrorResponse(400, e.getMessage()));
    }
}
