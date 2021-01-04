package it.magnobevoeprogrammo.service;

import it.magnobevoeprogrammo.exception.NotFoundException;
import it.magnobevoeprogrammo.model.*;
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

    public ResponseEntity<ListaResponse> getListaById(Long idLista) {
        log.debug("getListaById started");
        User user = userService.getUser();
        Lista lista = listaRepository.findListaById(idLista);
        return ResponseEntity.ok().body(lista.toResponse(user.getUserId()));
    }

    @Transactional
    public ResponseEntity<List<ListaResponse>> getAllLists() {
        log.debug("getAllLists() started");
        User user = userService.getUser();
        List<ListaResponse> ll = user.getListe().stream().map(l -> l.toResponse(user.getUserId())).collect(toList());
        ll.forEach(l -> l.getProdotti().forEach(p -> System.out.println(p.getDataAcquisto())));
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
        Lista lista = listaRepository.findListaById(request.getIdListaDestinazione());
        Prodotto prodotto = prodottoRepository.findProdottoById(request.getId());
        prodottoListaRepository.save(ProdottoLista.fromProdotto(prodotto, lista, request.getQuantita()));
        return ResponseEntity.ok().build();
    }

    public ResponseEntity<List<ProdottoListaResponse>> saveProductsToList(List<SaveProdottoRequest> request) {
        Lista lista = listaRepository.findListaById(request.get(0).getIdListaDestinazione());
        List<ProdottoLista> prodotti = new ArrayList<>();
        request.forEach(req -> {
            Prodotto prodotto = prodottoRepository.findProdottoById(req.getId());
            prodotti.add(ProdottoLista.fromProdotto(prodotto, lista, req.getQuantita()));
        });

        List<ProdottoLista> prodottiSalvati = prodottoListaRepository.saveAll(prodotti);
        List<ProdottoListaResponse> response = lista.getProdotti().stream().map(ProdottoLista::toResponse).collect(toList());
        response.addAll(prodottiSalvati.stream().map(ProdottoLista::toResponse).collect(toList()));

        return ResponseEntity.ok(response);
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

    public ResponseEntity<Set<User>> removeParticipant(String email, long idLista) {
        User user = userRepository.findUserByEmail(email);
        user.getListe().removeIf(l -> l.getId() == idLista);
        userRepository.save(user);
        Lista lista = listaRepository.findListaById(idLista);
        return ResponseEntity.ok(new HashSet<>(lista.getUsers()));
    }

    public ResponseEntity<Set<ProdottoListaResponse>> changeProductStatus(long idProdotto, long idLista) {
        ProdottoLista prodottoLista = prodottoListaRepository.findProdottoListaById(idProdotto);
        User user = userRepository.findUserByEmail(userService.getUserEmail());

        if (prodottoLista.getStatus() == StatusProdotto.DA_ACQUISTARE) {
            prodottoLista.setDataAquisto(new Date());
            prodottoLista.setUtenteAcquisto(user);
            prodottoLista.setStatus(StatusProdotto.ACQUISTATO);
        } else if(prodottoLista.getStatus() == StatusProdotto.ACQUISTATO) {
            prodottoLista.setDataAquisto(null);
            prodottoLista.setUtenteAcquisto(null);
            prodottoLista.setStatus(StatusProdotto.DA_ACQUISTARE);
        }

        prodottoListaRepository.save(prodottoLista);
        Lista lista = listaRepository.findListaById(idLista);
        return ResponseEntity.ok(new HashSet<>(lista.getProdotti().stream().map(ProdottoLista::toResponse).collect(toList())));
    }
}
