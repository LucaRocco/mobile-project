import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/component/product_scroller.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/page/aggiungi_lista.dart';
import 'package:in_expense/page/aggiungi_prodotto.dart';
import 'package:in_expense/page/dettagli_lista.dart';
import 'package:in_expense/page/profilo.dart';
import 'package:in_expense/service/lists_service.dart';

class ListScroller extends StatefulWidget {
  @override
  _ListScrollerState createState() => _ListScrollerState();
}

class _ListScrollerState extends State<ListScroller> {
  final ProductsScroller productScroller = ProductsScroller();
  ListsService listsService = GetIt.I<ListsService>();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  List<ListaSpesa> responseList;
  bool isSwitched = false;

  Future<Widget> getPostsData() async {
    responseList = await listsService.getLists();
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
                            "${list.numeroProdotti} prodotti",
                            style: const TextStyle(
                                fontSize: 17, color: Colors.grey),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "${list.numeroPartecipanti} partecipanti",
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
        controller: controller,
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          double scale = 1.0;
          if (topContainer > 0.5) {
            scale = index + 0.5 - topContainer;
            if (scale < 0) {
              scale = 0;
            } else if (scale > 1) {
              scale = 1;
            }
          }
          return GestureDetector(
            onTap: () {
              Get.to(ListDetailPage(
                listaSpesa: responseList[index],
              ));
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

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      double value = controller.offset / 119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 5;
      });
    });
  }

  Widget data;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
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
                        closeTopContainer
                            ? AppLocalizations.of(context)
                                .translate("lista_scroller")
                            : AppLocalizations.of(context)
                                .translate("prodotto_scroller"),
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: closeTopContainer ? _addList : _addProduct,
                    )
                  ],
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: closeTopContainer ? 0 : 1,
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: size.width,
                      alignment: Alignment.topCenter,
                      height: closeTopContainer ? 0 : categoryHeight,
                      child: productScroller),
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
          drawer: Drawer(
            child: ListView(children: [
              Container(
                height: 1000,
                color: Colors.grey[300],
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 16)),
                    Text('Menù',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    TextButton.icon(
                        onPressed: () {
                          Get.to(ProfiloPage());
                        },
                        icon: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        label: Text("Profilo",
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(5)),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.person_add,
                          color: Colors.black,
                        ),
                        label: Text("Amici",
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(5)),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        label: Text("Logout",
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(5)),
                    FlatButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text("Dark Theme",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber))),
                            Switch(
                              value: isSwitched,
                              onChanged: _onChanged,
                              activeTrackColor: Colors.amber,
                              activeColor: Colors.amber,
                            )
                          ]),
                      onPressed: () {
                        themeSwitch(context);
                      },
                    )
                  ],
                ),
              ),
            ]),
          ),
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

  void _onChanged(value) {
    setState(() {
      isSwitched = value;
    });
  }
}
