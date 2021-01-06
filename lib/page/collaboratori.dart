import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/service/account_service.dart';
import 'package:in_expense/service/lists_service.dart';

class CollaboratorPage extends StatefulWidget {
  @override
  _CollaboratorPageState createState() => _CollaboratorPageState();
}

class _CollaboratorPageState extends State<CollaboratorPage> {
  _CollaboratorPageState();

  List<User> partecipantiDaAggiungere = List<User>();
  AccountService accountService = GetIt.I<AccountService>();
  ListsService listsService = GetIt.I<ListsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                await showSearch(
                    context: context, delegate: DataSearchCollaboratori());
                this.setState(() {});
              },
            )
          ],
          backgroundColor: Colors.transparent,
          actionsIconTheme: IconThemeData(color: Colors.deepOrange),
        ),
        body: FutureBuilder(
          future: accountService.getFriends(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
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
                              await showSearch(
                                  context: context,
                                  delegate: DataSearchCollaboratori());
                              this.setState(() {});
                            },
                            child: new Container(
                                alignment: Alignment.center,
                                height: 60.0,
                                decoration: new BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius:
                                        new BorderRadius.circular(9.0)),
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
                        Icons.remove,
                        color: Colors.deepOrange,
                      ),
                      onPressed: () {
                        this.setState(
                          () {
                            //TODO: Eliminare amico
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
        ));
  }
}

class DataSearchCollaboratori extends SearchDelegate<List<User>> {
  DataSearchCollaboratori();

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
    return FutureBuilder(
        future: accountService.searchUserByNameAndFilterByFriends(query),
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
                            await accountService.addFriend(u.userId);
                            close(context, null);
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
