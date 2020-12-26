class Prodotto {
  Prodotto({this.id, this.nome, this.categoria, this.image, this.descrizione});

  int id;
  String nome;
  String categoria;
  String image;
  String descrizione;

  factory Prodotto.fromJson(json) {
    return Prodotto(
        id: json['id'],
        nome: json['nome'],
        categoria: json['categoria'],
        image: json['foto']);
  }

  Map toJson() =>
      {"id": id, "nome": nome, "categoria": categoria, "foto": image};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Prodotto && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
