import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/page/dettagli_lista.dart';
import 'package:in_expense/page/liste_attive.dart';
import 'package:in_expense/service/account_service.dart';
import 'package:in_expense/service/lists_service.dart';

class AddParticipantPage extends StatefulWidget {
  AddParticipantPage({this.participantsAlreadyPresent, this.lista});

  final List<User> participantsAlreadyPresent;
  final ListaSpesa lista;

  @override
  _AddParticipantPageState createState() => _AddParticipantPageState(
      participantsAlreadyPresent: participantsAlreadyPresent, lista: lista);
}

class _AddParticipantPageState extends State<AddParticipantPage> {
  _AddParticipantPageState({this.participantsAlreadyPresent, this.lista});

  final List<User> participantsAlreadyPresent;
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
                    var participants = await listsService.addParticipantsToList(
                        partecipantiDaAggiungere.map((e) => e.email).toList(), lista.id);
                    lista.partecipanti = participants;
                    print(participants);
                    Get.close(5);
                    Get.to(ListsPage());
                    Get.to(ListDetailPage(listaSpesa: lista,));
                  },
                  child: Text(
                    AppLocalizations.of(context).translate("salva"),
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                )
              : Text("")
        ],
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.deepOrange),
      ),
      body: FutureBuilder(
        future: accountService.getFriends(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            snapshot.data.removeWhere(
                (element) => participantsAlreadyPresent.contains(element));
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
                          ? Icons.remove
                          : Icons.add,
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
}
