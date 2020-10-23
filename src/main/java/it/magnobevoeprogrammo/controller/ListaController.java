package it.magnobevoeprogrammo.controller;

import it.magnobevoeprogrammo.exception.NotFoundException;
import it.magnobevoeprogrammo.model.Lista;
import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.repository.ListaRepository;
import it.magnobevoeprogrammo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.transaction.Transactional;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/lista")
public class ListaController {

    @Autowired
    private ListaRepository listaRepository;

    @Autowired
    private UserService userService;

    @Transactional
    @GetMapping(path = "/{idLista}")
    public ResponseEntity<Lista> getListaById(@PathVariable("idLista") Long idLista) {
        Optional<Lista> listaOptional = listaRepository.findById(idLista);
        if(listaOptional.isPresent()) {
            return ResponseEntity.ok().body(listaOptional.get());
        } else {
            throw new NotFoundException(402, "Lista non trovata");
        }
    }

    @Transactional
    @GetMapping(path = {"", "/"})
    public ResponseEntity<List<Lista>> getAllLists() {
        User user = userService.getUser();
        return ResponseEntity.ok().body(user.getListe());
    }
}
