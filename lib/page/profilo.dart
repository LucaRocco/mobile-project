import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_expense/internationalization/app_localizations.dart';

class ProfiloPage extends StatefulWidget {
  ProfiloPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfiloPageState createState() => _ProfiloPageState();
}

class _ProfiloPageState extends State<ProfiloPage> {
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("appBar_profilo")),
        actions: [
          ButtonBar(children: [
            Text(AppLocalizations.of(context).translate("salva_profilo"))
          ])
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xffFDCF09),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(padding: EdgeInsets.only(left: 20)),
                Text(
                  AppLocalizations.of(context).translate("nome_utente_profilo"),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                )
              ]),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("inserimento_nome_utente"),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(padding: EdgeInsets.only(left: 20)),
                Text(
                  AppLocalizations.of(context)
                      .translate("cognome_utente_profilo"),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                )
              ]),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("inserimento_cognome_utente"),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(padding: EdgeInsets.only(left: 20)),
                Text(
                  AppLocalizations.of(context)
                      .translate("email_utente_profilo"),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                )
              ]),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("inserimento_email_utente"),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text(
                        AppLocalizations.of(context)
                            .translate("modifica_password"),
                        style: TextStyle(fontSize: 20)),
                    onPressed: () => {},
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(AppLocalizations.of(context)
                          .translate("libreria_foto")),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(
                        AppLocalizations.of(context).translate("fotocamera")),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
