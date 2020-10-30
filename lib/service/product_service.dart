import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:in_expense/constant/application_constants.dart';
import 'package:in_expense/model/prodotto.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProductService {
  Future<List<Prodotto>> getProdotti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get(ApplicationConstants.serverUrl + "/prodotto/all",
    headers: (<String, String> {
      "Authorization": "Bearer " + prefs.getString("token")
    }));
    if(response.statusCode != 200) throw Error();
    var jsonDecoded = jsonDecode(response.body) as List;
    return jsonDecoded.map((json) { Prodotto.fromJson(json); }).toList();
  }
}