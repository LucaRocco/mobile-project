package it.magnobevoeprogrammo.repository;

import it.magnobevoeprogrammo.model.Prodotto;
import it.magnobevoeprogrammo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ProdottoRepository extends JpaRepository<Prodotto, Long> {
    List<Prodotto> findAllByUser(User user);
    @Query(value = "select * from prodotto p join prodotto_liste pl on p.id = pl.prodotto_id where pl.liste_id =:idLista", nativeQuery = true)
    List<Prodotto> findAllByIdLista(Long idLista);
}
