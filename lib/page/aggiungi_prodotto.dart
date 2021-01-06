import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/prodotto.dart';
import 'package:in_expense/service/product_service.dart';

class ProductAddPage extends StatefulWidget {
  ProductAddPage({Key key, this.title, this.prodotto}) : super(key: key);

  final String title;
  final Prodotto prodotto;

  @override
  _ProductAddPageState createState() =>
      _ProductAddPageState(prodotto: prodotto, title: title);
}

class _ProductAddPageState extends State<ProductAddPage> {
  _ProductAddPageState({this.title, this.prodotto});
  final String title;

  final Prodotto prodotto;
  ProductService productService = GetIt.I<ProductService>();
  TextEditingController nomeController = new TextEditingController();
  TextEditingController categoriaController = new TextEditingController();
  var dropdownValue;
  var isButtonEnabled = false;
  var isLoading = false;

  @override
  void initState() {
    if (this.prodotto != null) {
      nomeController.text = prodotto.nome;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.deepOrange),
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .translate(title),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextFormField(
                controller: nomeController,
                onChanged: _onValueChanged,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText:
                      AppLocalizations.of(context).translate("nome_prodotto"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      disabledHint: Text(AppLocalizations.of(context)
                          .translate("scegli_categoria")),
                      hint: Text(AppLocalizations.of(context)
                          .translate("scegli_categoria")),
                      value: dropdownValue,
                      iconSize: 24,
                      elevation: 16,
                      isExpanded: true,
                      onChanged: (String newValue) {
                        print(newValue);
                        setState(() {
                          dropdownValue = newValue;
                          if (newValue != null &&
                              nomeController.text.isNotEmpty &&
                              !nomeController.text.isBlank)
                            isButtonEnabled = true;
                          else
                            isButtonEnabled = false;
                        });
                      },
                      underline: null,
                      items: <String>[
                        'alimenti',
                        'utilita',
                        'bevande',
                        'casa',
                        'benessere'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                              AppLocalizations.of(context).translate(value)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
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
                        if (isButtonEnabled) {
                          setState(() {
                            this.isLoading = true;
                          });
                          await productService.saveProduct(
                              id: prodotto != null ? prodotto.id : null,
                              nome: nomeController.text,
                              categoria: dropdownValue);
                          Get.back();
                        }
                      },
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : new Container(
                              alignment: Alignment.center,
                              height: 60.0,
                              decoration: new BoxDecoration(
                                  color: isButtonEnabled
                                      ? Colors.deepOrange
                                      : Colors.grey,
                                  borderRadius: new BorderRadius.circular(9.0)),
                              child: new Text(
                                  AppLocalizations.of(context)
                                      .translate("salva"),
                                  style: new TextStyle(
                                      fontSize: 20.0, color: Colors.white))),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _onValueChanged(String value) {
    setState(() {
      if (dropdownValue != null &&
          nomeController.text.isNotEmpty &&
          !nomeController.text.isBlank)
        isButtonEnabled = true;
      else
        isButtonEnabled = false;
    });
  }
}
