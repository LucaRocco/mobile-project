import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class ProductAddPage extends StatefulWidget {
  ProductAddPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProductAddPageState createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'aggiungi prodotto',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            ButtonBar(
              children: [Text("Salva")],
            )
          ],
        ),
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 20, top: 30),
                  child: Text(
                    "prodotto da aggiungere:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            )),
          ),
        ]));
  }
}
