package it.magnobevoeprogrammo.service;

import it.magnobevoeprogrammo.exception.NotFoundException;
import it.magnobevoeprogrammo.model.User;
import it.magnobevoeprogrammo.repository.UserRepository;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public String getUserId() {
        return MDC.get("username");
    }

    public User getUser() {
        Optional<User> userOptional = userRepository.findById(this.getUserId());
        if(userOptional.isPresent())
            return userOptional.get();
        else
            throw new NotFoundException(402, "User not found");
    }
}
