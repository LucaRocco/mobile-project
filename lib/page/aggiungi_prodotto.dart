import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/page/liste_attive.dart';
import 'package:in_expense/service/product_service.dart';

class ProductAddPage extends StatefulWidget {
  ProductAddPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProductAddPageState createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  ProductService productService = GetIt.I<ProductService>();
  TextEditingController nomeController = new TextEditingController();
  TextEditingController categoriaController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actionsIconTheme: IconThemeData(color: Colors.green),
        ),
        body: Container(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child:
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Aggiungi un prodotto",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  controller: nomeController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Nome',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: TextField(
                    controller: categoriaController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'Categoria',)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 40.0),
                        child: GestureDetector(
                          onTap: () async {
                            await productService.saveProduct(
                                nome: nomeController.text,
                                categoria: categoriaController.text);
                            Get.off(ListsPage());
                          },
                          child: new Container(
                              alignment: Alignment.center,
                              height: 60.0,
                              decoration: new BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: new BorderRadius.circular(9.0)),
                              child: new Text("Salva",
                                  style: new TextStyle(
                                      fontSize: 20.0, color: Colors.white))),
                        )),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
