package it.magnobevoeprogrammo.service;

import it.magnobevoeprogrammo.exception.NotFoundException;
import it.magnobevoeprogrammo.model.Prodotto;
import it.magnobevoeprogrammo.model.response.ProdottoResponse;
import it.magnobevoeprogrammo.repository.ProdottoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


@Service
public class ProdottoService {

    @Autowired
    private ProdottoRepository prodottoRepository;

    @Autowired
    private UserService userService;

    @Transactional
    public ResponseEntity<Prodotto> saveProdotto(Prodotto prodotto) {
        prodotto.setUser(userService.getUser());
        return ResponseEntity.ok().body(prodottoRepository.save(prodotto));
    }

    @Transactional
    public ResponseEntity<HttpStatus> saveProdotti(List<Prodotto> prodotti) {
        prodotti.forEach(prodotto -> prodotto.setUser(userService.getUser()));
        prodottoRepository.saveAll(prodotti);
        return ResponseEntity.ok().build();
    }

    @Transactional
    public ResponseEntity<HttpStatus> modificaNome(Long idProdotto, String nuovoNome) {
        Prodotto prodotto = getProdottoById(idProdotto);
        prodotto.setNome(nuovoNome);
        return ResponseEntity.ok().build();
    }

    @Transactional
    public ResponseEntity<Prodotto> getProdotto(Long idProdotto) {
        return ResponseEntity.ok().body(getProdottoById(idProdotto));
    }

    @Transactional
    public ResponseEntity<List<ProdottoResponse>> getAllByUser() {
        List<ProdottoResponse> response =
                prodottoRepository.findAllByUser(userService.getUser())
                        .stream().map(ProdottoResponse::fromProdotto).collect(Collectors.toList());
        return ResponseEntity.ok().body(response);
    }

    @Transactional
    public ResponseEntity<String> getFoto(Long idProdotto) {
        return ResponseEntity.ok().body(getProdottoById(idProdotto).getFoto());
    }

    @Transactional
    public ResponseEntity<HttpStatus> modificaFoto(Long idProdotto, String nuovaFoto) {
        Prodotto prodotto = getProdottoById(idProdotto);
        prodotto.setFoto(nuovaFoto);
        prodottoRepository.save(prodotto);
        return ResponseEntity.ok().build();
    }

    @Transactional
    public ResponseEntity<HttpStatus> aggiungiFoto(Long idProdotto, String foto) {
        Prodotto prodotto = getProdottoById(idProdotto);
        prodotto.setFoto(foto);
        prodottoRepository.save(prodotto);
        return ResponseEntity.ok().build();
    }

    @Transactional
    public ResponseEntity<String> getCodiceABarre(Long idProdotto) {
        return ResponseEntity.ok().body(getProdottoById(idProdotto).getCodiceABarre());
    }

    @Transactional
    public ResponseEntity<HttpStatus> aggiungiCodice(Long idProdotto, String codice) {
        Prodotto prodotto = getProdottoById(idProdotto);
        prodotto.setCodiceABarre(codice);
        prodottoRepository.save(prodotto);
        return ResponseEntity.ok().build();
    }

    @Transactional
    private Prodotto getProdottoById(Long idProdotto) {
        Optional<Prodotto> prodottoOptional = prodottoRepository.findById(idProdotto);
        if (prodottoOptional.isPresent()) {
            return prodottoOptional.get();
        } else {
            throw new NotFoundException(402, "Prodotto con id " + idProdotto + " non trovato");
        }
    }

}
