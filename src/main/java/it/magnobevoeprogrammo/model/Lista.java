package it.magnobevoeprogrammo.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.Table;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "lista")
public class Lista {
    @Id
    private Long id;
    private String nome;
    private Date dataCreazione;
    @ManyToMany
    private List<Prodotto> prodotti;
    @ManyToMany
    private List<User> users;
}
