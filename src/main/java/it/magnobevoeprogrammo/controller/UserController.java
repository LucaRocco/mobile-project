package it.magnobevoeprogrammo.controller;

import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.repository.UserRepository;
import it.magnobevoeprogrammo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @PostMapping(path = {"/create", ""})
    public ResponseEntity<String> addUsers(@RequestBody User user) {
        return ResponseEntity.ok().body(userRepository.save(user).getEmail());
    }

    @GetMapping(path = {"/", ""})
    public ResponseEntity<User> getUser() {
        return ResponseEntity.ok(userService.getUser());
    }

    @PutMapping(path = {"/", ""})
    public ResponseEntity<User> modificaProfilo(@RequestBody User updatedUser) {
        User user = userService.getUser();
        user.setNome(updatedUser.getNome());
        user.setCognome(updatedUser.getCognome());
        user.setEmail(updatedUser.getEmail());
        user.setFoto(updatedUser.getFoto());
        return ResponseEntity.ok().body(userRepository.save(user));
    }

}

