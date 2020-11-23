import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/model/prodotto.dart';
import 'package:in_expense/model/request/prodotto_request.dart';
import 'package:in_expense/page/dettagli_lista.dart';
import 'package:in_expense/page/liste_attive.dart';
import 'package:in_expense/service/lists_service.dart';
import 'package:in_expense/service/product_service.dart';

class ProductChoosePage extends StatefulWidget {
  ProductChoosePage({@required this.listaId});

  final listaId;

  @override
  State<StatefulWidget> createState() =>
      _ProductChoosePageState(listaId: listaId);
}

class _ProductChoosePageState extends State<ProductChoosePage> {
  _ProductChoosePageState({@required this.listaId});

  final listaId;
  List<Prodotto> prodottiDaAggiungere = List<Prodotto>();
  ProductService productService = GetIt.I<ProductService>();
  ListsService listsService = GetIt.I<ListsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            prodottiDaAggiungere.isNotEmpty
                ? TextButton(
                    onPressed: () {
                      _onSavePressed(context);
                    },
                    child: Text(
                      AppLocalizations.of(context).translate("salva"),
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  )
                : TextButton(onPressed: null, child: null)
          ],
          backgroundColor: Colors.transparent,
          actionsIconTheme: IconThemeData(color: Colors.deepOrange),
        ),
        body: FutureBuilder(
            future: ProductService().getProdotti(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Prodotto>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${snapshot.data[index].nome}", style: TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        prodottiDaAggiungere
                                                .contains(snapshot.data[index])
                                            ? Icons.remove
                                            : Icons.add,
                                        color: prodottiDaAggiungere
                                                .contains(snapshot.data[index])
                                            ? Colors.deepOrange
                                            : Colors.green,
                                      ),
                                      onPressed: () =>
                                          _onPressed(snapshot.data[index]))
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  _onPressed(Prodotto prodotto) {
    this.setState(() {
      if (prodottiDaAggiungere.contains(prodotto)) {
        prodottiDaAggiungere.remove(prodotto);
      } else {
        prodottiDaAggiungere.add(prodotto);
      }
    });
    print(prodottiDaAggiungere);
  }

  _onSavePressed(context) async {
    buildShowDialog(context);
    await listsService.saveProductsInList(prodottiDaAggiungere
        .map((prodotto) => ProductRequest(
            id: prodotto.id,
            nome: prodotto.nome,
            categoria: prodotto.categoria,
            idListaDestinazione: listaId))
        .toList());
    List<ListaSpesa> lista = await listsService.getLists();
    lista.removeWhere((lista) => lista.id != listaId);
    Get.close(4);
    Get.to(ListsPage());
    Get.to(ListDetailPage(listaSpesa: lista.first));
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
