import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpansionTilePage extends StatefulWidget {
  ExpansionTilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ExpansionTilePageState createState() => _ExpansionTilePageState();
}

class _ExpansionTilePageState extends State<ExpansionTilePage> {
  TextEditingController marchioController = TextEditingController();
  TextEditingController supermercatoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
          child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExpansionTile(
                    title: Text("Caratteristiche prodotto"),
                    trailing: Icon(FontAwesomeIcons.arrowDown),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: TextField(
                          controller: marchioController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              labelText: "Marchio"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: TextField(
                          controller: supermercatoController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              labelText: "Supermercato"),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RaisedButton(
                              textColor: Colors.white,
                              color: Colors.green,
                              onPressed: () {},
                              child: Text("Salva"),
                            )
                          ])
                    ],
                  )
                ],
              ))),
    );
  }
}