package it.magnobevoeprogrammo.service;

import it.magnobevoeprogrammo.exception.NotFoundException;
import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {
    private final Logger log = LoggerFactory.getLogger(UserService.class);

    @Autowired
    private UserRepository userRepository;

    public String getUserEmail() {
        return MDC.get("email");
    }

    public User getUser() {
        log.debug("getUser() started for email: " + MDC.get("email"));
        Optional<User> userOptional = userRepository.findUserByEmail(this.getUserEmail());
        if(userOptional.isPresent())
            return userOptional.get();
        else
            throw new NotFoundException(402, "User not found");
    }
}
