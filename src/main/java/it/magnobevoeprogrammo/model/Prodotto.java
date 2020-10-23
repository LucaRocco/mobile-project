package it.magnobevoeprogrammo.model;

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
    @Lob
    private Blob foto;
    private String codiceABarre;
    @OneToMany //Relazione 1:n
    private List<Prezzo> prezzi;
    @ManyToOne
    private User user;
    @ManyToMany
    private List<Lista> liste;
}
