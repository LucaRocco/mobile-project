import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/model/prodotto.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/page/dettagli_partecipanti.dart';
import 'package:in_expense/page/scegli_partecipanti.dart';
import 'package:in_expense/page/scelta_prodotto.dart';
import 'package:in_expense/service/lists_service.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*classe per i "DETTAGLI LISTA" ovvero quando sarà aperta una determinata lista saranno visibili i vari dettagli come:
 -nome lista
 -supermercati consigliati(a cui affiancheremo la possibilità di accedere alle mappe)
 -partecipanti alla lista
 -prodotti della lista
 -la possibilità di condividere l'indirizzo della schermata
 -un bottone per aggiungere dei prodotti alla lista
 */

class ListDetailPage extends StatefulWidget {
  ListDetailPage({this.listaSpesa});

  final ListaSpesa listaSpesa;

  @override
  _ListDetailPageState createState() =>
      _ListDetailPageState(listaSpesa: listaSpesa);
}

class _ListDetailPageState extends State<ListDetailPage> {
  _ListDetailPageState({this.listaSpesa});

  final ListaSpesa listaSpesa;
  ListsService listsService = GetIt.I<ListsService>();
  bool isLoading = false;
  int idToRemove = -1;

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = _generateMapOfCategory();
    List<Color> colors = [
      Colors.deepOrange,
      Colors.blue,
      Colors.yellow,
      Colors.red,
      Colors.teal,
      Colors.grey
    ];

    Map<String, Widget> category2image = {
      'Alimenti': Image.asset('assets/images/category_eat.png'),
      'Utilita': Image.asset('assets/images/category_utility.png'),
      'Bevande': Image.asset('assets/images/category_drink.png'),
      'Casa': Icon(Icons.home, color: Colors.black, size: 40,),
      'Benessere': Image.asset('assets/images/category_healthy.png')
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: listaSpesa);
          },
        ),
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.deepOrange),
        title: Center(
            child: Padding(
                padding: EdgeInsets.only(right: 60),
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
                  height: 20,
                ),
                dataMap.isEmpty
                    ? Center(
                        child: Text(
                          "Sembra non esserci niente in questa lista.\n"
                          "In questo spazio troverai un grafico che ti aiuterà a tenere sotto controllo i prodotti.\n"
                          "Prova ad aggiungere qualche prodotto",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      )
                    : PieChart(
                        dataMap: dataMap,
                        animationDuration: Duration(milliseconds: 1000),
                        chartLegendSpacing: 32,
                        chartRadius: MediaQuery.of(context).size.width / 3.2,
                        colorList: colors,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 7,
                        formatChartValues: (value) =>
                            "$value".replaceAll(".0", ""),
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
                  "Partecipants",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    var result = await Get.to(
                      AddParticipantPage(
                        lista: listaSpesa,
                      ),
                    );
                    if (result != null)
                      setState(() {
                        this.listaSpesa.partecipanti = result;
                      });
                  },
                  color: Colors.grey,
                )
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
                        "MORE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
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
                  "Products",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Get.to(ProductChoosePage(
                      listaId: listaSpesa.id,
                      productsAlreadyPresent: listaSpesa.prodotti == null
                          ? List<Prodotto>()
                          : listaSpesa.prodotti,
                    ));
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
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          height: 40,
                          width: 70,
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.black))),
                          child: category2image[prodotto.categoria],
                        ),
                        title: Text(
                          prodotto.nome,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: Row(
                          children: <Widget>[
                            Text("Quantità: ${prodotto.quantita}",
                                style: TextStyle(color: Colors.black))
                          ],
                        ),
                        trailing: Container(
                          height: 100,
                          width: 100,
                          child: Row(
                            children: [
                              (isLoading && prodotto.id == idToRemove)
                                  ? Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator()))
                                  : IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                      ),
                                      iconSize: 20,
                                      onPressed: () {
                                        _onRemoveProductPressed(prodotto.id);
                                      }),
                              IconButton(
                                  icon: Icon(prodotto.dataAcquisto != null
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank),
                                  onPressed: () async {
                                    buildShowDialog(context);
                                    var prodottiAggiornati =
                                        await listsService.changeProductStatus(
                                            prodotto.id, listaSpesa.id);
                                    this.setState(() {
                                      listaSpesa.prodotti = prodottiAggiornati;
                                    });
                                    Get.close(1);
                                  })
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

  Map<String, double> _generateMapOfCategory() {
    List<Prodotto> prodotti = listaSpesa.prodotti;
    Map<String, double> result = Map<String, double>();
    for (Prodotto p in prodotti) {
      if (result.containsKey(p.categoria)) {
        result.update(p.categoria, (value) => value + 1);
      } else {
        result.putIfAbsent(p.categoria, () => 1);
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

  _onRemoveProductPressed(idProdotto) async {
    this.setState(() {
      isLoading = true;
      idToRemove = idProdotto;
    });
    print("ProdottoDaRimuovere: $idProdotto");
    List<Prodotto> prodotti =
        await listsService.deleteProductFromList(listaSpesa.id, idProdotto);
    this.setState(() {
      isLoading = false;
      idToRemove = -1;
      this.listaSpesa.prodotti = prodotti;
    });
  }

  _openParticipantsDetails() async {
    List<User> participants = await Get.to(ParticipantsDetails(
      users: listaSpesa.partecipanti,
      email: (await SharedPreferences.getInstance()).getString("email"),
      lista: listaSpesa,
    ));
    listaSpesa.partecipanti = participants;
    this.setState(() {});
  }
}
