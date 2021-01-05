package it.magnobevoeprogrammo.repository;

import it.magnobevoeprogrammo.model.Amici;
import it.magnobevoeprogrammo.model.PK;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AmiciRepository extends JpaRepository<Amici, PK> {
}
