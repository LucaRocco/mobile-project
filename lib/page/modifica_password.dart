import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/service/account_service.dart';

class ModificaPasswordPage extends StatefulWidget {
  ModificaPasswordPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ModificaPasswordPageState createState() => _ModificaPasswordPageState();
}

class _ModificaPasswordPageState extends State<ModificaPasswordPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController repetePasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  AccountService accountService = GetIt.I<AccountService>();

  bool disabledRegistrationButton = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)
              .translate("appBar_modifica_password")),
        ),
        body: Column(children: [
          Container(
            padding: EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: AppLocalizations.of(context)
                      .translate("inserimento_vecchia_password"),
                  icon: Icon(Icons.visibility_off_outlined)),
              controller: oldPasswordController,
              onChanged: _onChanged,
              obscureText: true,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: AppLocalizations.of(context)
                      .translate("inserimento_nuova_password"),
                  icon: Icon(Icons.visibility_off_outlined)),
              controller: passwordController,
              onChanged: _onChanged,
              obscureText: true,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: AppLocalizations.of(context)
                      .translate("conferma_nuova_password"),
                  icon: Icon(Icons.visibility_off_outlined)),
              controller: repetePasswordController,
              onChanged: _onChanged,
              obscureText: true,
            ),
          ),
          /* Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : RaisedButton(
                        child: Text('salva modifiche'),
                        onPressed: disabledRegistrationButton
                            ? null
                            : _registrationPressed),
              ),
            ],
          )*/
        ]));
  }
/*
  void _registrationPressed() async {
    this.setState(() {
      isLoading = true;
    });
    await accountService.performRegistration(
        passwordController.text);
    this.setState(() {
      isLoading = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerificationCodePage(user: this.user)));
  }
*/

  void _onChanged(String value) {
    this.setState(() {
      (passwordController.text.length < 8 ||
          passwordController.text != repetePasswordController.text);
    });
  }
}
