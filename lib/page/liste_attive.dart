import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/component/list_element.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/service/lists_service.dart';

class ListsPage extends StatefulWidget {
  ListsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  final listsService = GetIt.I<ListsService>();
  int _selectedIndex;
  List<ListaSpesa> liste = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listsService.getLists(),
        initialData: liste,
        builder: (BuildContext context, AsyncSnapshot<List<ListaSpesa>> snapshot) => Scaffold(
            floatingActionButton: !snapshot.hasData ? null : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: addElement,
            ),
            body: snapshot.hasData ? Column(
              children: [
                Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return new ListElement(listaSpesa: snapshot.data[index]);
                      },
                    )),
              ],
            ) : Center(
              child: CircularProgressIndicator(),
            )
        ));
  }

  void addElement() {
    if (liste != null) {
      setState(() {
        liste.add(ListaSpesa(
            numeroProdotti: 0,
            numeroPartecipanti: 0,
            partecipanti: [],
            prodotti: []));
      });
    }
  }
}
