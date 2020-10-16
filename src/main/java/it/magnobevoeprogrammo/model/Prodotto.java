package it.magnobevoeprogrammo.model;

import javax.persistence.*;
import java.sql.Blob;
import java.util.List;

@Entity
@Table(name = "prodotto")
public class Prodotto {
    @Id
    private Long id;
    private String nome;
    @Lob
    private Blob foto;
    private String codiceABarre;
    @OneToMany //Relazione 1:n
    private List<Prezzo> prezzi;
    @ManyToMany
    private List<Lista> liste;
}
