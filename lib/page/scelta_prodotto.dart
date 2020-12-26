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
  ProductChoosePage({@required this.listaId, this.productsAlreadyPresent});

  final listaId;
  final productsAlreadyPresent;

  @override
  State<StatefulWidget> createState() => _ProductChoosePageState(
      listaId: listaId, productsAreadyPresent: productsAlreadyPresent);
}

class _ProductChoosePageState extends State<ProductChoosePage> {
  _ProductChoosePageState({@required this.listaId, this.productsAreadyPresent});

  final listaId;
  final List<Prodotto> productsAreadyPresent;
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
        future: productService.getProdotti(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Prodotto>> snapshot) {
          if (snapshot.hasData) {
            List<Prodotto> prodotti = snapshot.data;
            prodotti.removeWhere(
                (prodotto) => productsAreadyPresent.contains(prodotto));
            return ListView.builder(
              itemCount: prodotti.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${prodotti[index].nome}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                        child: Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  prodottiDaAggiungere.contains(prodotti[index])
                                      ? Icons.remove
                                      : Icons.add,
                                  color: prodottiDaAggiungere
                                          .contains(prodotti[index])
                                      ? Colors.deepOrange
                                      : Colors.green,
                                ),
                                onPressed: () => _onPressed(prodotti[index]))
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  _onPressed(Prodotto prodotto) {
    this.setState(
      () {
        if (prodottiDaAggiungere.contains(prodotto)) {
          prodottiDaAggiungere.remove(prodotto);
        } else {
          prodottiDaAggiungere.add(prodotto);
        }
      },
    );
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
    print("ListaId: $listaId");
    print("liste: $lista");
    lista.removeWhere((lista) => lista.id != listaId);
    Get.close(4);
    Get.to(ListsPage());
    Get.to(ListDetailPage(listaSpesa: lista[0]));
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

  List<Widget> getProductsDividedByCategories(List<Prodotto> prodotti) {
    List<Widget> productsAndCategory = List<Widget>();
    Map<String, List<Prodotto>> category2product =
        _generateMapOfCategory(prodotti);
    for (String category in category2product.keys) {
      productsAndCategory.add(Row(
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
          Text(
            category,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ));
      for (Prodotto p in category2product[category]) {}
    }
  }

  Map<String, List<Prodotto>> _generateMapOfCategory(List<Prodotto> prodotti) {
    Map<String, List<Prodotto>> result = Map<String, List<Prodotto>>();
    for (Prodotto p in prodotti) {
      if (result.containsKey(p.categoria)) {
        result[p.categoria].add(p);
      } else {
        List<Prodotto> newList = List<Prodotto>();
        newList.add(p);
        result.putIfAbsent(p.categoria, () => newList);
      }
    }
    return result;
  }
}
