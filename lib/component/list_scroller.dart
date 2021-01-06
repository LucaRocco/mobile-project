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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcaseview.dart';

class ListScroller extends StatefulWidget {
  @override
  _ListScrollerState createState() => _ListScrollerState();
}

class _ListScrollerState extends State<ListScroller> {
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();

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
    if (false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ShowCaseWidget.of(context).startShowCase([_one]);
      });
    }
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
                        child: Showcase(
                          key: _one,
                          title: "I tuoi prodotti",
                          description:
                              "Qui troverai l'elenco di tutti i tuoi prodotti e cliccando su 'I tuoi prodotti' potrai accedere alla lista completa",
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("prodotto_scroller"),
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20 /
                                    MediaQuery.of(context).textScaleFactor),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          this.needRefresh = false;
                          await Get.to(ProductAddPage(
                            title: "testo_nuovo_prodotto",
                          ));
                          setState(() {
                            productWidget = null;
                          });
                          this.needRefresh = true;
                        },
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
                                    vertical: 10, horizontal: 20),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      productWidget == null
                                          ? FutureBuilder(
                                              future: getSummaryProductCards(
                                                  context),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.hasData) {
                                                  this.productWidget =
                                                      snapshot.data;
                                                  return snapshot.data;
                                                } else {
                                                  return Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .height *
                                                                0.27 -
                                                            50,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate("liste_product_scroller"),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20 /
                                            MediaQuery.of(context)
                                                .textScaleFactor),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () async {
                                        await Get.to(AggiungiListaPage());
                                        this.data = null;
                                        setState(() {});
                                      })
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
      ),
    );
  }

  void themeSwitch(context) {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  Future<Widget> getPostsData({List<ListaSpesa> listeSpesa}) async {
    var textScale = MediaQuery.of(context).textScaleFactor;
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
                        style: TextStyle(
                            fontSize: 24 / textScale,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        list.descrizione,
                        style: TextStyle(
                            fontSize: 16 / textScale, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "${list.prodotti.length} ${prefs.getString("locale") == "it" ? "prodotti" : "products"}",
                            style: TextStyle(
                                fontSize: 16 / textScale, color: Colors.grey),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "${list.partecipanti.length} ${prefs.getString("locale") == "it" ? "partecipanti" : "participants"}",
                              style: TextStyle(
                                  fontSize: 14 / textScale, color: Colors.grey),
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
    var textScale = MediaQuery.of(context).textScaleFactor;
    List<Prodotto> responseList = await productService.getProdotti();
    List<Widget> listItems = [];

    responseList.sort((a, b) => a.nome.compareTo(b.nome));
    final double productHeight = MediaQuery.of(context).size.height * 0.27 - 50;
    responseList.forEach(
      (element) {
        listItems.add(
          Container(
            width: 150,
            margin: EdgeInsets.only(right: 10),
            height: productHeight,
            decoration: BoxDecoration(
                color: ApplicationConstants.category2color[element.categoria],
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 6.0, left: 12.0, bottom: 6.0, right: 6.0),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            element.nome,
                            style: TextStyle(
                                fontSize: 25 / textScale,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate(element.categoria),
                          style: TextStyle(
                              fontSize: 16 / textScale, color: Colors.white),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 40,
                                    child: IconButton(
                                      icon: Icon(Icons.mode_edit),
                                      onPressed: () async {
                                        this.setState(() {
                                          this.needRefresh = false;
                                        });
                                        await Get.to(
                                          ProductAddPage(
                                            title: "testo_modifica_prodotto",
                                            prodotto: element,
                                          ),
                                        );
                                        this.productWidget = null;
                                        this.setState(() {
                                          this.needRefresh = true;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    width: 30,
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        buildShowDialog(context);
                                        await productService.removeProduct(
                                            id: element.id);
                                        var newData = await this.getPostsData();
                                        var newProductWidget =
                                            await getSummaryProductCards(
                                                context);
                                        Get.close(1);
                                        this.setState(() {
                                          this.data = newData;
                                          this.productWidget = newProductWidget;
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18 / MediaQuery.of(context).textScaleFactor),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize:
                                18 / MediaQuery.of(context).textScaleFactor),
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
    if (needRefresh) {
      var newData = await getPostsData();
      this.setState(() {
        data = newData;
      });
      print("Refreshed");
    }
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
