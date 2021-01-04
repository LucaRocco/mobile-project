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
            onPressed: () async {},
          )
        ],
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.deepOrange),
      ),
      body: FutureBuilder(
        future: accountService.getFriends(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
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
      ),
    );
  }
}
