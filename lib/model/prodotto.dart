
import 'package:in_expense/model/user.dart';

class Prodotto {
  Prodotto(
      {this.id,
      this.nome,
      this.categoria,
      this.image,
      this.descrizione,
      this.dataAcquisto,
      this.quantita,
      this.utenteAcquisto,
      this.originalId});

  int id;
  int originalId;
  String nome;
  String categoria;
  String image;
  String descrizione;
  String dataAcquisto;
  int quantita = 0;
  User utenteAcquisto;

  factory Prodotto.fromJson(json) {
    return Prodotto(
        id: json['id'],
        nome: json['nome'],
        categoria: json['categoria'],
        image: json['foto'],
        dataAcquisto: json['dataAcquisto'],
        quantita: json['quantita'],
        utenteAcquisto: json['utenteAcquisto'] != null
            ? User.fromJson(json['utenteAcquisto'])
            : null,
        originalId: json['originalId']);
  }

  Map toJson() => {
        "id": id,
        "nome": nome,
        "categoria": categoria,
        "foto": image,
        "dataAcquisto": dataAcquisto.toString(),
        "quantita": quantita
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Prodotto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          dataAcquisto == other.dataAcquisto;

  @override
  int get hashCode => id.hashCode;

  Prodotto clone() {
    return Prodotto(
        id: this.id,
        nome: this.nome,
        categoria: this.categoria,
        image: this.image,
        descrizione: this.descrizione,
        dataAcquisto: this.dataAcquisto,
        quantita: this.quantita,
        utenteAcquisto: this.utenteAcquisto,
        originalId: this.originalId);
  }

  @override
  String toString() {
    return 'Prodotto{id: $id, nome: $nome, dataAcquisto: $dataAcquisto, quantita: $quantita}';
  }
}
