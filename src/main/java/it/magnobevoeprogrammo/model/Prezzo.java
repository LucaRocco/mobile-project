package it.magnobevoeprogrammo.model;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "prezzo")
public class Prezzo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(targetEntity = Prodotto.class)
    private Prodotto prodotto;
    private BigDecimal prezzo;
    private String nomeSupermercato;

}
