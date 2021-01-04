class ProductRequest {
  int id;
  String nome;
  String categoria;
  int idListaDestinazione;
  int quantita;

  ProductRequest(
      {this.id, this.nome, this.categoria, this.idListaDestinazione, this.quantita});

  Map toJson() => {
        "id": id,
        "nome": nome,
        "categoria": categoria,
        "idListaDestinazione": idListaDestinazione,
        "quantita": quantita
      };
}
