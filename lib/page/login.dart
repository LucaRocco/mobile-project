import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/exception/login_exception.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/page/liste_attive.dart';
import 'package:in_expense/page/registrazione.dart';
import 'package:in_expense/service/account_service.dart';
import 'package:in_expense/widget/logo.dart';

import 'modifica_password.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.email}) : super(key: key);

  final String title;
  final String email;

  @override
  _LoginPageState createState() => _LoginPageState(email: this.email);
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState({this.email});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final String email;

  AccountService accountService = GetIt.I<AccountService>();

  bool disabledLogin = true;
  bool isLoading = false;
  bool loginFailed = false;
  bool visiblePassword = false;

  @override
  void initState() {
    this.emailController.text = email != null ? email : "";
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Container(
          height: double.maxFinite,
          child: ListView(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 30)),
              Logo(),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: new Text(
                      "inExpense",
                      style: new TextStyle(fontSize: 30.0),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.all(20)),
                ],
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 16, bottom: 16, left: 30, right: 30),
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.alternate_email),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Email',
                  ),
                  controller: emailController,
                  onChanged: _onChanged,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: visiblePassword
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          visiblePassword = !visiblePassword;
                        });
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Password',
                  ),
                  controller: passwordController,
                  onChanged: _onChanged,
                  obscureText: !visiblePassword,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 30, right: 30),
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
                                onTap: () {
                                  _login();
                                },
                                child: new Container(
                                    alignment: Alignment.center,
                                    height: 60.0,
                                    decoration: new BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            new BorderRadius.circular(9.0)),
                                    child: new Text("Login",
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white))),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              TextButton(
                  child: Text(AppLocalizations.of(context)
                      .translate("recupera_password")),
                  onPressed: () => Get.to(ModificaPasswordPage())),
              SizedBox(height: MediaQuery.of(context).size.height / 5),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: TextButton(
                          child: Text(AppLocalizations.of(context)
                              .translate("registrazione")),
                          onPressed: () => Get.to(RegistrationPage())),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  void _login() async {
    this.setState(() {
      loginFailed = false;
      isLoading = true;
    });
    try {
      await accountService.performLogin(
          emailController.text, passwordController.text);
    } on LoginException catch (e) {
      this.setState(() {
        loginFailed = true;
        Get.showSnackbar(GetBar(
          title: "Login Error",
          message: e.cause,
          duration: Duration(seconds: 4),
          animationDuration: Duration(milliseconds: 600),
        ));
      });
    }
    this.setState(() {
      isLoading = false;
    });
    if (!loginFailed) {
      Get.offAll(ListsPage());
    }
  }

  void _onChanged(String value) {
    this.setState(() {
      disabledLogin = !(passwordController.text.length > 8 &&
          emailController.text.contains("@"));
    });
  }
}
