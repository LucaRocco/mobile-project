package it.magnobevoeprogrammo.repository;

import it.magnobevoeprogrammo.model.Prodotto;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProdottoRepository extends JpaRepository<Prodotto, Long> {
}
