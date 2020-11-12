import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/prodotto.dart';

class ProductDetailsPage extends StatefulWidget {
  ProductDetailsPage({Key key, this.title, this.prodotto}) : super(key: key);

  final String title;
  final Prodotto prodotto;

  @override
  _ProductDetailsPageState createState() =>
      _ProductDetailsPageState(prodotto: prodotto);
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  _ProductDetailsPageState({this.prodotto});

  final Prodotto prodotto;
  TextEditingController descrizioneController = TextEditingController();
  TextEditingController testoController = TextEditingController();
  File _image;
  bool updated = false;

  @override
  Widget build(BuildContext context) {
    descrizioneController.text = prodotto.nome;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.green),
        actions: [
          TextButton(
            onPressed: () {},
            child: updated
                ? Text(
                    AppLocalizations.of(context).translate("salva"),
                    style: TextStyle(color: Colors.green),
                  )
                : Text(""),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if(!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
          child: ListView(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Text(
              prodotto.nome,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
        ]),
        SizedBox(
          height: 15,
        ),
        Container(
          child: Stack(children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.network(prodotto.image).image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    color: Colors.grey,
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () {
                      _showPicker(context);
                    },
                  ),
                ])
          ]),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          height: 100.0,
          child: TextField(
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              labelText: AppLocalizations.of(context)
                  .translate("inserimento_descrizione_prodotto"),
            ),
            controller: testoController,
            onChanged: _onChanged,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 150,
          ),
        ),
      ])),
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

  void _onChanged(String value) {
    this.setState(() {
      updated = testoController.text != prodotto.descrizione;
    });
  }
}
