package it.magnobevoeprogrammo.repository;

import it.magnobevoeprogrammo.model.Lista;
import it.magnobevoeprogrammo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ListaRepository extends JpaRepository<Lista, Long> {
    @Query(value = "select * from lista join lista_users lu on lista.id = lu.lista_id and users_id =:userId join prodotto_liste pl on lista.id = pl.liste_id", nativeQuery = true)
    List<Lista> getAllByUserInUserList(Long userId);
}
