package it.magnobevoeprogrammo.controller;

import it.magnobevoeprogrammo.model.Lista;
import it.magnobevoeprogrammo.model.ProdottoLista;
import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.model.request.SaveProdottoRequest;
import it.magnobevoeprogrammo.model.response.ListaResponse;
import it.magnobevoeprogrammo.model.response.ProdottoListaResponse;
import it.magnobevoeprogrammo.service.ListaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.transaction.Transactional;
import javax.websocket.server.PathParam;
import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/lista")
public class ListaController {

    @Autowired
    private ListaService listaService;

    @Transactional
    @GetMapping(path = "/{idLista}")
    public ResponseEntity<Lista> getListaById(@PathVariable("idLista") Long idLista) {
        return listaService.getListaById(idLista);
    }

    @Transactional
    @GetMapping(path = {"", "/"})
    public ResponseEntity<List<ListaResponse>> getAllLists() {
        return listaService.getAllLists();
    }

    @PostMapping(path = {"", "/"}, consumes = "application/json; charset=utf-8")
    public ResponseEntity<Lista> addList(@RequestBody Lista lista) {
        return listaService.addList(lista);
    }

    @PostMapping(path = "/prodotto")
    public ResponseEntity<HttpStatus> saveProductToList(@RequestBody SaveProdottoRequest request) {
        return listaService.saveProductToList(request);
    }

    @PostMapping(path = "/prodotti")
    public ResponseEntity<HttpStatus> saveProductsToList(@RequestBody List<SaveProdottoRequest> request) {
        return listaService.saveProductsToList(request);
    }

    @DeleteMapping(path = "/{idLista}/prodotto/{idProdotto}")
    public ResponseEntity<List<ProdottoListaResponse>> deleteProductFromList(@PathVariable("idLista") long idLista, @PathVariable("idProdotto") long idProdotto) {
        return listaService.deleteProductFromList(idProdotto, idLista);
    }

    @PostMapping(path = "/{idLista}/partecipanti")
    public ResponseEntity<Set<User>> addParticipants(@PathVariable("idLista") long idLista, @RequestBody List<String> emails) {
        return listaService.addParticipant(emails, idLista);
    }

    @DeleteMapping(path = "/{idLista}/partecipanti")
    public ResponseEntity<Set<User>> removeParticipant(@PathVariable("idLista") long idLista, @RequestParam("email") String email) {
        return listaService.removeParticipant(email, idLista);
    }

    @PutMapping(path = "/{idLista}/prodotto/{idProdotto}")
    public ResponseEntity<Set<ProdottoListaResponse>> changeProductStatus(@PathVariable("idLista") long idLista, @PathVariable("idProdotto") long idProdotto) {
        return listaService.changeProductStatus(idProdotto, idLista);
    }
}
