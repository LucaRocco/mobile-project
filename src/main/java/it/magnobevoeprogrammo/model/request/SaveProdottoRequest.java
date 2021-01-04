package it.magnobevoeprogrammo.model.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SaveProdottoRequest {
    private Long id;
    private String nome;
    private String categoria;
    private int idListaDestinazione;
    private int quantita;
}
