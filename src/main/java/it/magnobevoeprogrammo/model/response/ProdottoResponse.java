package it.magnobevoeprogrammo.model.response;

import it.magnobevoeprogrammo.model.Prodotto;
import lombok.Data;

@Data
public class ProdottoResponse {
    private long id;
    private String nome;
    private String categoria;
    private String foto;

    public static ProdottoResponse fromProdotto(Prodotto prodotto) {
        ProdottoResponse prodottoResponse = new ProdottoResponse();
        prodottoResponse.setId(prodotto.getId());
        prodottoResponse.setNome(prodotto.getNome());
        prodottoResponse.setCategoria(prodotto.getCategoria());
        prodottoResponse.setFoto(prodotto.getFoto());
        return prodottoResponse;
    }
}
