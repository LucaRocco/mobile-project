import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/page/profilo.dart';

class PartecipantsDetails extends StatefulWidget {
  PartecipantsDetails({this.title, this.users});

  final List<User> users;
  final String title;

  @override
  State<StatefulWidget> createState() =>
      _PartecipantsDetailsState(users: this.users);
}

class _PartecipantsDetailsState extends State<PartecipantsDetails> {
  _PartecipantsDetailsState({this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    print(users);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.deepOrange),
      ),
      body: ListView(
        children: users
            .map(
              (user) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.image),
                ),
                title: Text(user.nome + " " + user.cognome),
                subtitle: Text(user.email),
                onTap: () {
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
