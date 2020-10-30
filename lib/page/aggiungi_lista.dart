import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/page/liste_attive.dart';
import 'package:in_expense/service/lists_service.dart';
import 'package:in_expense/service/product_service.dart';

class AggiungiListaPage extends StatefulWidget {
  @override
  _AggiungiListaPageState createState() => _AggiungiListaPageState();
}

class _AggiungiListaPageState extends State<AggiungiListaPage> {
  ListsService listsService = GetIt.I<ListsService>();
  TextEditingController nomeController = new TextEditingController();
  TextEditingController descrizioneController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.green),
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "Aggiungi una lista",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextFormField(
                controller: nomeController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: 'Nome',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                controller: descrizioneController,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'Descrizione',)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 40.0),
                      child: GestureDetector(
                        onTap: () async {
                          await listsService.saveList(
                              nomeLista: nomeController.text,
                              descrizioneLista: descrizioneController.text);
                          Get.off(ListsPage());
                        },
                        child: new Container(
                            alignment: Alignment.center,
                            height: 60.0,
                            decoration: new BoxDecoration(
                                color: Colors.green,
                                borderRadius: new BorderRadius.circular(9.0)),
                            child: new Text("Salva",
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white))),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
