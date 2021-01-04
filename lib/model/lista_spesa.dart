import 'package:in_expense/model/prodotto.dart';
import 'package:in_expense/model/user.dart';

class ListaSpesa {
  ListaSpesa(
      {this.id,
      this.nome,
      this.descrizione,
      this.numeroPartecipanti,
      this.numeroProdotti,
      this.partecipanti,
      this.prodotti});

  int id;
  String nome;
  String descrizione;
  int numeroPartecipanti;
  int numeroProdotti;
  List<User> partecipanti;
  List<Prodotto> prodotti;
  int coloreChiaro;
  int coloreScuro;

  factory ListaSpesa.fromJson(Map<String, dynamic> json) {
    return ListaSpesa(
      id: json['id'],
      nome: json['nome'],
      descrizione: json['descrizione'],
      partecipanti:
          (json['users'] as List).map((user) => User.fromJson(user)).toList(),
      prodotti: (json['prodotti'] as List)
          .map((prodotto) => Prodotto.fromJson(prodotto))
          .toList(),
      numeroProdotti: (json['prodotti'] as List).length,
      numeroPartecipanti: (json['users'] as List).length,
    );
  }

  @override
  String toString() {
    return 'ListaSpesa{id: $id, nome: $nome, descrizione: $descrizione, numeroPartecipanti: $numeroPartecipanti, numeroProdotti: $numeroProdotti, partecipanti: $partecipanti, prodotti: $prodotti, coloreChiaro: $coloreChiaro, coloreScuro: $coloreScuro}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListaSpesa &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          partecipanti == other.partecipanti &&
          prodotti == other.prodotti;

  @override
  int get hashCode => id.hashCode ^ partecipanti.hashCode ^ prodotti.hashCode;

  factory ListaSpesa.clone(ListaSpesa l) {
    return ListaSpesa(
      id: l.id,
      nome: l.nome,
      descrizione: l.descrizione,
      numeroPartecipanti: l.numeroPartecipanti,
      numeroProdotti: l.numeroProdotti,
      partecipanti: l.partecipanti.map((u) => u.clone()).toList(),
      prodotti: l.prodotti.map((p) => p.clone()).toList()
    );
  }
}
