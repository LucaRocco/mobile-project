import 'package:flutter/material.dart';
import 'package:in_expense/internationalization/app_localizations.dart';

class PaaswordDimenticataPage extends StatefulWidget {
  PaaswordDimenticataPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PaaswordDimenticataPageState createState() =>
      _PaaswordDimenticataPageState();
}

class _PaaswordDimenticataPageState extends State<PaaswordDimenticataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)
                .translate("appBar_cambia_password"))),
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context)
                      .translate("descrizione_password_dimenticata"),
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: TextField(
                    decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText:
                      AppLocalizations.of(context).translate("inserisci_email"),
                )),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: RaisedButton(
                      child:
                          Text(AppLocalizations.of(context).translate("invia")),
                      onPressed: () => {},
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              )
            ])));
  }
}
