import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_expense/model/lista_spesa.dart';
import 'package:in_expense/model/prodotto.dart';
import 'package:in_expense/model/user.dart';
import 'package:in_expense/page/dettagli_partecipanti.dart';
import 'package:in_expense/page/scelta_prodotto.dart';
import 'package:pie_chart/pie_chart.dart';

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

    return Scaffold(
      appBar: AppBar(
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
                  "Partecipants",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                  color: Colors.grey,
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(PartecipantsDetails(users: listaSpesa.partecipanti));
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
                      onPressed: () => Get.to(
                          PartecipantsDetails(users: listaSpesa.partecipanti)),
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
                  (prodotto) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(prodotto.nome),
                          Container(
                            child: Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.remove), onPressed: null),
                                IconButton(
                                    icon: Icon(Icons.check), onPressed: null)
                              ],
                            ),
                          )
                        ],
                      )),
                )
                .toList(),
          )
        ],
      ),
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
}
