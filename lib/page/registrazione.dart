import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/service/account_service.dart';
import 'package:in_expense/page/verifica_codice_registrazione.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegistrationPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repetePasswordController = TextEditingController();

  AccountService accountService = GetIt.I<AccountService>();

  bool disabledRegistrationButton = true;
  bool isLoading = false;
  User user = User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate("appBar_registrazione")),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate("descrizione_registrazione"),
                      overflow: TextOverflow.visible,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("nome_per_registrazione"),
                    icon: Icon(Icons.tag_faces_sharp)),
                controller: firstNameController,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("cognome_per_registrazione"),
                    icon: Icon(Icons.tag_faces_sharp)),
                controller: lastNameController,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("email_per_registrazione"),
                    icon: Icon(Icons.alternate_email)),
                controller: emailController,
                onChanged: _onChanged,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("password_per_registrazione"),
                    icon: Icon(Icons.visibility_off_outlined)),
                controller: passwordController,
                onChanged: _onChanged,
                obscureText: true,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("ripetizione_password_per_registrazione"),
                    icon: Icon(Icons.visibility_off_outlined)),
                controller: repetePasswordController,
                onChanged: _onChanged,
                obscureText: true,
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
                          child: Text(AppLocalizations.of(context)
                              .translate("pulsante_per_registrazione")),
                          onPressed: disabledRegistrationButton
                              ? null
                              : _registrationPressed),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _registrationPressed() async {
    this.setState(() {
      user.nome = firstNameController.text;
      user.cognome = lastNameController.text;
      user.email = emailController.text;
      isLoading = true;
    });
    await accountService.performRegistration(
        user.nome, user.cognome, user.email, passwordController.text);
    this.setState(() {
      isLoading = false;
    });
    Get.to(VerificationCodePage(user: this.user));
  }

  void _onChanged(String value) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    this.setState(() {
      disabledRegistrationButton = (!regex.hasMatch(emailController.text) ||
          passwordController.text.length < 8 ||
          passwordController.text != repetePasswordController.text);
    });
  }
}
