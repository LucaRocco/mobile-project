package it.magnobevoeprogrammo.model.response;

import it.magnobevoeprogrammo.model.User;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class ListaResponse {
    private Long id;
    private String nome;
    private String descrizione;
    private Date dataCreazione;
    private List<ProdottoListaResponse> prodotti;
    private List<User> users;
    private Long creatorId;
    private Long userId;
}
