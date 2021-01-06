package it.magnobevoeprogrammo.interceptor;

import ch.qos.logback.core.util.TimeUtil;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import it.magnobevoeprogrammo.exception.TokenValidationException;
import it.magnobevoeprogrammo.model.JWTModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.nio.charset.Charset;
import java.util.Base64;

public class JWTInterceptor implements HandlerInterceptor {
    private final Logger log = LoggerFactory.getLogger(JWTInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if(!(request.getRequestURI().equals("/user/friends") && request.getMethod().toLowerCase().equals("get"))) {
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                log.error(e.getMessage());
            }
        }
        if(!request.getRequestURI().equals("/user/create")) {
            log.debug("Request intercepted");
            if (request.getHeader("Authorization") == null)
                throw new TokenValidationException("Authorization token non presente nella request");
            String token = request.getHeader("Authorization");
            if (!token.contains("Bearer ")) {
                throw new TokenValidationException("Authorization token non è un bearer token");
            }
            token = token.replace("Bearer ", "");
            if (token.split("\\.").length != 3)
                throw new TokenValidationException("Malformed Authorization token");
            token = token.split("\\.")[1];

            String jsonString = new String(Base64.getDecoder().decode(token), Charset.defaultCharset());
            ObjectMapper objectMapper = new ObjectMapper()
                    .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
            MDC.put("email", objectMapper.readValue(jsonString, JWTModel.class).getEmail().trim());

            log.debug("Request from: " + MDC.get("email"));
        }
        return true;
    }
}
