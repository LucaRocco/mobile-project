class User {
  User({this.nome, this.cognome, this.email, this.image});

  String nome;
  String cognome;
  String email;
  String image;

  factory User.fromJson(json) {
    return User(
        nome: json['nome'],
        cognome: json['cognome'],
        email: json['email'],
        image: json['foto']);
  }

  @override
  String toString() {
    return 'User{nome: $nome, cognome: $cognome, email: $email, image: $image}';
  }
}
