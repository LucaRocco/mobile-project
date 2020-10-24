package it.magnobevoeprogrammo.service;

import it.magnobevoeprogrammo.exception.NotFoundException;
import it.magnobevoeprogrammo.model.Lista;
import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.repository.ListaRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.*;

@Service
public class ListaService {
    private Logger log = LoggerFactory.getLogger(ListaService.class);

    @Autowired
    private ListaRepository listaRepository;

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
        return ResponseEntity.ok().body(listaRepository.getAllByUserInUserList(user.getId()));
    }

    public ResponseEntity<Lista> addList(Lista lista) {
        log.debug("addList() started");
        User user = userService.getUser();
        lista.setUsers(Collections.singletonList(user));
        lista.setDataCreazione(new Date());
        return ResponseEntity.ok().body(listaRepository.save(lista));
    }
}
