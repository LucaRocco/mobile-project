import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/password_dimenticata.dart';
import 'package:in_expense/exception/login_exception.dart';
import 'package:in_expense/liste_attive.dart';
import 'package:in_expense/registrazione.dart';
import 'package:in_expense/service/account_service.dart';

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
  bool isEmailCorrect = true;
  bool isPasswordCorrect = true;

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
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Accedi al tuo account",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TextFormField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: getEmailElementsColor()),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: getEmailElementsColor()),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: 'Email',
                  icon: Icon(Icons.alternate_email,
                      color: getEmailElementsColor())),
              controller: emailController,
              onChanged: _onChanged,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: getPasswordElementsColor()),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: getPasswordElementsColor()),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Password',
                  icon: Icon(
                    Icons.visibility_off_outlined,
                    color: getPasswordElementsColor(),
                  )),
              controller: passwordController,
              onChanged: _onChanged,
              obscureText: true,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  child: Text("Non hai un account? REGISTRATI"),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage())))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  child: Text("Password Dimenticata"),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaaswordDimenticataPage()))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Builder(
                    builder: (buildContext) => isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : RaisedButton(
                            child: Text('Login'),
                            onPressed: disabledLogin ? null : _login,
                            color: Colors.blue),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  void _login() async {
    this.setState(() {
      loginFailed = false;
      isLoading = true;
    });
    try {
      final loginResult = await accountService.performLogin(
          emailController.text, passwordController.text);
    } on LoginException catch (e) {
      this.setState(() {
        loginFailed = true;
      });
    }
    this.setState(() {
      isLoading = false;
    });
    if (!loginFailed) {
      Navigator.push(
          this.context, MaterialPageRoute(builder: (context) => ListsPage()));
    }
  }

  void _onChanged(String value) {
    this.setState(() {
      isPasswordCorrect = passwordController.text.length > 8;
      isEmailCorrect = emailController.text.contains("@");
      disabledLogin = !(isEmailCorrect && isPasswordCorrect);
    });
  }

  Color getPasswordElementsColor() =>
      isPasswordCorrect ? Colors.blue : Colors.red;

  Color getEmailElementsColor() => isEmailCorrect ? Colors.blue : Colors.red;
}
