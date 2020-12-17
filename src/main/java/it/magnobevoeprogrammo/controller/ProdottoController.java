package it.magnobevoeprogrammo.controller;

import it.magnobevoeprogrammo.model.response.ProdottoResponse;
import it.magnobevoeprogrammo.service.ProdottoService;
import it.magnobevoeprogrammo.model.Prezzo;
import it.magnobevoeprogrammo.model.Prodotto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.sql.Blob;
import java.util.List;

@RestController
@RequestMapping("/prodotto")
public class ProdottoController {

    @Autowired
    private ProdottoService prodottoService;

    //modifica il nome
    @PutMapping(path = "/modificaNome")
    public ResponseEntity<HttpStatus> modificaNome(
            @RequestParam("idProdotto") Long idProdotto,
            @RequestParam("nuovoNome") String nuovoNome){
        return prodottoService.modificaNome(idProdotto, nuovoNome);
    }

    //ritorna il prodotto dall'id
    @GetMapping(path = {"/", ""})
    public ResponseEntity<Prodotto> getProdotto(@RequestParam("id") long id) {
        return prodottoService.getProdotto(id);
    }

    @PostMapping(path = {"/", ""})
    public ResponseEntity<Prodotto> saveProdotto(@RequestBody Prodotto prodotto) {
        return prodottoService.saveProdotto(prodotto);
    }

    @PostMapping(path = "/multi")
    public ResponseEntity<HttpStatus> saveProdotti(@RequestBody List<Prodotto> prodotti) {
        return prodottoService.saveProdotti(prodotti);
    }

    //get all by user
    @GetMapping(path= "/all")
    public ResponseEntity<List<ProdottoResponse>> getAllByUser() {
        return prodottoService.getAllByUser();
    }

    //ritorna la foto
    @GetMapping(path = "/foto")
    public ResponseEntity<String> getFoto(
            @RequestParam("idProdotto") Long idProdotto){
        return prodottoService.getFoto(idProdotto);
    }

    //modificafoto
    @PutMapping(path = "/foto")
    public ResponseEntity<HttpStatus> modificaFoto(
            @RequestParam("idProdotto") Long idProdotto,
            @RequestParam("foto") String nuovaFoto){
        return prodottoService.modificaFoto(idProdotto, nuovaFoto);
    }

    //aggiungi foto
    @PostMapping(path = "/foto")
    public ResponseEntity<HttpStatus> aggiungiFoto(
            @RequestParam("idProdotto") Long idProdotto,
            @RequestParam("foto") String foto){
        return prodottoService.aggiungiFoto(idProdotto, foto);
    }

    //ritorna il codice a barre
    @GetMapping(path = "/codice")
    public ResponseEntity<String> getCodiceABarre(
            @RequestParam("idProdotto") Long idProdotto){
        return prodottoService.getCodiceABarre(idProdotto);
    }

    //aggiungi il codice a barre
    @PostMapping(path = "/codice")
    public ResponseEntity<HttpStatus> aggiungiCodice(
            @RequestParam("idProdotto") Long idProdotto,
            @RequestParam("codice") String codice){
        return prodottoService.aggiungiCodice(idProdotto, codice);
    }


}
