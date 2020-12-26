package it.magnobevoeprogrammo.service;

import it.magnobevoeprogrammo.exception.NotFoundException;
import it.magnobevoeprogrammo.model.Lista;
import it.magnobevoeprogrammo.model.Prodotto;
import it.magnobevoeprogrammo.model.ProdottoLista;
import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.model.request.SaveProdottoRequest;
import it.magnobevoeprogrammo.model.response.ListaResponse;
import it.magnobevoeprogrammo.model.response.ProdottoListaResponse;
import it.magnobevoeprogrammo.repository.ListaRepository;
import it.magnobevoeprogrammo.repository.ProdottoListaRepository;
import it.magnobevoeprogrammo.repository.ProdottoRepository;
import it.magnobevoeprogrammo.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.*;

import static java.util.stream.Collectors.toList;

@Service
public class ListaService {
    private final Logger log = LoggerFactory.getLogger(ListaService.class);

    @Autowired
    private ListaRepository listaRepository;

    @Autowired
    private ProdottoRepository prodottoRepository;

    @Autowired
    private ProdottoListaRepository prodottoListaRepository;

    @Autowired
    private UserRepository userRepository;

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
    public ResponseEntity<List<ListaResponse>> getAllLists() {
        log.debug("getAllLists() started");
        User user = userService.getUser();
        List<ListaResponse> ll = user.getListe().stream().map(Lista::toResponse).collect(toList());
        return ResponseEntity.ok().body(ll);
    }

    @Transactional
    public ResponseEntity<Lista> addList(Lista lista) {
        log.debug("addList() started");
        User user = userService.getUser();
        lista.setUsers(Collections.singletonList(user));
        lista.setCreatorId(user.getUserId());
        lista.setDataCreazione(new Date());
        user.getListe().add(lista);
        user = userRepository.save(user);
        return ResponseEntity.ok().body(user.getListe().get(user.getListe().size() - 1));
    }

    @Transactional
    public ResponseEntity<HttpStatus> saveProductToList(SaveProdottoRequest request) {
        Lista lista = listaRepository.findListaById((long) request.getIdListaDestinazione());
        Prodotto prodotto = prodottoRepository.findProdottoById(request.getId());
        prodottoListaRepository.save(ProdottoLista.fromProdotto(prodotto, lista));
        return ResponseEntity.ok().build();
    }

    @Transactional
    public ResponseEntity<HttpStatus> saveProductsToList(List<SaveProdottoRequest> request) {
        Lista lista = listaRepository.findListaById(request.get(0).getIdListaDestinazione());
        List<ProdottoLista> prodotti = new ArrayList<>();
        request.forEach(req -> {
            Prodotto prodotto = prodottoRepository.findProdottoById(req.getId());
            prodotti.add(ProdottoLista.fromProdotto(prodotto, lista));
        });
        prodottoListaRepository.saveAll(prodotti);
        return ResponseEntity.ok().build();
    }

    public ResponseEntity<List<ProdottoListaResponse>> deleteProductFromList(long productId, long listaId) {
        Optional<Lista> optionalLista = listaRepository.findById(listaId);
        if (!optionalLista.isPresent()) {
            throw new NotFoundException(402, "Lista non trovata");
        }
        Lista lista = optionalLista.get();
        prodottoListaRepository.deleteById(productId);
        lista.getProdotti().removeIf(prodottoLista -> prodottoLista.getId().equals(productId));
        return ResponseEntity.ok().body(lista.getProdotti().stream().map(ProdottoLista::toResponse).collect(toList()));
    }

    public ResponseEntity<Set<User>> addParticipant(List<String> emails, long idLista) {
        List<User> users = userRepository.findAllByEmailIn(emails);
        Lista lista = listaRepository.findListaById(idLista);
        users.forEach(user -> user.getListe().add(lista));
        userRepository.saveAll(users);
        lista.getUsers().addAll(users);
        return ResponseEntity.ok(new HashSet<>(lista.getUsers()));
    }
}
