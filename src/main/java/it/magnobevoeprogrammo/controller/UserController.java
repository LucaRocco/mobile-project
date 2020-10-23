package it.magnobevoeprogrammo.controller;

import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.repository.UserRepository;
import it.magnobevoeprogrammo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Optional;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @PostMapping(path = {"/", ""})
    public ResponseEntity<String> addUsers(@RequestBody User user) {
        user.setId(userService.getUserId());
        return ResponseEntity.ok().body(userRepository.save(user).getId());
    }

    @GetMapping(path = {"/", ""})
    public ResponseEntity<User> getUser() {
        return ResponseEntity.ok(userService.getUser());
    }

    @PutMapping(path = {"/", ""})
    public ResponseEntity<User> modificaProfilo(
            @RequestBody User updatedUser) throws Exception{
        User user = userService.getUser();
        user.setNome(user.getNome());
        user.setCognome(user.getCognome());
        user.setEmail(user.getEmail());
        return ResponseEntity.ok().body(userRepository.save(user));
    }

}

