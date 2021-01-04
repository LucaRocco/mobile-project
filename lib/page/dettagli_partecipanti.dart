import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/service/lists_service.dart';

class ParticipantsDetails extends StatefulWidget {
  ParticipantsDetails({this.title, this.users, this.lista, this.email});

  final List<User> users;
  final String title;
  final ListaSpesa lista;
  final String email;

  @override
  State<StatefulWidget> createState() =>
      _ParticipantsDetailsState(users: this.users, lista: lista, email: email);
}

class _ParticipantsDetailsState extends State<ParticipantsDetails> {
  _ParticipantsDetailsState({this.users, this.lista, this.email});

  List<User> users;
  final ListaSpesa lista;
  final ListsService listsService = GetIt.I<ListsService>();
  final String email;
  String emailToRemove = "";
  bool isRemoveLoading = false;

  @override
  Widget build(BuildContext context) {
    users.sort((a, b) => a.nome.compareTo(b.nome));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.deepOrange),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: lista.partecipanti);
          },
        ),
      ),
      body: ListView(
        children: users
            .map(
              (user) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.image),
                ),
                title: user.email != email
                    ? Text(user.nome + " " + user.cognome)
                    : Text(AppLocalizations.of(context)
                    .translate("tu")),
                subtitle: Text(user.email),
                trailing: lista.creatorId == lista.userId
                    ? user.email != email
                        ? IconButton(
                            icon:
                                (emailToRemove == user.email && isRemoveLoading)
                                    ? SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator())
                                    : Icon(Icons.delete),
                            onPressed: () async {
                              setState(() {
                                emailToRemove = user.email;
                                isRemoveLoading = true;
                              });
                              var partecipanti =
                                  await listsService.removeParticipantFromList(
                                      user.email, lista.id);
                              lista.partecipanti = partecipanti;
                              setState(() {
                                this.users = partecipanti;
                                emailToRemove = "";
                                isRemoveLoading = false;
                              });
                            },
                          )
                        : Text("")
                    : Text(""),
                onTap: () {},
              ),
            )
            .toList(),
      ),
    );
  }
}
