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
      this.prodotti,
      this.creatorId,
      this.userId});

  int id;
  String nome;
  String descrizione;
  int numeroPartecipanti;
  int numeroProdotti;
  List<User> partecipanti;
  List<Prodotto> prodotti;
  int coloreChiaro;
  int coloreScuro;
  int creatorId;
  int userId;

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
        creatorId: json['creatorId'],
        userId: json['userId']);
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

  ListaSpesa clone() {
    return ListaSpesa(
        id: this.id,
        nome: this.nome,
        descrizione: this.descrizione,
        numeroPartecipanti: this.numeroPartecipanti,
        numeroProdotti: this.numeroProdotti,
        partecipanti: this.partecipanti.map((u) => u.clone()).toList(),
        prodotti: this.prodotti.map((p) => p.clone()).toList(),
        creatorId: this.creatorId,
        userId: this.userId);
  }
}
