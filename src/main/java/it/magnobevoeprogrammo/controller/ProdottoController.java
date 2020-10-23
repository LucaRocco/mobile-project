package it.magnobevoeprogrammo.controller;

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

  /*  @PostMapping(path={"/", ""})
    public Prodotto setProdotto(
        @RequestBody Prodotto prodotto) {
        Prodotto prodotto= new Prodotto();
        prodotto.setNome(nome);
    }*/

    //modifica il nome
    @PutMapping(path={"/modificaNome"})
    public ResponseEntity<HttpStatus> modificaNome(
            @RequestParam("idProdotto") Long idProdotto,
            @RequestParam("nuovoNome") String nuovoNome){
        return prodottoService.modificaNome(idProdotto, nuovoNome);
    }

    //ritorna il prodotto dall'id
    @GetMapping(path={"/", ""})
    public ResponseEntity<Prodotto> getProdotto( @RequestParam("id") long id) {
        return prodottoService.getProdotto(id);
    }

    //get all by user
    @GetMapping(path= "/all")
    public ResponseEntity<List<Prodotto>> getAllByUser() {
        return prodottoService.getAllByUser();
    }


    //aggiungi prezzo
    @PostMapping(path= "/aggiungiPrezzo")
    public ResponseEntity<HttpStatus> aggiungiPrezzo(
            @RequestParam("idProdotto") Long idProdotto,
            @RequestParam("prezzo") Prezzo prezzo){
        return prodottoService.aggiungiPrezzo(idProdotto, prezzo);
    }

    //ritorna il prezzo
    @GetMapping(path= "/prezzi")
    public ResponseEntity<List<Prezzo>> getPrezzi(
            @RequestParam("idProdotto") Long idProdotto){
        return prodottoService.getPrezzi(idProdotto);
    }

    //ritorna la foto
    @GetMapping(path={"/foto", ""})
    public ResponseEntity<Blob> getFoto(
            @RequestParam("idProdotto") Long idProdotto){
        return prodottoService.getFoto(idProdotto);
    }

    //modificafoto
    @PutMapping(path={"/foto", ""})
    public ResponseEntity<HttpStatus> modificaFoto(
            @RequestParam("idProdotto") Long idProdotto,
            @RequestParam("foto") Blob nuovaFoto){
        return prodottoService.modificaFoto(idProdotto, nuovaFoto);
    }

    //aggiungi foto
    @PostMapping(path={"/foto", ""})
    public ResponseEntity<HttpStatus> aggiungiFoto(
            @RequestParam("idProdotto") Long idProdotto,
            @RequestParam("foto") Blob foto){
        return prodottoService.aggiungiFoto(idProdotto, foto);
    }

    //ritorna il codice a barre
    @GetMapping(path={"/codice", ""})
    public ResponseEntity<String> getCodiceABarre(
            @RequestParam("idProdotto") Long idProdotto){
        return prodottoService.getCodiceABarre(idProdotto);
    }

    //aggiungi il codice a barre
    @PostMapping(path={"/codice", ""})
    public ResponseEntity<HttpStatus> aggiungiCodice(
            @RequestParam("idProdotto") Long idProdotto,
            @RequestParam("codice") String codice){
        return prodottoService.aggiungiCodice(idProdotto, codice);
    }


}
