package it.magnobevoeprogrammo.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import it.magnobevoeprogrammo.model.response.ProdottoListaResponse;
import lombok.Data;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Date;

@Data
@Entity
@Table(name = "prodotto_lista")
public class ProdottoLista {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @JsonIgnore
    @ManyToOne
    private Lista lista;
    @ManyToOne
    private Prodotto prodotto;
    private Date dataAggiunta;
    @Enumerated(EnumType.STRING)
    private StatusProdotto status;
    private Date dataAquisto;
    @OneToOne
    private User utenteAcquisto;
    private int quantita;

    public static ProdottoLista fromProdotto(Prodotto p, Lista lista, int quantita) {
        ProdottoLista prodottoLista = new ProdottoLista();
        prodottoLista.setDataAggiunta(new Date());
        prodottoLista.setLista(lista);
        prodottoLista.setProdotto(p);
        prodottoLista.setUtenteAcquisto(null);
        prodottoLista.setStatus(StatusProdotto.DA_ACQUISTARE);
        prodottoLista.setQuantita(quantita);
        return prodottoLista;
    }

    public ProdottoListaResponse toResponse() {
        ProdottoListaResponse response = new ProdottoListaResponse();
        response.setCategoria(this.prodotto.getCategoria());
        response.setCodiceABarre(this.prodotto.getCodiceABarre());
        response.setDataAcquisto(this.dataAquisto == null ? null : this.dataAquisto.toString());
        response.setFoto(this.prodotto.getFoto());
        response.setId(this.id);
        response.setNome(this.prodotto.getNome());
        response.setPrezzi(new ArrayList<>());
        response.setStatus(this.status);
        response.setUtenteAcquisto(this.utenteAcquisto);
        response.setUser(this.prodotto.getUser());
        response.setQuantita(this.quantita);
        response.setOriginalId(this.prodotto.getId());
        return response;
    }
}