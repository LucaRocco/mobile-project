import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
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
  var dropdownValue = "Scegli una categoria";
  var isButtonEnabled = false;

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
                        .translate("testo_nuovo_prodotto"),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextFormField(
                controller: nomeController,
                onChanged: _onNameChanged,
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
                      value: dropdownValue,
                      iconSize: 24,
                      elevation: 16,
                      isExpanded: true,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          if (newValue != 'Scegli una categoria' &&
                              nomeController.text.isNotEmpty &&
                              !nomeController.text.isNullOrBlank)
                            isButtonEnabled = true;
                          else
                            isButtonEnabled = false;
                        });
                      },
                      underline: null,
                      items: <String>[
                        'Scegli una categoria',
                        'Alimenti',
                        'Tecnologia',
                        'Bevande',
                        'Casa',
                        'Benessere'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
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
                          await productService.saveProduct(
                              nome: nomeController.text,
                              categoria: dropdownValue);
                          Get.offAll(ListsPage());
                        }
                      },
                      child: new Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          decoration: new BoxDecoration(
                              color:
                                  isButtonEnabled ? Colors.deepOrange : Colors.grey,
                              borderRadius: new BorderRadius.circular(9.0)),
                          child: new Text(
                              AppLocalizations.of(context)
                                  .translate("pulsante_salva_prodotto"),
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

  _onNameChanged(String value) {
    setState(() {
      if (dropdownValue != 'Scegli una categoria' &&
          nomeController.text.isNotEmpty &&
          !nomeController.text.isNullOrBlank)
        isButtonEnabled = true;
      else
        isButtonEnabled = false;
    });
  }
}
