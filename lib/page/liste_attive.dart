import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/component/list_scroller.dart';
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
  List<ListaSpesa> liste = [];

  @override
  Widget build(BuildContext context) {
    return ListScroller();
  }
}
