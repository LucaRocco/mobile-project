package it.magnobevoeprogrammo.model;

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

    public static ProdottoLista fromProdotto(Prodotto p, Lista lista) {
        ProdottoLista prodottoLista = new ProdottoLista();
        prodottoLista.setDataAggiunta(new Date());
        prodottoLista.setLista(lista);
        prodottoLista.setProdotto(p);
        prodottoLista.setUtenteAcquisto(null);
        prodottoLista.setStatus(StatusProdotto.DA_ACQUISTARE);
        return prodottoLista;
    }

    public ProdottoListaResponse toResponse() {
        ProdottoListaResponse response = new ProdottoListaResponse();
        response.setCategoria(this.prodotto.getCategoria());
        response.setCodiceABarre(this.prodotto.getCodiceABarre());
        response.setDataAquisto(this.dataAquisto);
        response.setFoto(this.prodotto.getFoto());
        response.setId(this.id);
        response.setNome(this.prodotto.getNome());
        response.setPrezzi(new ArrayList<>());
        response.setStatus(this.status);
        response.setUtenteAcquisto(this.utenteAcquisto);
        response.setUser(this.prodotto.getUser());
        return response;
    }
}