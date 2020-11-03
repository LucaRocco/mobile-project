import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/service/lists_service.dart';

class ListElement extends StatefulWidget {
  ListElement({Key key, this.title, this.listaSpesa}) : super(key: key);
  final String title;
  final ListaSpesa listaSpesa;

  @override
  State<StatefulWidget> createState() =>
      _ListElementState(listaSpesa: listaSpesa);
}

class _ListElementState extends State<ListElement> {
  _ListElementState({this.listaSpesa});
  ListsService listsService = GetIt.I<ListsService>();

  final ListaSpesa listaSpesa;
  final List<Color> lightColors = [
    Colors.green,
    Colors.pink,
    Colors.lightBlue,
    Colors.greenAccent,
    Colors.limeAccent
  ];
  final List<Color> darkColors = [
    Colors.red,
    Colors.purple,
    Colors.blue,
    Colors.black54,
    Colors.brown
  ];

  TextEditingController nomeController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [_randomLightColor(), _randomDarkColor()]),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: new Column(
          children: listaSpesa.nome == null
              ? [
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: TextField(
                        controller: nomeController,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate("nomeLista_list_element"),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelStyle: TextStyle(color: Colors.black)),
                      )),
                  Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  print(AppLocalizations.of(context)
                                      .translate("annulla_inserimento"));
                                },
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.delete_forever,
                                        size: 30,
                                      ),
                                    ])),
                            GestureDetector(
                                onTap: _addTapped,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 30,
                                      )
                                    ])),
                          ]))
                ]
              : [
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Padding(
                        padding: const EdgeInsets.only(top: 15, left: 15),
                        child: Text(
                          listaSpesa.nome,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Lobster'),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            print("freccia premuta");
                          },
                          child: Padding(
                              padding: EdgeInsets.only(top: 15, right: 15),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 30,
                              )))
                    ],
                  ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Container(
                              margin: EdgeInsets.only(
                                  left: 15, top: 15, bottom: 15),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                              child: Text(
                                listaSpesa.numeroProdotti.toString() +
                                    AppLocalizations.of(context)
                                        .translate("prodotti_list_element"),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.all(15),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                              child: Text(
                                  listaSpesa.numeroPartecipanti.toString() +
                                      AppLocalizations.of(context).translate(
                                          "partecipanti_list_element"),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )
                          ],
                        )
                      ])
                ],
        ));
  }

  Color _randomLightColor() {
    Random random = new Random();
    return lightColors[random.nextInt(lightColors.length)];
  }

  Color _randomDarkColor() {
    Random random = new Random();
    return darkColors[random.nextInt(darkColors.length)];
  }

  _addTapped() async {
    ListaSpesa listaSpesaFromBE =
        await listsService.saveList(nomeLista: nomeController.text);
    listaSpesa.id = listaSpesaFromBE.id;
    listaSpesa.nome = nomeController.text;
    setState(() {});
  }
}
