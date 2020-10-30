package it.magnobevoeprogrammo.repository;

import it.magnobevoeprogrammo.model.Prodotto;
import it.magnobevoeprogrammo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProdottoRepository extends JpaRepository<Prodotto, Long> {
    List<Prodotto> findAllByUser(User user);
}
