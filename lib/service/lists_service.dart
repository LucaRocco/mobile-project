import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:in_expense/constant/application_constants.dart';
import 'package:in_expense/model/lista_spesa.dart';
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
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) throw Error();
    var listeObjJson = jsonDecode(response.body) as List;
    return listeObjJson.map((lista) => ListaSpesa.fromJson(lista)).toList();
  }

  Future<ListaSpesa> saveList(String nomeLista) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response =
        await http.post(ApplicationConstants.serverUrl + "/lista",
            headers: (<String, String>{
              "Content-Type": "application/json",
              "Authorization": "Bearer " + prefs.getString("token")
            }),
            body: jsonEncode({"nome": nomeLista}));
    print(response.statusCode);
    print(response.body);
    print(jsonEncode('{"nome", $nomeLista}'));
    if(response.statusCode != 200) throw Error();
    return ListaSpesa.fromJson(jsonDecode(response.body));
  }
}
