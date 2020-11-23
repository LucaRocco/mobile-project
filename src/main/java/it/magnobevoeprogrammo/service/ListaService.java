package it.magnobevoeprogrammo.service;

import it.magnobevoeprogrammo.exception.NotFoundException;
import it.magnobevoeprogrammo.model.Lista;
import it.magnobevoeprogrammo.model.Prodotto;
import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.model.request.SaveProdottoRequest;
import it.magnobevoeprogrammo.repository.ListaRepository;
import it.magnobevoeprogrammo.repository.ProdottoRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import javax.transaction.Transactional;
import java.util.*;

@Service
public class ListaService {
    private final Logger log = LoggerFactory.getLogger(ListaService.class);

    @Autowired
    private ListaRepository listaRepository;

    @Autowired
    private ProdottoRepository prodottoRepository;

    @Autowired
    private UserService userService;

    public ResponseEntity<Lista> getListaById(Long idLista) {
        log.debug("getListaById started");
        Optional<Lista> listaOptional = listaRepository.findById(idLista);
        if (listaOptional.isPresent()) {
            return ResponseEntity.ok().body(listaOptional.get());
        } else {
            throw new NotFoundException(402, "Lista non trovata");
        }
    }

    @Transactional
    public ResponseEntity<List<Lista>> getAllLists() {
        log.debug("getAllLists() started");
        User user = userService.getUser();
        List<Lista> ll = listaRepository.getAllByUserInUserList(user.getId());
        ll.forEach(lista -> lista.setProdotti(prodottoRepository.findAllByIdLista(lista.getId())));
        return ResponseEntity.ok().body(ll);
    }

    public ResponseEntity<Lista> addList(Lista lista) {
        log.debug("addList() started");
        User user = userService.getUser();
        lista.setUsers(Collections.singletonList(user));
        lista.setDataCreazione(new Date());
        return ResponseEntity.ok().body(listaRepository.save(lista));
    }

    public ResponseEntity<HttpStatus> saveProductToList(SaveProdottoRequest request) {
        Lista lista = listaRepository.findById((long) request.getIdListaDestinazione()).get();
        User user = userService.getUser();
        Optional<Prodotto> prodottoFromDB = prodottoRepository.findById(request.getId());
        prodottoFromDB.ifPresent(prodotto -> {
            prodotto.getListe().add(lista);
            prodotto.setUser(user);
            prodottoRepository.save(prodotto);
        });
        if (!prodottoFromDB.isPresent()) {
            Prodotto p = new Prodotto();
            p.setNome(request.getNome());
            p.setCategoria(request.getCategoria());
            p.setListe(Collections.singletonList(lista));
            p.setUser(user);
            prodottoRepository.save(p);
        }
        return ResponseEntity.ok().build();
    }
}
