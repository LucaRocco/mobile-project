class ProductRequest {
  int id;
  String nome;
  String categoria;
  int idListaDestinazione;

  ProductRequest({this.id, this.nome, this.categoria, this.idListaDestinazione});

  Map toJson() => {
    "id": id,
    "nome": nome,
    "categoria": categoria,
    "idListaDestinazione": idListaDestinazione
  };
}