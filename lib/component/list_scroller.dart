import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/component/drawer.dart';
import 'package:in_expense/component/product_scroller.dart';
import 'package:in_expense/constant/application_constants.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/model/prodotto.dart';
import 'package:in_expense/page/aggiungi_lista.dart';
import 'package:in_expense/page/aggiungi_prodotto.dart';
import 'package:in_expense/page/dettagli_lista.dart';
import 'package:in_expense/service/lists_service.dart';
import 'package:in_expense/service/product_service.dart';

class ListScroller extends StatefulWidget {
  @override
  _ListScrollerState createState() => _ListScrollerState();
}

class _ListScrollerState extends State<ListScroller> {
  final ProductsScroller productScroller = ProductsScroller();
  ListsService listsService = GetIt.I<ListsService>();
  ProductService productService = GetIt.I<ProductService>();
  List<ListaSpesa> responseList;
  Widget productWidget;
  Widget data;
  Timer timer;
  bool needRefresh = true;

  @override
  void initState() {
    this.timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _refreshData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double productHeight = size.height * 0.30;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: [Colors.white, Colors.red],
          stops: [0.42, 50],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 25),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate("prodotto_scroller"),
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addProduct,
                    )
                  ],
                ),
                AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: size.width,
                      alignment: Alignment.topCenter,
                      height: productHeight,
                      child: ListView(
                        children: [
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: FittedBox(
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    productWidget == null
                                        ? FutureBuilder(
                                            future:
                                                getSummaryProductCards(context),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              if (snapshot.hasData) {
                                                this.productWidget =
                                                    snapshot.data;
                                                return snapshot.data;
                                              } else {
                                                return Container(
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.27 -
                                                      70,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2 -
                                                              40),
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        : productWidget,
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
                                IconButton(
                                    icon: Icon(Icons.add), onPressed: _addList)
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                data == null
                    ? FutureBuilder(
                        future: getPostsData(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            data = snapshot.data;
                            return data;
                          } else {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      )
                    : data,
              ],
            ),
          ),
          drawer: AppDrawer(),
        ),
      ),
    );
  }

  _addProduct() {
    Get.to(ProductAddPage());
  }

  _addList() {
    Get.to(AggiungiListaPage());
  }

  void themeSwitch(context) {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  Future<Widget> getPostsData({List<ListaSpesa> listeSpesa}) async {
    if (listeSpesa == null) {
      responseList = await listsService.getLists();
    } else {
      responseList = listeSpesa;
    }
    responseList.sort((a, b) => a.id.compareTo(b.id));
    List<Widget> listItems = [];
    responseList.forEach((list) {
      listItems.add(
        Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        list.nome,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        list.descrizione,
                        style:
                            const TextStyle(fontSize: 17, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "${list.prodotti.length} ${AppLocalizations.of(context).translate("prodotti")}",
                            style: const TextStyle(
                                fontSize: 17, color: Colors.grey),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "${list.partecipanti.length} ${AppLocalizations.of(context).translate("partecipanti")}",
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
    return Expanded(
      child: ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              needRefresh = false;
              ListaSpesa result = await Get.to(
                ListDetailPage(
                  listaSpesa: responseList[index].clone(),
                ),
              );
              if (!responseList.contains(result)) {
                responseList.removeWhere((element) => element.id == result.id);
                responseList.add(result);
                data = await getPostsData(listeSpesa: responseList);
                setState(() {});
              }
              needRefresh = true;
            },
            child: Align(
                heightFactor: 0.7,
                alignment: Alignment.topCenter,
                child: listItems[index]),
          );
        },
      ),
    );
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
            onTap: () {},
            child: Container(
              width: 150,
              margin: EdgeInsets.only(right: 20),
              height: productHeight,
              decoration: BoxDecoration(
                  color: ApplicationConstants.getRandomColor(),
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
                            AppLocalizations.of(context)
                                .translate(element.categoria),
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 40,
                                      child: IconButton(
                                        icon: Icon(Icons.mode_edit),
                                        onPressed: () {
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          await productService.removeProduct(
                                              id: element.id);
                                          this.setState(() {
                                            this.data = null;
                                            this.productWidget = null;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
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

  void _refreshData() async {
    if(needRefresh) {
      var newData = await getPostsData();
      this.setState(() {
        data = newData;
      });
      print("Refreshed");
    }
  }
}
