import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/service/account_service.dart';
import 'package:in_expense/service/lists_service.dart';

class AddParticipantPage extends StatefulWidget {
  AddParticipantPage({this.lista});

  final ListaSpesa lista;

  @override
  _AddParticipantPageState createState() =>
      _AddParticipantPageState(lista: lista);
}

class _AddParticipantPageState extends State<AddParticipantPage> {
  _AddParticipantPageState({this.lista});

  final ListaSpesa lista;

  List<User> partecipantiDaAggiungere = List<User>();
  AccountService accountService = GetIt.I<AccountService>();
  ListsService listsService = GetIt.I<ListsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          partecipantiDaAggiungere.isNotEmpty
              ? TextButton(
                  onPressed: () async {
                    buildShowDialog(context);
                    var participants = await listsService.addParticipantsToList(
                        partecipantiDaAggiungere.map((e) => e.email).toList(),
                        lista.id);
                    Get.close(1);
                    Get.back(result: participants);
                  },
                  child: Text(
                    AppLocalizations.of(context).translate("salva"),
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                )
              : Text(""),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              var partecipanti = await showSearch(
                  context: context, delegate: DataSearch(idLista: lista.id));
              if (partecipanti != null) {
                this.setState(() {
                  lista.partecipanti = partecipanti;
                });
              }
            },
          )
        ],
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.deepOrange),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: lista.partecipanti);
          },
        ),
      ),
      body: FutureBuilder(
        future: accountService.getFriends(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            snapshot.data
                .removeWhere((element) => lista.partecipanti.contains(element));
            print(snapshot.data);
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data[index].image),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      partecipantiDaAggiungere.contains(snapshot.data[index])
                          ? Icons.person_remove_alt_1_outlined
                          : Icons.person_add_alt,
                      color: partecipantiDaAggiungere
                              .contains(snapshot.data[index])
                          ? Colors.deepOrange
                          : Colors.green,
                    ),
                    onPressed: () {
                      this.setState(
                        () {
                          if (!partecipantiDaAggiungere
                              .contains(snapshot.data[index])) {
                            partecipantiDaAggiungere.add(snapshot.data[index]);
                          } else {
                            partecipantiDaAggiungere
                                .remove(snapshot.data[index]);
                          }
                        },
                      );
                    },
                  ),
                  title: Text(snapshot.data[index].nome +
                      " " +
                      snapshot.data[index].cognome),
                  subtitle: Text(snapshot.data[index].email),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class DataSearch extends SearchDelegate<List<User>> {
  DataSearch({this.idLista});

  final int idLista;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    AccountService accountService = GetIt.I<AccountService>();
    ListsService listsService = GetIt.I<ListsService>();
    return FutureBuilder(
        future: accountService.searchUserByNameAndEmailLike(query, idLista),
        builder: (context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data
                  .map((u) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(u.image),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.group_add_outlined,
                            color: Colors.green,
                          ),
                          onPressed: () async {
                            buildShowDialog(context);
                            var participants =
                                await listsService.addParticipantsToList(
                                    List.of([u.email]), idLista);
                            close(context, participants);
                          },
                        ),
                        title: Text(u.nome + " " + u.cognome),
                        subtitle: Text(u.email),
                      ))
                  .toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView();
  }
}

buildShowDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
