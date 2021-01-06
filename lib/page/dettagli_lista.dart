import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/constant/application_constants.dart';
import 'package:in_expense/internationalization/app_localizations.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/model/prodotto.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/page/dettagli_partecipanti.dart';
import 'package:in_expense/page/scegli_partecipanti.dart';
import 'package:in_expense/page/scelta_prodotto.dart';
import 'package:in_expense/service/lists_service.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListDetailPage extends StatefulWidget {
  ListDetailPage({this.listaSpesa});

  final ListaSpesa listaSpesa;

  @override
  _ListDetailPageState createState() =>
      _ListDetailPageState(listaSpesa: listaSpesa);
}

class _ListDetailPageState extends State<ListDetailPage> {
  _ListDetailPageState({this.listaSpesa});

  ListaSpesa listaSpesa;
  ListsService listsService = GetIt.I<ListsService>();
  bool isLoading = false;
  int idToRemove = -1;
  Timer timer;
  bool needRefresh = true;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _updateList();
    });
    super.initState();
  }

  List<Color> chartColors = [];
  Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    chartColors = [];
    sortProducts();
    dataMap = _generateMapOfCategory(context);
    var color;
    listaSpesa.prodotti.forEach((element) {
      color = ApplicationConstants.category2color[element.categoria];
      if (!chartColors.contains(color)) chartColors.add(color);
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            timer.cancel();
            Get.back(result: listaSpesa);
          },
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.delete,
                color: Colors.black,
              ))
        ],
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.deepOrange),
        title: Center(
            child: Padding(
                padding: EdgeInsets.only(right: 30),
                child: Text(listaSpesa.nome,
                    style: TextStyle(color: Colors.black)))),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 4,
            child: ListView(
              children: [
                SizedBox(
                  height: 0,
                ),
                dataMap.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("spazio_bianco_grafico"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      )
                    : PieChart(
                        dataMap: dataMap,
                        centerText:
                            "TOT:\n ${listaSpesa.prodotti.map((e) => e.prezzo != null ? e.prezzo : 0).fold(0, (p, c) => p + c)} €",
                        animationDuration: Duration(milliseconds: 1000),
                        chartLegendSpacing: 60,
                        chartRadius: MediaQuery.of(context).size.width / 2.5,
                        colorList: chartColors,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 10,
                        formatChartValues: (value) => "$value €",
                        legendOptions: LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: false,
                          showChartValuesOutside: false,
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate("partecipanti")
                      .capitalizeFirst,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16 / MediaQuery.of(context).textScaleFactor),
                ),
                listaSpesa.creatorId == listaSpesa.userId
                    ? IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          setState(() {
                            this.needRefresh = false;
                          });
                          var result = await Get.to(
                            AddParticipantPage(
                              lista: listaSpesa,
                            ),
                          );
                          if (result != null)
                            setState(() {
                              this.listaSpesa.partecipanti = result;
                              this.needRefresh = true;
                            });
                        },
                        color: Colors.grey,
                      )
                    : Text("")
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _openParticipantsDetails();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 18,
                  child: Stack(
                    children: getPartecipants(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        _openParticipantsDetails();
                      },
                      child: Text(
                        AppLocalizations.of(context).translate("di_piu"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize:
                                14 / MediaQuery.of(context).textScaleFactor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate("prodotti")
                      .capitalizeFirst,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16 / MediaQuery.of(context).textScaleFactor),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    this.setState(() {
                      this.needRefresh = false;
                    });
                    List<Prodotto> prodottiAggiornati =
                        await Get.to(ProductChoosePage(
                      listaId: listaSpesa.id,
                      productsAlreadyPresent: listaSpesa.prodotti == null
                          ? List<Prodotto>()
                          : listaSpesa.prodotti,
                    ));
                    if (prodottiAggiornati != null) {
                      this.setState(() {
                        this.needRefresh = true;
                        this.listaSpesa.prodotti = prodottiAggiornati;
                        this.listaSpesa.numeroProdotti =
                            prodottiAggiornati.length;
                        this.chartColors = [];
                        this.dataMap = null;
                      });
                    }
                  },
                  color: Colors.grey,
                )
              ],
            ),
          ),
          Column(
            children: listaSpesa.prodotti
                .map(
                  (prodotto) => Card(
                    color: Colors.transparent,
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    margin: new EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 6.0),
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: ApplicationConstants
                            .category2color[prodotto.categoria],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        leading: Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.black))),
                          child: ApplicationConstants
                              .category2image[prodotto.categoria],
                        ),
                        title: prodotto.utenteAcquisto != null
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.width / 40),
                                child: Text(
                                  prodotto.nome,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16 /
                                          MediaQuery.of(context)
                                              .textScaleFactor),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  prodotto.nome,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16 /
                                          MediaQuery.of(context)
                                              .textScaleFactor),
                                ),
                              ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "${AppLocalizations.of(context).translate("quantita")}: ${prodotto.quantita}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14 /
                                        MediaQuery.of(context)
                                            .textScaleFactor)),
                            prodotto.dataAcquisto != null
                                ? Row(children: [
                                    Text("Aquistato da ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12 /
                                                MediaQuery.of(context)
                                                    .textScaleFactor)),
                                    Text("${prodotto.utenteAcquisto.nome}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12 /
                                                MediaQuery.of(context)
                                                    .textScaleFactor)),
                                    Text(", ${prodotto.prezzo} €",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12 /
                                                MediaQuery.of(context)
                                                    .textScaleFactor)),
                                  ])
                                : Container(
                                    height: 0,
                                    width: 0,
                                  )
                          ],
                        ),
                        trailing: Container(
                          color: Colors.transparent,
                          height: 40,
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              (isLoading && prodotto.id == idToRemove)
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: CircularProgressIndicator()))
                                  : SizedBox(
                                      width: 25,
                                      height: 50,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                        iconSize: 25,
                                        onPressed: () {
                                          _onRemoveProductPressed(prodotto.id);
                                        },
                                      ),
                                    ),
                              SizedBox(
                                width: 25,
                                height: 50,
                                child: IconButton(
                                  icon: Icon(prodotto.dataAcquisto != null
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank),
                                  onPressed: () async {
                                    setState(() {
                                      this.needRefresh = false;
                                    });
                                    var prezzo = "0.0";
                                    if (prodotto.dataAcquisto == null) {
                                      prezzo = await Get.bottomSheet(
                                          this.bottomSheet());
                                    }
                                    buildShowDialog(context);
                                    var prodottiAggiornati =
                                        await listsService.changeProductStatus(
                                            prodotto.id,
                                            listaSpesa.id,
                                            double.parse(prezzo));
                                    this.setState(() {
                                      listaSpesa.prodotti = prodottiAggiornati;
                                    });
                                    Get.close(1);
                                    this.setState(() {
                                      this.needRefresh = true;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
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

  Map<String, double> _generateMapOfCategory(context) {
    List<Prodotto> prodotti = listaSpesa.prodotti;
    Map<String, double> result = Map<String, double>();
    for (Prodotto p in prodotti) {
      String categoria = AppLocalizations.of(context).translate(p.categoria);
      if (result.containsKey(categoria)) {
        result.update(
            categoria, (value) => value + (p.prezzo != null ? p.prezzo : 0));
      } else {
        result.putIfAbsent(categoria, () => p.prezzo != null ? p.prezzo : 0);
      }
    }
    return result;
  }

  List<Widget> getPartecipants() {
    var partecipanti = listaSpesa.partecipanti;
    if (listaSpesa.partecipanti.length > 5) {
      List<Widget> partecipantiWidget = List<Widget>();
      for (User user in partecipanti.getRange(0, 5)) {
        partecipantiWidget.add(Padding(
          padding: EdgeInsets.only(
            left: (30 * listaSpesa.partecipanti.indexOf(user).toDouble()),
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(user.image),
            backgroundColor: Colors.black,
          ),
        ));
      }
      return partecipantiWidget;
    }
    return listaSpesa.partecipanti
        .map(
          (user) => Padding(
            padding: EdgeInsets.only(
                left: (30 * listaSpesa.partecipanti.indexOf(user).toDouble())),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.image),
              backgroundColor: Colors.black,
            ),
          ),
        )
        .toList();
  }

  void _onRemoveProductPressed(idProdotto) async {
    this.setState(() {
      isLoading = true;
      idToRemove = idProdotto;
      this.needRefresh = false;
    });
    List<Prodotto> prodotti =
        await listsService.deleteProductFromList(listaSpesa.id, idProdotto);
    this.setState(() {
      isLoading = false;
      idToRemove = -1;
      this.listaSpesa.prodotti = prodotti;
    });
    this.setState(() {
      this.needRefresh = true;
      this.chartColors = [];
      this.dataMap = null;
    });
  }

  void _openParticipantsDetails() async {
    this.setState(() {
      this.needRefresh = false;
    });
    List<User> participants = await Get.to(ParticipantsDetails(
        users: listaSpesa.partecipanti,
        email: (await SharedPreferences.getInstance()).getString("email"),
        lista: listaSpesa));
    listaSpesa.partecipanti = participants;
    this.setState(() {
      this.needRefresh = true;
    });
  }

  void _updateList() async {
    if (needRefresh) {
      ListaSpesa ls = await listsService.getListById(this.listaSpesa.id);
      this.setState(() {
        this.listaSpesa = ls;
      });
      print("Refreshed List");
    }
  }

  void sortProducts() {
    List<Prodotto> completedProduct = List<Prodotto>();
    List<Prodotto> uncompletedProduct = List<Prodotto>();

    List<Prodotto> prodotti = List<Prodotto>();
    prodotti.addAll(listaSpesa.prodotti);
    prodotti.removeWhere((element) => element.dataAcquisto == null);
    completedProduct = prodotti;

    prodotti = List<Prodotto>();
    prodotti.addAll(listaSpesa.prodotti);
    prodotti.removeWhere((element) => element.dataAcquisto != null);
    uncompletedProduct = prodotti;

    completedProduct.sort((a, b) => a.categoria.compareTo(b.categoria));
    uncompletedProduct.sort((a, b) => a.categoria.compareTo(b.categoria));

    prodotti = List<Prodotto>();
    prodotti.addAll(uncompletedProduct);
    prodotti.addAll(completedProduct);

    listaSpesa.prodotti = prodotti;
  }

  Widget bottomSheet() {
    TextEditingController prezzoController = TextEditingController();
    return Container(
      height: 250,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          Text(
            "Se hai speso denaro per questo prodotto riportalo qui. \n"
            "Alla fine potrete fare i conti più facilmente",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18 / MediaQuery.of(context).textScaleFactor),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                child: TextFormField(
                  controller: prezzoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: AppLocalizations.of(context).translate("prezzo"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: ClipOval(
                  child: Material(
                    color: Colors.deepOrange,
                    child: InkWell(
                      splashColor: Colors.blue,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Icon(Icons.arrow_forward),
                      ),
                      onTap: () {
                        Get.back(result: prezzoController.text);
                      },
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
