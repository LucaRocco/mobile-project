package it.magnobevoeprogrammo.repository;

import it.magnobevoeprogrammo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserRepository extends JpaRepository<User, Long> {
}
