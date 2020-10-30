class Prodotto {
  Prodotto({this.id, this.nome, this.categoria});
  int id;
  String nome;
  String categoria;

  factory Prodotto.fromJson(json) {
    return Prodotto(
      id: json['id'],
      nome: json['nome'],
      categoria: json['categoria']
    );
  }
}