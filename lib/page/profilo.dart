import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/service/account_service.dart';
import 'package:in_expense/service/cloudinary_service.dart';

class ProfiloPage extends StatefulWidget {
  ProfiloPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfiloPageState createState() => _ProfiloPageState();
}

class _ProfiloPageState extends State<ProfiloPage> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController cognomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  AccountService accountService = GetIt.I<AccountService>();
  CloudinaryService cloudinaryService = GetIt.I<CloudinaryService>();
  User user;
  bool updated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ButtonBar(
            children: [
              updated
                  ? TextButton(
                      onPressed: _savePressed,
                      child: Text(
                        AppLocalizations.of(context).translate("salva"),
                        style: TextStyle(color: Colors.deepOrange),
                      ))
                  : Text(""),
            ],
          )
        ],
      ),
      body: FutureBuilder(
          future: accountService.getUserFromBE(),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              if (!updated) {
                user = snapshot.data;
                nomeController.text = snapshot.data.nome;
                cognomeController.text = snapshot.data.cognome;
                emailController.text = snapshot.data.email;
              }
              return ListView(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context).translate("il_tuo_profilo"),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.black,
                        child: snapshot.data.image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: Image.network(
                                  snapshot.data.image,
                                  width: 135,
                                  height: 135,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(70)),
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
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(left: 20)),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: TextField(
                          controller: nomeController,
                          onChanged: _onChange,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelText: AppLocalizations.of(context)
                                .translate("nome_utente_profilo"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: TextField(
                          controller: cognomeController,
                          onChanged: _onChange,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelText: AppLocalizations.of(context)
                                .translate("cognome_utente_profilo"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: TextField(
                          controller: emailController,
                          onChanged: _onChange,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            labelText: AppLocalizations.of(context)
                                .translate("email_utente_profilo"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: new Container(
                                  alignment: Alignment.center,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                      color: Colors.deepOrange,
                                      borderRadius:
                                          new BorderRadius.circular(9.0)),
                                  child: new Text(
                                      AppLocalizations.of(context)
                                          .translate("modifica_password"),
                                      style: new TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white))),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  _imgFromCamera() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    user.image = await cloudinaryService.uploadImage(image);
    User updatedUser = await accountService.updateProfile(user);
    this.setState(() {
      this.user = updatedUser;
    });
  }

  _imgFromGallery() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    user.image = await cloudinaryService.uploadImage(image);
    User updatedUser = await accountService.updateProfile(user);
    this.setState(() {
      this.user = updatedUser;
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

  void _onChange(String value) {
    if (nomeController.text != user.nome ||
        cognomeController.text != user.cognome ||
        emailController.text != user.email) {
      this.setState(() {
        user.nome = nomeController.text;
        user.cognome = cognomeController.text;
        user.email = emailController.text;
        updated = true;
      });
    }
  }

  void _savePressed() async {
    User updatedUser = await accountService.updateProfile(user);
    this.setState(() {
      updated = false;
      user = updatedUser;
    });
  }
}
