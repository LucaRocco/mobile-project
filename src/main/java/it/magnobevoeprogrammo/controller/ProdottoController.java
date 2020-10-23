package it.magnobevoeprogrammo.controller;

import it.magnobevoeprogrammo.Service.ProdottoService;
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
    @PostMapping(path={"/", ""})
    public ResponseEntity<HttpStatus> modificaNome(
            @RequestParam("prodotto") Prodotto prodotto,
            @RequestParam("nuovoNome") String nuovoNome){
        return prodottoService.modificaNome(prodotto, nuovoNome);
    }

    //ritorna il prodotto dall'id
    @GetMapping(path={"/", ""})
    public ResponseEntity<Prodotto> getProdotto( @RequestParam("id") long id) throws Exception{
        return prodottoService.getProdotto(id);
    }

    @GetMapping(path={"/", ""})
    public ResponseEntity<Long> getId(
            @RequestBody Prodotto prodotto){
        return prodottoService.getId(prodotto);
    }


    //get all by user
    @GetMapping(path={"/", ""})
    public ResponseEntity<List<Prodotto>> getAllByUser(@RequestParam("id") long id) throws Exception{
        return prodottoService.getAllByUser(id);
    }


    //aggiungi prezzo
    @PostMapping(path={"/", ""})
    public ResponseEntity<HttpStatus> aggiungiPrezzo(
            @RequestParam("prodotto") Prodotto prodotto,
            @RequestParam("prezzo") Prezzo prezzo){
        return prodottoService.aggiungiPrezzo(prodotto, prezzo);
    }

    //ritorna il prezzo
    @GetMapping(path={"/", ""})
    public ResponseEntity<List<Prezzo>> getPrezzo(
            @RequestBody Prodotto prodotto){
        return prodottoService.getPrezzo(prodotto);
    }



    //ritorna la foto
    @GetMapping(path={"/", ""})
    public ResponseEntity<Blob> getFoto(
            @RequestBody Prodotto prodotto){
        return prodottoService.getFoto(prodotto);
    }

    //modificafoto
    @PostMapping(path={"/", ""})
    public ResponseEntity<HttpStatus> modificaFoto(
            @RequestParam("prodotto") Prodotto prodotto,
            @RequestParam("foto") Blob nuovaFoto){
        return prodottoService.modificaFoto(prodotto,nuovaFoto);
    }

    //aggiungi foto
    @PostMapping(path={"/", ""})
    public ResponseEntity<HttpStatus> aggiungiFoto(
            @RequestParam("prodotto") Prodotto prodotto,
            @RequestParam("foto") Blob foto){
        return prodottoService.aggiungiFoto(prodotto,foto);
    }



    //ritorna il codice a barre
    @GetMapping(path={"/", ""})
    public ResponseEntity<String> getCodiceABarre(
            @RequestParam("prodotto") Prodotto prodotto){
        return prodottoService.getCodiceABarre(prodotto);
    }

    //aggiungi il codice a barre
    @PostMapping(path={"/", ""})
    public ResponseEntity<HttpStatus> aggiungiCodice(
            @RequestParam("prodotto") Prodotto prodotto,
            @RequestParam("codice") String codice){
        return prodottoService.aggiungiCodice(prodotto, codice);
    }


}
