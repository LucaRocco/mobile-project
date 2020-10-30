import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/component/product_scroller.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/page/aggiungi_lista.dart';
import 'package:in_expense/page/aggiungi_prodotto.dart';
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

  Future<Widget> getPostsData() async {
    List<ListaSpesa> responseList = await listsService.getLists();
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(Container(
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
                        post.nome,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        post.descrizione,
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
                            "${post.numeroProdotti} prodotti",
                            style: const TextStyle(
                                fontSize: 17, color: Colors.grey),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "${post.numeroPartecipanti} partecipanti",
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
          )));
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
          return Opacity(
            opacity: scale,
            child: Transform(
              transform: Matrix4.identity()..scale(scale, scale),
              alignment: Alignment.bottomCenter,
              child: Align(
                  heightFactor: 0.7,
                  alignment: Alignment.topCenter,
                  child: listItems[index]),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset / 119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 5;
      });
    });
  }

  bool dataAlreadyFetched = false;
  Widget data;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.person, color: Colors.black),
              onPressed: () {},
            )
          ],
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
                      closeTopContainer ? "Le tue liste" : "I tuoi prodotti",
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
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          data = snapshot.data;
                          return data;
                        } else {
                          return CircularProgressIndicator();
                        }
                      })
                  : data,
            ],
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
}
