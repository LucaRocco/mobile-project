import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/prodotto.dart';
import 'package:in_expense/page/aggiungi_lista.dart';
import 'package:in_expense/page/dettagli_prodotto.dart';
import 'package:in_expense/service/product_service.dart';

class ProductsScroller extends StatefulWidget {
  ProductsScroller({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _ProductsScrollerState();
}

class _ProductsScrollerState extends State<ProductsScroller> {
  ProductService productService = GetIt.I<ProductService>();
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.orange.shade400,
    Colors.amber.shade600,
    Colors.purple,
    Colors.teal,
    Colors.lightGreen,
    Colors.tealAccent,
    Colors.deepOrangeAccent,
    Colors.red.shade50
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: FittedBox(
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: getSummaryProductCards(context),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data;
                      } else {
                        return Container(
                          height:
                              MediaQuery.of(context).size.height * 0.27 - 70,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 2 -
                                      40),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)
                    .translate("liste_product_scroller"),
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              IconButton(icon: Icon(Icons.add), onPressed: _addList)
            ],
          ),
        ),
      ],
    );
  }

  Color getRandomColor() {
    Random random = new Random();
    return colors[random.nextInt(colors.length)];
  }

  Future<Widget> getSummaryProductCards(BuildContext context) async {
    List<Prodotto> responseList = await productService.getProdotti();
    List<Widget> listItems = [];

    final double productHeight = MediaQuery.of(context).size.height * 0.27 - 70;
    responseList.forEach(
      (element) {
        listItems.add(
          GestureDetector(
            key: UniqueKey(),
            onTap: () {
              Get.to(ProductDetailsPage(prodotto: element));
            },
            child: Container(
              width: 150,
              margin: EdgeInsets.only(right: 20),
              height: productHeight,
              decoration: BoxDecoration(
                  color: getRandomColor(),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            element.nome,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            element.categoria,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
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
    return listItems.isEmpty
        ? Container(
            width: MediaQuery.of(context).size.width - 40,
            height: MediaQuery.of(context).size.height * 0.25 - 50,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).translate("assente_prodotto"),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "'",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "+",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "'",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Row(children: listItems);
  }

  _addList() {
    Get.to(AggiungiListaPage());
  }
}
