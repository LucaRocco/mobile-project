package it.magnobevoeprogrammo.model;

import lombok.Data;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Data
@Entity
@Table(name = "lista")
public class Lista {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String descrizione;
    private Date dataCreazione;
    @ManyToMany
    private List<Prodotto> prodotti;
    @ManyToMany
    private List<User> users;
}
