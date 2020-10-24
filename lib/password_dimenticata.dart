import 'package:flutter/material.dart';

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
        appBar: AppBar(title: Text('Cambia Password')),
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Se hai dimenticato la password, ' +
                      'puoi richiedere una nuova password tramite la tua email',
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
                  labelText: ' Inserisci Email',
                )),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: RaisedButton(
                      child: Text('invia'),
                      onPressed: () => {},
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              )
            ])));
  }
}
