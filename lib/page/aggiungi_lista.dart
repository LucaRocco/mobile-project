import 'package:flutter/cupertino.dart';

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AggiungiListaPage extends StatefulWidget {
  @override
  _AggiungiListaPageState createState() => _AggiungiListaPageState();
}

class _AggiungiListaPageState extends State<AggiungiListaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextFormField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                labelText: 'nome della lista',
                icon: Icon(Icons.add),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'descrizione')),
          ),
          FloatingActionButton(onPressed: null)
        ]),
      ),
    );
  }
}
