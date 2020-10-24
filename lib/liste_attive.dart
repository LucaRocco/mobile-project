import 'package:flutter/material.dart';

class ListsPage extends StatefulWidget {
  ListsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Liste",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(child: Icon(Icons.add), onPressed: null)
            ],
          ),
        ));
  }

  void _newList() {
    /* DA IMPLEMENTARE */
  }
}
