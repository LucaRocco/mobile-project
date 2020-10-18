import 'package:flutter/material.dart';
import 'package:in_expense/liste_attive.dart';
import 'package:in_expense/login.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/service/account_service.dart';

setUpServices() {
  GetIt.I.registerLazySingleton(() => AccountService());
}

void main() {
  setUpServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AccountService().isUserLoggedIn(),
      builder: (context, snapshot) => MaterialApp(
        title: 'inExpense',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: snapshot.hasData
            ? (snapshot.data ? ListsPage() : LoginPage())
            : throw Error(),
      ),
    );
  }
}
