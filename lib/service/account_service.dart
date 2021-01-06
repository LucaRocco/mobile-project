import 'dart:convert';

import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:http/http.dart' as http;
import 'package:in_expense/constant/application_constants.dart';
import 'package:in_expense/exception/code_verification_exception.dart';
import 'package:in_expense/exception/login_exception.dart';
import 'package:in_expense/model/user.dart';
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
      headers: (<String, String>{
        "Content-Type": "application/json",
      }),
      body: jsonEncode(<String, String>{
        'nome': firstName,
        'cognome': lastName,
        'email': email,
        'foto': 'https://robohash.org/$email.png'
      }),
    );

    if (response.statusCode != 200) throw Error();
    return data;
  }

  Future<bool> performEmailConfirmation(email, verificationCode) async {
    final CognitoUserPool userPool = getCognitoUserPool();

    final cognitoUser = new CognitoUser(email, userPool);

    bool registrationConfirmed = false;
    try {
      registrationConfirmed =
          await cognitoUser.confirmRegistration(verificationCode);
    } catch (e) {
      throw CodeVerificationException(cause: "Error during code verify");
    }
    setUserStatus(UserStatus.EMPTY);
    return registrationConfirmed;
  }

  Future<CognitoUserSession> performLogin(email, password) async {
    final CognitoUserPool userPool = getCognitoUserPool();
    final cognitoUser = new CognitoUser(email, userPool);
    final authDetails =
        new AuthenticationDetails(username: email, password: password);
    CognitoUserSession session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);
    } on CognitoUserConfirmationNecessaryException {
      throw LoginException(cause: "Error during login");
    } on CognitoClientException catch (e) {
      if (e.code == "NotAuthorizedException") {
        throw LoginException(cause: "Error during login");
      }
    } catch (e) {
      throw LoginException(cause: "Error during login");
    }

    this.authenticatedUser = cognitoUser;
    var attributes = await getUserAttributes();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    attributes.forEach((element) {
      prefs.setString(element.name, element.value);
    });
    setUserStatus(UserStatus.LOGGED);
    prefs.setString("token", session.idToken.jwtToken);
    User user = await this.getUserFromBE();
    prefs.setString("uname", user.nome);
    prefs.setString("usname", user.cognome);
    prefs.setString("uimage", user.image);
    prefs.setString("uemail", user.email);
    prefs.setInt("uid", user.userId);
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

    http.Response response =
        await http.post(ApplicationConstants.serverUrl + "/user/confirm");
    if (response.statusCode != 200) throw Error();
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
    print("Forgottend Data: $data");

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

  Future<User> getUserFromBE() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("token")) return User();
    http.Response response = await http.get(
      ApplicationConstants.serverUrl + "/user",
      headers: (<String, String>{
        "Content-Type": "application/json",
        "Authorization": "Bearer " + prefs.getString("token")
      }),
    );
    if (response.statusCode != 200) throw Error();
    return User.fromJson(jsonDecode(response.body));
  }

  Future<User> updateProfile(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response =
        await http.put(ApplicationConstants.serverUrl + "/user",
            headers: (<String, String>{
              "Content-Type": "application/json",
              "Authorization": "Bearer " + prefs.getString("token")
            }),
            body: jsonEncode({
              "nome": user.nome,
              "cognome": user.cognome,
              "email": user.email,
              "foto": user.image
            }));
    if (response.statusCode != 200) throw Error();
    return User.fromJson(jsonDecode(response.body));
  }

  Future<List<User>> getFriends() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response =
        await http.get(ApplicationConstants.serverUrl + "/user/friends",
            headers: (<String, String>{
              "Content-Type": "application/json",
              "Authorization": "Bearer " + prefs.getString("token")
            }));
    if (response.statusCode != 200) throw Error();
    return (jsonDecode(response.body) as List)
        .map((user) => User.fromJson(user))
        .toList();
  }

  Future<List<User>> searchUserByNameAndEmailLike(String query, idLista) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get(
        ApplicationConstants.serverUrl +
            "/user/search?query=$query&idLista=$idLista",
        headers: (<String, String>{
          "Content-Type": "application/json",
          "Authorization": "Bearer " + prefs.getString("token")
        }));
    if (response.statusCode != 200) throw Error();
    return (jsonDecode(response.body) as List)
        .map((user) => User.fromJson(user))
        .toList();
  }

  Future<List<User>> searchUserByNameAndFilterByFriends(String query) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get(
        ApplicationConstants.serverUrl +
            "/user/search/collaborators?query=$query",
        headers: (<String, String>{
          "Content-Type": "application/json",
          "Authorization": "Bearer " + prefs.getString("token")
        }));
    if (response.statusCode != 200) throw Error();
    return (jsonDecode(response.body) as List)
        .map((user) => User.fromJson(user))
        .toList();
  }

  Future<void> addFriend(amicoId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.post(
        ApplicationConstants.serverUrl + "/user/friends/$amicoId",
        headers: (<String, String>{
          "Content-Type": "application/json",
          "Authorization": "Bearer " + prefs.getString("token")
        }));
    if (response.statusCode != 200) throw Error();
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
