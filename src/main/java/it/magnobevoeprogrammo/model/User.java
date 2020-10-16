package it.magnobevoeprogrammo.model;

import javax.persistence.*;
import java.sql.Blob;
import java.util.List;

@Entity
@Table(name = "user")
public class User {
    @Id //Chiave primaria
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