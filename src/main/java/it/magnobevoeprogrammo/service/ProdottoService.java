package it.magnobevoeprogrammo.service;

import it.magnobevoeprogrammo.exception.NotFoundException;
import it.magnobevoeprogrammo.model.Prezzo;
import it.magnobevoeprogrammo.model.Prodotto;

import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.repository.ProdottoRepository;
import it.magnobevoeprogrammo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.*;

import javax.sound.midi.spi.MidiDeviceProvider;
import javax.transaction.Transactional;
import java.sql.Blob;
import java.util.List;
import java.util.Optional;


@Service
public class ProdottoService {

    @Autowired
    private ProdottoRepository prodottorepository;

    @Autowired
    private UserService userService;
   

  /*  @PostMapping(path={"/", ""})
    public Prodotto setProdotto(
        @RequestBody Prodotto prodotto) {
        Prodotto prodotto= new Prodotto();
        prodotto.setNome(nome);
    }*/

    //modifica il nome

    public ResponseEntity<HttpStatus> modificaNome(Long idProdotto, String nuovoNome) {
        Prodotto prodotto = getProdottoById(idProdotto);
        prodotto.setNome(nuovoNome);
        return ResponseEntity.ok().build();
    }


    //ritorna il prodotto dall'id

    public ResponseEntity<Prodotto> getProdotto(Long idProdotto) {
        return ResponseEntity.ok().body(getProdottoById(idProdotto));
    }

    @Transactional
    public ResponseEntity<List<Prodotto>> getAllByUser() {
        return ResponseEntity.ok().body(userService.getUser().getProdotti());
    }

/*
    //get all by user
    @GetMapping(path={"/", ""})
    public List<Prodotto> getAllByUser(
            @RequestBody long id){
     Optional <User> user = user
    }
*/

    //aggiungi prezzo
    public ResponseEntity<HttpStatus> aggiungiPrezzo(Long idProdotto, Prezzo prezzo) {
        Prodotto prodotto = getProdottoById(idProdotto);
        prodotto.getPrezzi().add(prezzo);
        prodottorepository.save(prodotto);
        return ResponseEntity.ok().build();
    }

    //ritorna i prezzi
    @Transactional
    public ResponseEntity<List<Prezzo>> getPrezzi(Long idProdotto) {
        return ResponseEntity.ok().body(getProdottoById(idProdotto).getPrezzi());
    }


    //ritorna la foto

    public ResponseEntity<Blob> getFoto(Long idProdotto) {
        return ResponseEntity.ok().body(getProdottoById(idProdotto).getFoto());
    }

    //modificafoto

    public ResponseEntity<HttpStatus> modificaFoto(Long idProdotto, Blob nuovaFoto) {
        Prodotto prodotto = getProdottoById(idProdotto);
        prodotto.setFoto(nuovaFoto);
        prodottorepository.save(prodotto);
        return ResponseEntity.ok().build();
    }

    //aggiungi foto

    public ResponseEntity<HttpStatus> aggiungiFoto(Long idProdotto, Blob foto) {
        Prodotto prodotto = getProdottoById(idProdotto);
        prodotto.setFoto(foto);
        prodottorepository.save(prodotto);
        return ResponseEntity.ok().build();
    }


    //ritorna il codice a barre

    public ResponseEntity<String> getCodiceABarre(Long idProdotto) {
        return ResponseEntity.ok().body(getProdottoById(idProdotto).getCodiceABarre());
    }

    //aggiungi il codice a barre

    public ResponseEntity<HttpStatus> aggiungiCodice(Long idProdotto, String codice) {
        Prodotto prodotto = getProdottoById(idProdotto);
        prodotto.setCodiceABarre(codice);
        prodottorepository.save(prodotto);
        return ResponseEntity.ok().build();
    }

    private Prodotto getProdottoById(Long idProdotto) {
        Optional<Prodotto> prodottoOptional = prodottorepository.findById(idProdotto);
        if(prodottoOptional.isPresent()) {
            return prodottoOptional.get();
        } else {
            throw new NotFoundException(402, "Prodotto con id " + idProdotto + " non trovato");
        }
    }

}