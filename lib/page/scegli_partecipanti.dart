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
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 12 / MediaQuery.of(context).textScaleFactor),
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
              Get.back(result: lista.partecipanti);
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
            if (snapshot.data.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.sentiment_very_dissatisfied,
                        size: 100,
                        color: Colors.grey,
                      ),
                      Text(
                        "Non c'è niente qui",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text("Non hai ancora nessun collaboratore",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: 200,
                        child: GestureDetector(
                          onTap: () async {
                            var partecipanti = await showSearch(
                                context: context,
                                delegate: DataSearch(idLista: lista.id));
                            if (partecipanti != null) {
                              this.setState(() {
                                lista.partecipanti = partecipanti;
                              });
                            }
                            Get.back(result: lista.partecipanti);
                          },
                          child: new Container(
                              alignment: Alignment.center,
                              height: 60.0,
                              decoration: new BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: new BorderRadius.circular(9.0)),
                              child: new Text("Aggiungine Uno",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white))),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
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
                  title: Text(
                    snapshot.data[index].nome +
                        " " +
                        snapshot.data[index].cognome,
                    style: TextStyle(
                        fontSize: 14 / MediaQuery.of(context).textScaleFactor),
                  ),
                  subtitle: Text(snapshot.data[index].email,
                      style: TextStyle(
                          fontSize:
                              12 / MediaQuery.of(context).textScaleFactor)),
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
                        title: Text(u.nome + " " + u.cognome,
                            style: TextStyle(
                                fontSize: 14 /
                                    MediaQuery.of(context).textScaleFactor)),
                        subtitle: Text(u.email,
                            style: TextStyle(
                                fontSize: 12 /
                                    MediaQuery.of(context).textScaleFactor)),
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
