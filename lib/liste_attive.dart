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
        title: Text("Le tue liste"),
      ),
    );
  }
}
