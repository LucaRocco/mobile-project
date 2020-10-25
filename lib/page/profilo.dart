import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
        title: Text('Profilo'),
        actions: [
          ButtonBar(children: [Text("Salva")])
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
                  "NOME",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                )
              ]),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'inserisci il tuo nome',
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(padding: EdgeInsets.only(left: 20)),
                Text(
                  "COGNOME",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                )
              ]),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'inserisci il tuo cognome',
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(padding: EdgeInsets.only(left: 20)),
                Text(
                  "E-MAIL",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                )
              ]),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'inserisci la tua e-mail',
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text("MODIFICA PASSWORD",
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
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
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
