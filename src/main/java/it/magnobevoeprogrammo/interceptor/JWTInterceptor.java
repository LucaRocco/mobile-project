package it.magnobevoeprogrammo.interceptor;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import it.magnobevoeprogrammo.exception.TokenValidationException;
import it.magnobevoeprogrammo.model.JWTModel;
import org.slf4j.MDC;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.nio.charset.Charset;
import java.util.Base64;

@Component
public class JWTInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
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
        MDC.put("username", objectMapper.readValue(jsonString, JWTModel.class).getUsername());

        return true;
    }
}
