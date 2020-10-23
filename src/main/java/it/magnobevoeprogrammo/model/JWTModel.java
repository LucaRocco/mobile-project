package it.magnobevoeprogrammo.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class JWTModel {
    private String name;
    @JsonProperty("family_name")
    private String familyName;
    private String email;
}
