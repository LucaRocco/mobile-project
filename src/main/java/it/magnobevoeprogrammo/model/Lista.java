package it.magnobevoeprogrammo.model;

import it.magnobevoeprogrammo.model.response.ListaResponse;
import lombok.Data;

import javax.persistence.*;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Data
@Entity
@Table(name = "lista")
public class Lista {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String descrizione;
    private Date dataCreazione;
    @OneToMany(mappedBy = "lista", fetch = FetchType.EAGER)
    private List<ProdottoLista> prodotti;
    @ManyToMany(mappedBy = "liste")
    private List<User> users;
    private Long creatorId;

    public ListaResponse toResponse() {
        ListaResponse listaResponse = new ListaResponse();
        listaResponse.setId(this.id);
        listaResponse.setCreatorId(this.creatorId);
        listaResponse.setDataCreazione(this.dataCreazione);
        listaResponse.setDescrizione(this.descrizione);
        listaResponse.setNome(this.nome);
        listaResponse.setProdotti(this.prodotti.stream().map(ProdottoLista::toResponse).collect(Collectors.toList()));
        listaResponse.setUsers(this.users);
        return listaResponse;
    }
}
