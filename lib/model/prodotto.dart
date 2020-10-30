class Prodotto {
  Prodotto({this.id, this.nome, this.categoria});
  int id;
  String nome;
  String categoria;

  Prodotto.fromJson(json) {
    Prodotto(
      id: json['id'],
      nome: json['nome'],
      categoria: json['categoria']
    );
  }
}