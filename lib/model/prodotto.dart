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
      image: json['foto']
    );
  }
}