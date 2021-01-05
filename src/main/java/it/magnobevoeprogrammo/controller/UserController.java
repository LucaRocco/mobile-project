package it.magnobevoeprogrammo.controller;

import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.repository.UserRepository;
import it.magnobevoeprogrammo.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/user")
public class UserController {
    private final Logger log = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @PostMapping(path = {"/create", ""})
    public ResponseEntity<String> addUsers(@RequestBody User user) {
        log.debug("addUser() started");
        return userService.createUser(user);
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

    @GetMapping("/friends")
    public ResponseEntity<List<User>> getFriends() {
        List<User> friends = userService.getFriends();
        log.debug("" + friends);
        return ResponseEntity.ok().body(friends);
    }

    @PostMapping("/friends/{friendId}")
    public ResponseEntity<HttpStatus> addFrieds(@PathVariable("friendId") long friendId) {
        return userService.addFriend(friendId);
    }

    @GetMapping("/search")
    public ResponseEntity<Set<User>> userSearchByNameAndEmail(@RequestParam("query") String query, @RequestParam("idLista") long idLista) {
        return userService.userSearchByNameAndFilterByListParticipants(query, idLista);
    }

    @GetMapping("/search/collaborators")
    public ResponseEntity<Set<User>> userSearchByNameAndFilterByUserFriends(@RequestParam("query") String query) {
        return userService.userSearchByNameAndFilterByUserFriends(query);
    }
}

