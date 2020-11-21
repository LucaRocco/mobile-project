import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:in_expense/component/list_scroller.dart';
import 'package:in_expense/page/home_page.dart';
import 'package:in_expense/page/liste_attive.dart';
import 'package:in_expense/page/login.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/service/account_service.dart';
import 'package:in_expense/page/verifica_codice_registrazione.dart';
import 'package:in_expense/service/cloudinary_service.dart';
import 'package:in_expense/service/lists_service.dart';
import 'package:in_expense/service/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'internationalization/app_localizations.dart';

setUpServices() {
  GetIt.I.registerLazySingleton(() => AccountService());
  GetIt.I.registerLazySingleton(() => ListsService());
  GetIt.I.registerLazySingleton(() => ProductService());
  GetIt.I.registerLazySingleton(() => CloudinaryService());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpServices();
  Widget _homePage = LoginPage();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  AccountService accountService = GetIt.I<AccountService>();
  final userStatus = await accountService.getUserStatus();
  switch (userStatus) {
    case UserStatus.LOGGED:
      _homePage = ListsPage();
      break;
    case UserStatus.NEED_EMAIL_CONFIRMATION:
      _homePage = VerificationCodePage(
          user: User(
              nome: prefs.getString("firstName"),
              email: prefs.getString("email"),
              cognome: prefs.getString("lastName")));
      break;
    case UserStatus.EMPTY:
      _homePage = HomePage();
      break;
  }
  runApp(MyApp(homePage: _homePage));
}

class MyApp extends StatelessWidget {
  MyApp({this.homePage});

  final Widget homePage;

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', ''),
                const Locale('it', '')
              ],
              title: 'inExpense',
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                    color: Colors.transparent,
                    elevation: 0,
                    iconTheme: IconThemeData(color: Colors.green)),
                primarySwatch: Colors.blue,
                accentColor: Colors.green,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: homePage);
        });
  }
}

//rest of the themeData
//you can also use conditioning here based on the current
//brightness mode (dark or light). For ex:
// primarySwatch: brightness == Brighness.dark ? Colors.white : Colors.black
