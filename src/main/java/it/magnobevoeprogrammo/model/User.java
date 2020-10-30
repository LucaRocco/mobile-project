package it.magnobevoeprogrammo.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import javax.persistence.*;
import java.util.List;

@Data
@Entity
@Table(name = "user")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) //Chiave primaria
    private Long id;
    @Column(unique = true)
    private String email;
    private String nome;
    private String cognome;
    private String foto;
    @JsonIgnore
    @OneToMany
    private List<Prodotto> prodotti;
}
