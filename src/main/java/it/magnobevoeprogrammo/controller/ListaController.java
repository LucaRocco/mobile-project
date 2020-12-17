package it.magnobevoeprogrammo.controller;

import it.magnobevoeprogrammo.model.Lista;
import it.magnobevoeprogrammo.model.Prodotto;
import it.magnobevoeprogrammo.model.ProdottoLista;
import it.magnobevoeprogrammo.model.request.SaveProdottoRequest;
import it.magnobevoeprogrammo.model.response.ListaResponse;
import it.magnobevoeprogrammo.service.ListaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.transaction.Transactional;
import java.util.List;

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

    @DeleteMapping(path = "{idLista}/prodotto/{idProdotto}")
    public ResponseEntity<List<ProdottoLista>> deleteProductFromList(@PathVariable("idLista") long idLista, @PathVariable("idProdotto") long idProdotto) {
        return listaService.deleteProductFromList(idProdotto, idLista);
    }
}
