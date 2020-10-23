package it.magnobevoeprogrammo.model;

import lombok.Data;

import javax.persistence.*;
import java.sql.Blob;
import java.util.List;

@Data
@Entity
@Table(name = "user")
public class User {
    @Id //Chiave primaria
    private String id;
    private String email;
    private String nome;
    private String cognome;
    private String password;
    @Lob
    private Blob foto;
    @OneToMany
    private List<Prodotto> prodotti;
    @ManyToMany
    private List<Lista> liste;
}
