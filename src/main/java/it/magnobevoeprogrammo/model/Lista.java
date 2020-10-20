package it.magnobevoeprogrammo.model;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "lista")
public class Lista {
    @Id @GeneratedValue(strategy = GenerationType.TABLE)
    private Long id;
    private String nome;
    private Date dataCreazione;
    @ManyToMany
    private List<Prodotto> prodotti;
    @ManyToMany
    private List<User> users;
}
