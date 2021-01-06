import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/constant/application_constants.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/prodotto.dart';
import 'package:in_expense/model/request/prodotto_request.dart';
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
  List<Prodotto> prodotti;

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
      body: prodotti == null
          ? FutureBuilder(
              future: productService.getProdotti(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Prodotto>> snapshot) {
                if (snapshot.hasData) {
                  this.prodotti = snapshot.data;
                  prodotti.forEach((element) => element.quantita = 1);
                  prodotti.removeWhere((prodotto) => productsAreadyPresent
                      .any((element) => element.originalId == prodotto.id));
                  return buildListView();
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          : buildListView(),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: prodotti.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.white),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.black))),
                child: ApplicationConstants
                    .category2image[prodotti[index].categoria],
              ),
              title: Text(
                prodotti[index].nome.replaceAll(" ", "\n"),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

              subtitle: Row(
                children: <Widget>[
                  Text(
                      AppLocalizations.of(context)
                          .translate(prodotti[index].categoria),
                      style: TextStyle(color: Colors.black, fontSize: 12))
                ],
              ),
              trailing: Container(
                height: 100,
                width: 160,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            prodotti[index].quantita--;
                          });
                          print(prodotti[index].quantita);
                        }),
                    Text("${prodotti[index].quantita}"),
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            prodotti[index].quantita =
                                prodotti[index].quantita + 1;
                          });
                          print(prodotti[index].quantita);
                        }),
                    SizedBox(
                      height: 40,
                      width: 25,
                      child: IconButton(
                        icon: Icon(
                          prodottiDaAggiungere.contains(prodotti[index])
                              ? Icons.remove_shopping_cart_outlined
                              : Icons.add_shopping_cart_outlined,
                          color: prodottiDaAggiungere.contains(prodotti[index])
                              ? Colors.deepOrange
                              : Colors.green,
                        ),
                        onPressed: () => _onPressed(prodotti[index]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
    List<Prodotto> prodotti = await listsService.saveProductsInList(
        prodottiDaAggiungere
            .map((prodotto) => ProductRequest(
                id: prodotto.id,
                nome: prodotto.nome,
                categoria: prodotto.categoria,
                idListaDestinazione: listaId,
                quantita: prodotto.quantita))
            .toList());
    Get.close(1);
    Get.back(result: prodotti);
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

  void getProductsDividedByCategories(List<Prodotto> prodotti) {
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
