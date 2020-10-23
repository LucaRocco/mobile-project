package it.magnobevoeprogrammo.repository;

import it.magnobevoeprogrammo.model.Lista;
import it.magnobevoeprogrammo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ListaRepository extends JpaRepository<Lista, Long> {
}
