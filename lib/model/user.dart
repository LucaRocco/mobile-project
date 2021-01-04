class User {
  User({this.userId, this.nome, this.cognome, this.email, this.image});

  int userId;
  String nome;
  String cognome;
  String email;
  String image;

  factory User.fromJson(json) {
    return User(
        userId: json['userId'],
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
        userId: this.userId,
        nome: this.nome,
        cognome: this.cognome,
        email: this.email,
        image: this.image);
  }
}
