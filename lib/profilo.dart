import 'package:flutter/material.dart';

/*pagina per creare il proprio"PROFILO" con vari campi:
- username
- e-mail
-data di nascita
- foto 
- liste a cui partecipi
- modifica password 
- logout
*/

class ProfiloPage extends StatefulWidget {
  ProfiloPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfiloPageState createState() => _ProfiloPageState();
}

class _ProfiloPageState extends State<ProfiloPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profilo')),
      body: Container(),
    );
  }
}
