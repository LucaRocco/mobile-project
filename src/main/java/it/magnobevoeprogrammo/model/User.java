package it.magnobevoeprogrammo.model;

import lombok.Data;

import javax.persistence.*;
import java.sql.Blob;
import java.util.List;

@Data
@Entity
@Table(name = "user")
public class User {
    @Id @GeneratedValue(strategy = GenerationType.TABLE) //Chiave primaria
    private Long id;
    private String email;
    private String nome;
    private String cognome;
    private String password;
    @Lob
    private Blob foto;
    @ManyToMany
    private List<Lista> liste;
}
