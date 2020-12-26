package it.magnobevoeprogrammo.service;

import it.magnobevoeprogrammo.exception.NotFoundException;
import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    private final Logger log = LoggerFactory.getLogger(UserService.class);

    @Autowired
    private UserRepository userRepository;

    @Transactional
    public ResponseEntity<String> createUser(User user) {
        return ResponseEntity.ok().body(userRepository.save(user).getEmail());
    }

    public String getUserEmail() {
        return MDC.get("email");
    }

    public User getUser() {
        log.debug("getUser() started for email: " + MDC.get("email"));
        User user = userRepository.findUserByEmail(this.getUserEmail());
        if(user != null) {
            log.debug("UserID: " + user.getUserId());
            return user;
        } else
            throw new NotFoundException(402, "User not found");
    }

    public List<User> getFriends() {
        return userRepository.getFriends(getUser().getUserId());
    }
}
