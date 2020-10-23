package it.magnobevoeprogrammo.model;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.List;

@Entity
@Table(name = "prezzo")
public class Prezzo {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(targetEntity = Prodotto.class)   //relazione n:1
    private Prodotto prodotto; //chiave esterna che deve fare riferimento all chiave primaria della tabella prodotto
    private BigDecimal prezzo;
    private String nomeSupermercato;

}
