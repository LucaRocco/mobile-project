import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/login.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/service/account_service.dart';

class VerificationCodePage extends StatefulWidget {
  VerificationCodePage({Key key, this.title, this.user}) : super(key: key);

  final User user;
  final String title;

  @override
  _VerificationCodePageState createState() =>
      _VerificationCodePageState(user: this.user);
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  _VerificationCodePageState({this.user});

  final User user;
  TextEditingController codeController = TextEditingController();

  AccountService accountService = GetIt.I<AccountService>();

  bool disabledVerificationButton = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conferma Registrazione"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Grazie " +
                          user.nome +
                          ". Abbiamo inviato un codice alla email che hai indicato in fase di registrazione, controlla la tua casella e inserisci il codice di verifica per confermare la registrazione",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Codice di verifica',
                    icon: Icon(Icons.dialpad)),
                controller: codeController,
                onChanged: _onChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : RaisedButton(
                          child: Text('Verifica'),
                          onPressed: disabledVerificationButton
                              ? null
                              : _verifyPressed),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _verifyPressed() async {
    this.setState(() {
      isLoading = true;
    });
    await accountService.performEmailConfirmation(
        user.email, codeController.text);
    this.setState(() {
      isLoading = false;
    });

    Get.off(LoginPage());
  }

  void _onChanged(String value) {
    setState(() {
      disabledVerificationButton = codeController.text.length < 6;
    });
  }
}
