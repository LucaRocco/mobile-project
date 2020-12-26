package it.magnobevoeprogrammo.repository;

import it.magnobevoeprogrammo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    User findUserByEmail(String email);
    @Query(value = "SELECT a.amico_id as user_id, nome, cognome, email, foto FROM amici a JOIN utenti u ON a.amico_id = u.user_id WHERE a.user_id =:userId", nativeQuery = true)
    List<User> getFriends(long userId);
    List<User> findAllByEmailIn(List<String> email);
}
