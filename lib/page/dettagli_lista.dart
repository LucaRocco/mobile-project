import 'package:flutter/material.dart';
import 'package:in_expense/model/lista_spesa.dart';
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
    Map<String, double> dataMap = {
      "Alimentari": 5,
      "Casa": 3,
      "Elettrodomestici": 2,
      "Altro": 2,
    };
    List<Color> colors = [
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.red,
      Colors.teal,
      Colors.grey
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.green),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      listaSpesa.nome,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                PieChart(
                  dataMap: dataMap,
                  animationDuration: Duration(milliseconds: 1000),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  colorList: colors,
                  initialAngleInDegree: 0,
                  chartType: ChartType.disc,
                  ringStrokeWidth: 7,
                  centerText: "Spesa",
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
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Partecipanti",
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
          Container(
            height: MediaQuery.of(context).size.height / 18,
            child: Stack(
              children: listaSpesa.partecipanti
                  .map(
                    (user) => Padding(
                      padding: EdgeInsets.only(left: (15 * listaSpesa.partecipanti.indexOf(user).toDouble())),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user.image),
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ).toList(),
            ),
          )
        ],
      ),
    );
  }
}
