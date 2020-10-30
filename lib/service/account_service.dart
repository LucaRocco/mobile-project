import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:in_expense/constant/application_constants.dart';
import 'package:in_expense/exception/code_verification_exception.dart';
import 'package:in_expense/exception/login_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  CognitoUser authenticatedUser;

  CognitoUserPool getCognitoUserPool() {
    return new CognitoUserPool(
        'us-east-1_dkjj8yRFo', '2f97ljcqvolns9kge2nu0rm5oo');
  }

  Future<CognitoUserPoolData> performRegistration(
      firstName, lastName, email, password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final CognitoUserPool userPool = getCognitoUserPool();
    final userAttributes = [
      new AttributeArg(name: 'email', value: email),
      new AttributeArg(name: 'name', value: firstName),
      new AttributeArg(name: 'family_name', value: firstName + " " + lastName)
    ];

    var data;
    try {
      data = await userPool.signUp(email, password,
          userAttributes: userAttributes);
    } catch (e) {
      print(e);
    }

    prefs.setString("email", email);
    prefs.setString("firstName", firstName);
    prefs.setString("lastName", lastName);

    setUserStatus(UserStatus.NEED_EMAIL_CONFIRMATION);

    final http.Response response = await http.post(
      ApplicationConstants.serverUrl + "/user/create",
      headers: (<String, String> {
        "Content-Type": "application/json",
        "Authorization": "Bearer" + prefs.getString("token")
      }),
      body: jsonEncode(<String, String>{
        'nome': firstName,
        'cognome': lastName,
        'email': email
      }),
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode != 200) throw Error();
    return data;
  }

  performEmailConfirmation(email, verificationCode) async {
    final CognitoUserPool userPool = getCognitoUserPool();

    final cognitoUser = new CognitoUser(email, userPool);

    bool registrationConfirmed = false;
    try {
      registrationConfirmed =
          await cognitoUser.confirmRegistration(verificationCode);
    } catch (e) {
      throw CodeVerificationException(
          cause:
              "Il codice inserito non corrisponde con quello che abbiamo inviato");
    }
    setUserStatus(UserStatus.EMPTY);
  }

  Future<CognitoUserSession> performLogin(email, password) async {
    final CognitoUserPool userPool = getCognitoUserPool();
    final cognitoUser = new CognitoUser(email, userPool);
    final authDetails =
        new AuthenticationDetails(username: email, password: password);
    CognitoUserSession session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);
    } on CognitoUserConfirmationNecessaryException catch (e) {
      throw LoginException(
          cause:
              "È necessario confermare il proprio account per potere accedere all'applicazione");
    } on CognitoClientException catch (e) {
      if (e.code == "NotAuthorizedException") {
        throw LoginException(
            cause: "Username o password errati, si prega di riprovare");
      }
    } catch (e) {
      throw LoginException(
          cause: "Errore durante il login, si prega di riprovare più tardi");
    }

    this.authenticatedUser = cognitoUser;
    var attributes = await getUserAttributes();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    attributes.forEach((element) {
      prefs.setString(element.name, element.value);
    });
    setUserStatus(UserStatus.LOGGED);
    prefs.setString("token", session.idToken.jwtToken);
    print(session.idToken.jwtToken);
    return session;
  }

  getUserAttributes() async {
    List<CognitoUserAttribute> attributes;
    try {
      attributes = await authenticatedUser.getUserAttributes();
    } catch (e) {
      print(e);
    }
    return attributes;
  }

  resendVerificationCode(email) async {
    final CognitoUserPool userPool = getCognitoUserPool();
    final cognitoUser = new CognitoUser(email, userPool);
    try {
      await cognitoUser.resendConfirmationCode();
    } catch (e) {
      print(e);
    }

    http.Response response = await http.post(ApplicationConstants.serverUrl + "/user/confirm");
    if(response.statusCode != 200) throw Error();
  }

  updateUserAttributes(attributeName, attributeValue) async {
    final List<CognitoUserAttribute> attributes = getUserAttributes();
    attributes.add(
        new CognitoUserAttribute(name: attributeName, value: attributeValue));

    try {
      await this.authenticatedUser.updateAttributes(attributes);
    } catch (e) {
      print(e);
    }
  }

  changePassword(oldPassword, newPassword) async {
    bool passwordChanged = false;
    try {
      passwordChanged =
          await authenticatedUser.changePassword(oldPassword, newPassword);
    } catch (e) {
      print(e);
    }
    print(passwordChanged);
  }

  sendForgottenPasswordCode(email) async {
    final userPool = getCognitoUserPool();
    final cognitoUser = new CognitoUser(email, userPool);

    var data;
    try {
      data = await cognitoUser.forgotPassword();
    } catch (e) {
      print(e);
    }

// INTERROMPERE QUI IL FLUSSO DELL'OPERAZIONE PER POI RIPRENDERLO IN UN'ALTRA FUNZIONE.

    bool passwordConfirmed = false;
    try {
      passwordConfirmed =
          await cognitoUser.confirmPassword('123456', 'newPassword');
    } catch (e) {
      print(e);
    }
    print(passwordConfirmed);
  }

  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("name");
  }

  Future<String> getUserCompleteName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("family_name");
  }

  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("UserStatus") == UserStatus.LOGGED.toString();
  }

  void setUserStatus(UserStatus userStatus) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("UserStatus", userStatus.toString());
  }

  Future<UserStatus> getUserStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("UserStatus")) return UserStatus.EMPTY;
    return UserStatus.values.firstWhere(
        (element) => element.toString() == prefs.getString("UserStatus"));
  }
}

enum UserStatus { LOGGED, NEED_EMAIL_CONFIRMATION, EMPTY }

class AccountUtility {
  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}