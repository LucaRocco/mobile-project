import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/page/login.dart';
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
                      "${AppLocalizations.of(context).translate("messaggio_di_conferma1")} ${user.nome}.\n\n${AppLocalizations.of(context).translate("messaggio_di_conferma2")}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("codice_di_verifica"),
                    prefixIcon: Icon(Icons.dialpad)),
                controller: codeController,
                onChanged: _onChanged,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _verifyPressed,
                child: new Container(
                    alignment: Alignment.center,
                    height: 60.0,
                    decoration: new BoxDecoration(
                        color: disabledVerificationButton
                            ? Colors.grey
                            : Colors.deepOrange,
                        borderRadius: new BorderRadius.circular(9.0)),
                    child: new Text(
                        AppLocalizations.of(context)
                            .translate("pulsante_di_verifica"),
                        style: new TextStyle(
                            fontSize: 20.0, color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyPressed() async {
    if (!disabledVerificationButton) {
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
  }

  void _onChanged(String value) {
    setState(() {
      disabledVerificationButton = codeController.text.length < 6;
    });
  }
}
