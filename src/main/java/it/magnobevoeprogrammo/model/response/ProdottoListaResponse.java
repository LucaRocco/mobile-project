package it.magnobevoeprogrammo.model.response;

import it.magnobevoeprogrammo.model.Prezzo;
import it.magnobevoeprogrammo.model.StatusProdotto;
import it.magnobevoeprogrammo.model.User;
import lombok.Data;

import java.util.List;

@Data
public class ProdottoListaResponse {
    private Long id;
    private Long originalId;
    private String nome;
    private String categoria;
    private String foto;
    private String codiceABarre;
    private List<Prezzo> prezzi;
    private User user;
    private StatusProdotto status;
    private String dataAcquisto;
    private User utenteAcquisto;
    private int quantita;
}
