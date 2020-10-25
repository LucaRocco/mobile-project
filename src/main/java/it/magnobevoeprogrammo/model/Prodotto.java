package it.magnobevoeprogrammo.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import javax.persistence.*;
import java.sql.Blob;
import java.util.List;

@Data
@Entity
@Table(name = "prodotto")
public class Prodotto {
    @Id @GeneratedValue(strategy= GenerationType.IDENTITY) //generare la chiave
    private Long id;
    private String nome;
    private String categoria;
    private String foto;
    private String codiceABarre;
    @OneToMany //Relazione 1:n
    private List<Prezzo> prezzi;
    @JsonIgnore
    @ManyToOne
    private User user;
    @JsonIgnore
    @ManyToMany
    private List<Lista> liste;
}
