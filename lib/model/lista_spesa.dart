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
        numeroProdotti:
            json['numeroProdotti'] == null ? 0 : json['numeroProdotti'] == null,
        numeroPartecipanti: json['numeroPartecipanti'] == null
            ? 0
            : json['numeroPartecipanti']);
  }
}
