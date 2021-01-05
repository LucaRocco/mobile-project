package it.magnobevoeprogrammo.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;
import java.io.Serializable;

@Data
@Entity
@IdClass(PK.class)
@Table(name = "amici")
@NoArgsConstructor
@AllArgsConstructor
public class Amici {
    @Id
    private Long userId;
    @Id
    private Long amicoId;
}

