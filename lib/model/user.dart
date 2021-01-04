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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && email == other.email;

  @override
  int get hashCode => email.hashCode;

  User clone() {
    return User(
      nome: this.nome,
      cognome: this.cognome,
      email: this.email,
      image: this.image
    );
  }
}
