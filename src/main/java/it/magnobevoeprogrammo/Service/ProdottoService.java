package it.magnobevoeprogrammo.Service;

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

import javax.transaction.Transactional;
import java.sql.Blob;
import java.util.List;
import java.util.Optional;


@Service
public class ProdottoService {

    @Autowired
    private ProdottoRepository prodottorepository;

    @Autowired
    private UserRepository userRepository;
   

  /*  @PostMapping(path={"/", ""})
    public Prodotto setProdotto(
        @RequestBody Prodotto prodotto) {
        Prodotto prodotto= new Prodotto();
        prodotto.setNome(nome);
    }*/

    //modifica il nome

    public ResponseEntity<HttpStatus> modificaNome(Prodotto prodotto,String nuovoNome) {
        prodotto.setNome(nuovoNome);
        return ResponseEntity.ok().build();
    }


    //ritorna il prodotto dall'id

    public ResponseEntity<Prodotto> getProdotto(long id) throws Exception {
        Optional<Prodotto> prod = prodottorepository.findById(id);

        if (prod.isPresent()) {
            return ResponseEntity.ok().body(prod.get());
        } else {
            throw new Exception();
        }
    }

    public ResponseEntity<Long> getId(Prodotto prodotto) {
        return ResponseEntity.ok().body(prodottorepository.save(prodotto).getId());
    }

    @Transactional
    public ResponseEntity<List<Prodotto>> getAllByUser(long id) throws Exception {
        Optional<User> user = userRepository.findById(id);

        if (user.isPresent()) {
            return ResponseEntity.ok().body(user.get().getProdotti());
        } else {
            throw new Exception();
        }
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

    public ResponseEntity<HttpStatus> aggiungiPrezzo( Prodotto prodotto, Prezzo prezzo) {
        prodotto.getPrezzi().add(prezzo);
        return ResponseEntity.ok().build();
    }

    //ritorna il prezzo

    public ResponseEntity<List<Prezzo>> getPrezzo( Prodotto prodotto) {
        return ResponseEntity.ok().body(prodotto.getPrezzi());
    }


    //ritorna la foto

    public ResponseEntity<Blob> getFoto(Prodotto prodotto) {
        return ResponseEntity.ok().body(prodottorepository.save(prodotto).getFoto());
    }

    //modificafoto

    public ResponseEntity<HttpStatus> modificaFoto(Prodotto prodotto, Blob nuovaFoto) {
        prodotto.setFoto(nuovaFoto);
        return ResponseEntity.ok().build();
    }

    //aggiungi foto

    public ResponseEntity<HttpStatus> aggiungiFoto(Prodotto prodotto, Blob foto) {
        prodotto.setFoto(foto);
        return ResponseEntity.ok().build();
    }


    //ritorna il codice a barre

    public ResponseEntity<String> getCodiceABarre( Prodotto prodotto) {
        return ResponseEntity.ok().body(prodottorepository.save(prodotto).getCodiceABarre());
    }

    //aggiungi il codice a barre

    public ResponseEntity<HttpStatus> aggiungiCodice(Prodotto prodotto, String codice) {
        prodotto.setCodiceABarre(codice);
        return ResponseEntity.ok().build();
    }


}
