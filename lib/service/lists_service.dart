import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:in_expense/constant/application_constants.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/model/prodotto.dart';
import 'package:in_expense/model/request/prodotto_request.dart';
import 'package:in_expense/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListsService {
  Future<List<ListaSpesa>> getLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response =
        await http.get(ApplicationConstants.serverUrl + "/lista",
            headers: (<String, String>{
              "Content-Type": "application/json",
              "Authorization": "Bearer " + prefs.getString("token")
            }));
    if (response.statusCode != 200) throw Error();
    var listeObjJson = jsonDecode(response.body) as List;
    return listeObjJson.map((lista) => ListaSpesa.fromJson(lista)).toList();
  }

  Future<void> saveList(
      {String nomeLista, String descrizioneLista}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.post(
        ApplicationConstants.serverUrl + "/lista",
        headers: (<String, String>{
          "Content-Type": "application/json",
          "Authorization": "Bearer " + prefs.getString("token")
        }),
        body: jsonEncode({"nome": nomeLista, "descrizione": descrizioneLista}));
    if (response.statusCode != 200) throw Error();
  }

  saveProductsInList(List<ProductRequest> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response =
        await http.post(ApplicationConstants.serverUrl + "/lista/prodotti",
            headers: (<String, String>{
              "Authorization": "Bearer " + prefs.getString("token"),
              "Content-Type": "application/json"
            }),
            body: jsonEncode(list));
    if (response.statusCode != 200) throw Error();
    return (jsonDecode(response.body) as List)
        .map((prodotto) => Prodotto.fromJson(prodotto))
        .toList();
  }

  deleteProductFromList(idLista, idProdotto) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.delete(
        ApplicationConstants.serverUrl + "/lista/$idLista/prodotto/$idProdotto",
        headers: (<String, String>{
          "Authorization": "Bearer " + prefs.getString("token"),
          "Content-Type": "application/json"
        }));
    if (response.statusCode != 200) throw Error();
    return (jsonDecode(response.body) as List)
        .map((prodotto) => Prodotto.fromJson(prodotto))
        .toList();
  }

  Future<List<User>> addParticipantsToList(List<String> emails, idLista) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.post(
        ApplicationConstants.serverUrl + "/lista/$idLista/partecipanti",
        headers: (<String, String>{
          "Authorization": "Bearer " + prefs.getString("token"),
          "Content-Type": "application/json"
        }),
        body: jsonEncode(emails));
    if (response.statusCode != 200) throw Error();
    return (jsonDecode(response.body) as List)
        .map((partecipant) => User.fromJson(partecipant))
        .toList();
  }

  Future<List<User>> removeParticipantFromList(String email, idLista) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.delete(
        ApplicationConstants.serverUrl +
            "/lista/$idLista/partecipanti?email=$email",
        headers: (<String, String>{
          "Authorization": "Bearer " + prefs.getString("token"),
          "Content-Type": "application/json"
        }));
    if (response.statusCode != 200) throw Error();
    return (jsonDecode(response.body) as List)
        .map((partecipant) => User.fromJson(partecipant))
        .toList();
  }

  Future<List<Prodotto>> changeProductStatus(
      int idProdotto, int idLista) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.put(
        ApplicationConstants.serverUrl + "/lista/$idLista/prodotto/$idProdotto",
        headers: (<String, String>{
          "Authorization": "Bearer " + prefs.getString("token"),
          "Content-Type": "application/json"
        }));
    if (response.statusCode != 200) throw Error();
    return (jsonDecode(response.body) as List)
        .map((prodotto) => Prodotto.fromJson(prodotto))
        .toList();
  }

  Future<ListaSpesa> getListById(int idLista) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get(
      ApplicationConstants.serverUrl + "/lista/$idLista",
        headers: (<String, String>{
          "Authorization": "Bearer " + prefs.getString("token"),
          "Content-Type": "application/json"
        }));
    if(response.statusCode != 200) throw Error();
    return ListaSpesa.fromJson(jsonDecode(response.body));
  }
}
