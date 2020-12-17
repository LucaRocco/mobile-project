package it.magnobevoeprogrammo.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import javax.persistence.*;
import java.util.List;

@Data
@Entity
@Table(name = "prodotti")
public class Prodotto {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String categoria;
    private String foto;
    private String codiceABarre;
    @OneToMany(mappedBy = "prodotto")
    List<ProdottoLista> prodottiLista;
    @OneToMany(mappedBy = "prodotto")
    private List<Prezzo> prezzi;
    @ManyToOne
    private User user;
}
