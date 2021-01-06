import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/page/verifica_codice_registrazione.dart';
import 'package:in_expense/service/account_service.dart';

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
  RegExp regex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  AccountService accountService = GetIt.I<AccountService>();

  bool disabledRegistrationButton = true;
  bool isLoading = false;
  User user = User();
  bool checkedBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              padding: EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("nome_per_registrazione"),
                    prefixIcon: Icon(Icons.tag_faces_sharp)),
                controller: firstNameController,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("cognome_per_registrazione"),
                    prefixIcon: Icon(Icons.tag_faces_sharp)),
                controller: lastNameController,
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("email_per_registrazione"),
                    prefixIcon: Icon(Icons.alternate_email)),
                controller: emailController,
                onChanged: _onChanged,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("password_per_registrazione"),
                    prefixIcon: Icon(Icons.visibility_off_outlined)),
                controller: passwordController,
                onChanged: _onChanged,
                obscureText: true,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: AppLocalizations.of(context)
                        .translate("ripetizione_password_per_registrazione"),
                    prefixIcon: Icon(Icons.visibility_off_outlined)),
                controller: repetePasswordController,
                onChanged: _onChanged,
                obscureText: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Checkbox(
                      value: checkedBox, onChanged: _onCheckboxChanged),
                ),
                Text(
                  "Accetto i",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14 / MediaQuery.of(context).textScaleFactor),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Termini e Condizioni",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14 / MediaQuery.of(context).textScaleFactor),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Builder(
                builder: (buildContext) => isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _registrationPressed,
                              child: new Container(
                                  alignment: Alignment.center,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                      color: disabledRegistrationButton
                                          ? Colors.grey
                                          : Colors.deepOrange,
                                      borderRadius:
                                          new BorderRadius.circular(9.0)),
                                  child: new Text(
                                      AppLocalizations.of(context).translate(
                                          "pulsante_per_registrazione"),
                                      style: new TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white))),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
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
    this.setState(() {
      disabledRegistrationButton = (!regex.hasMatch(emailController.text) ||
          passwordController.text.length < 8 ||
          passwordController.text != repetePasswordController.text ||
          !checkedBox);
    });
  }

  void _onCheckboxChanged(bool value) {
    this.setState(() {
      checkedBox = value;
      disabledRegistrationButton = (!regex.hasMatch(emailController.text) ||
          passwordController.text.length < 8 ||
          passwordController.text != repetePasswordController.text ||
          !checkedBox);
    });
  }
}
