import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:in_expense/constant/application_constants.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/model/request/prodotto_request.dart';
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
    print(response.body);
    var listeObjJson = jsonDecode(response.body) as List;
    return listeObjJson.map((lista) => ListaSpesa.fromJson(lista)).toList();
  }

  Future<ListaSpesa> saveList({String nomeLista, String descrizioneLista}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response =
        await http.post(ApplicationConstants.serverUrl + "/lista",
            headers: (<String, String>{
              "Content-Type": "application/json",
              "Authorization": "Bearer " + prefs.getString("token")
            }),
            body: jsonEncode(
                {
                  "nome": nomeLista,
                  "descrizione": descrizioneLista
                }));
    if(response.statusCode != 200) throw Error();
    return ListaSpesa.fromJson(jsonDecode(response.body));
  }

  saveProductsInList(List<ProductRequest> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(jsonEncode(list));
    http.Response response =
    await http.post(ApplicationConstants.serverUrl + "/lista/prodotti",
        headers: (<String, String>{
          "Authorization": "Bearer " + prefs.getString("token"),
          "Content-Type": "application/json"
        }),
        body: jsonEncode(list));
    print(response.body);

    if(response.statusCode != 200) throw Error();
    print(response.statusCode);
  }
}
