package it.magnobevoeprogrammo.controller;

import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.persistence.SqlResultSetMapping;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserRepository userRepository;

    @PostMapping(path = {"/", ""})
    public ResponseEntity<Long> addUsers(@RequestBody User user) {
        return ResponseEntity.ok().body(userRepository.save(user).getId());
    }

    @GetMapping(path = {"/", ""})
    public ResponseEntity<User> getUser(
            @RequestParam("id") Long id) throws Exception {
        Optional<User> userFromDB = userRepository.findById(id);
        if (userFromDB.isPresent()) {
            return ResponseEntity.ok(userFromDB.get());
        } else {
            throw new Exception();
        }
    }

    @PutMapping(path = {"/", ""})
    public ResponseEntity<User> modificaProfilo(
            @RequestBody User user) throws Exception{
        Optional<User> userOtional = userRepository.findById(user.getId());
        if(userOtional.isPresent()) {
            User userFromDB = userOtional.get();
            userFromDB.setNome(user.getNome());
            userFromDB.setCognome(user.getCognome());
            userFromDB.setEmail(user.getEmail());

            return ResponseEntity.ok(userFromDB);
        } else {
            throw new Exception();
        }
    }

}

