import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool disabledLogin = true;
  User user = User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        child: Column(
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
            Container(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Email',
                    icon: Icon(Icons.alternate_email)),
                controller: usernameController,
                onChanged: _onChanged,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Password',
                    icon: Icon(Icons.visibility_off_outlined)),
                controller: passwordController,
                onChanged: _onChanged,
              ),
            ),
            Row(
              children: [
                TextButton(
                  child: Text("Password Dimenticata"),
                  onPressed: () => {},
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: RaisedButton(
                      child: Text('Login'),
                      onPressed: disabledLogin ? null : _loginPressed),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            )
          ],
        ),
      ),
    );
  }

  void _loginPressed() {
    setState(() {
      user.username = usernameController.text;
      user.password = passwordController.text;
    });
  }

  void _onChanged(String value) {
    setState(() {
      disabledLogin = (usernameController.text.length < 6 ||
          passwordController.text.length < 8);
    });
  }
}

class User {
  String username;
  String password;
}
