package it.magnobevoeprogrammo.repository;

import it.magnobevoeprogrammo.model.Lista;
import it.magnobevoeprogrammo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ListaRepository extends JpaRepository<Lista, Long> {
    List<Lista> getAllByUsersContaining(User users);
    Lista findListaById(long id);
    @Query(value = "DELETE FROM utenti_lista WHERE user_id =:idUser AND lista_id =:idLista", nativeQuery = true)
    void removeParticipant(long idUser, long idLista);
}
