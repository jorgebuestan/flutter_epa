

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:styled_text/styled_text.dart';

import '../backend/data_init.dart';
import '../backend/orden.dart';

class SearchOrdenesDelegate extends SearchDelegate{

  List<Orden> _filtroOrdenes = [];

  @override
  String get searchFieldLabel => 'Buscar Orden...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    //throw UnimplementedError();
    return [
      IconButton(
          onPressed: (){
            query = '';
          },
          icon: Icon(Icons.close)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    //throw UnimplementedError();
    return IconButton(
        onPressed: (){
          close(context, const Text(""));
        },
        icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    //throw UnimplementedError();
    return SingleChildScrollView(
        child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                  key: PageStorageKey<String>('pageTwo'),
                  shrinkWrap:true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _filtroOrdenes.length,
                  itemBuilder: (context,index){
                    final Orden = _filtroOrdenes[index];

                    int numero_cuentas=0;
                    int cuentas_hechas=0;
                    double percent_indicator=0.0;
                    String porcentaje="";
                    int percent_indicatorInt=0;
                    for (var cuenta in Orden.cuentasOrdenes) {
                      //print(age);
                      numero_cuentas++;
                      if(cuenta.completado == 1){
                        cuentas_hechas++;
                      }
                    }
                    if(Orden.cuentasOrdenes.length>0){
                      if(cuentas_hechas>0){
                        percent_indicator = cuentas_hechas/numero_cuentas;
                        percent_indicatorInt = (percent_indicator*100).toInt();
                      }
                    }
                    porcentaje = (percent_indicatorInt).toString()+" %";

                    Color? colores;
                    percent_indicator != 1 ? colores = Colors.white: colores = Colors.cyan[300];

                    return Card(
                      color: colores,
                      margin: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigator.pushNamed(context,"/mapaOrdenes", arguments: Orden);
                          Navigator.pushNamed(context,"/cuentasOrden",arguments:Orden);
                        },
                        child:  Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              child:
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "  Orden: "+ Orden.secuencial_orden,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                ),
                              ),
                            ),
                            Row(
                                children: <Widget>[
                                  Column(
                                      children: <Widget>[

                                        Container(
                                          width: 250,
                                          child:
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                            StyledText(
                                              text: '<b>  Sistema: </b> <t>'+ Orden.sistema+'<t/>',
                                              tags: {
                                                'b': StyledTextTag(
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                                                't': StyledTextTag(
                                                    style: const TextStyle(fontSize: 14.0)),
                                              },
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 250,
                                          child:
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                            StyledText(
                                              text: '<b>  Fecha: </b> <t>'+ Orden.fechaOrden +'<t/>',
                                              tags: {
                                                'b': StyledTextTag(
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                                                't': StyledTextTag(
                                                    style: const TextStyle(fontSize: 14.0)),
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 250,
                                          child:
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                            StyledText(
                                              text: '<b>  Número de Cuentas: </b> <t>'+ Orden.cuentasHechas.toString() + " / " + Orden.numero_cuentas.toString()+'<t/>',
                                              tags: {
                                                'b': StyledTextTag(
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                                                't': StyledTextTag(
                                                    style: const TextStyle(fontSize: 14.0)),
                                              },
                                            ),
                                          ),
                                        ),
                                      ]
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.blue,
                                      width: 50,
                                    ),
                                  ),
                                  Column(
                                      children: <Widget>[
                                        CircularPercentIndicator(
                                          radius: 50.0,
                                          lineWidth: 8.0,
                                          animation: true,
                                          percent: percent_indicator,
                                          center: Text(
                                            porcentaje,
                                            style:
                                            TextStyle(fontWeight: FontWeight.bold, fontSize: 8.0),
                                          ),
                                          /* footer: const Text(
                                    "% Cumplimiento",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                                  ), */
                                          circularStrokeCap: CircularStrokeCap.round,
                                          progressColor: Colors.blue,
                                        ),
                                      ]
                                  ),

                                  Column(
                                      children: const <Widget>[
                                        Text("   "),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]
                                  )
                                ]
                            ),
                            const SizedBox(
                              width: 100,
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ]
        )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    //throw UnimplementedError();
    _filtroOrdenes = ordenes.where((orden) {
      return orden.secuencial_orden.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
    return SingleChildScrollView(
        child: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
              key: PageStorageKey<String>('pageTwo'),
              shrinkWrap:true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _filtroOrdenes.length,
              itemBuilder: (context,index){
                final Orden = _filtroOrdenes[index];

                int numero_cuentas=0;
                int cuentas_hechas=0;
                double percent_indicator=0.0;
                String porcentaje="";
                int percent_indicatorInt=0;
                for (var cuenta in Orden.cuentasOrdenes) {
                  //print(age);
                  numero_cuentas++;
                  if(cuenta.completado == 1){
                    cuentas_hechas++;
                  }
                }
                if(Orden.cuentasOrdenes.length>0){
                  if(cuentas_hechas>0){
                    percent_indicator = cuentas_hechas/numero_cuentas;
                    percent_indicatorInt = (percent_indicator*100).toInt();
                  }
                }
                porcentaje = (percent_indicatorInt).toString()+" %";

                Color? colores;
                percent_indicator != 1 ? colores = Colors.white: colores = Colors.cyan[300];

                return Card(
                  color: colores,
                  margin: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context,"/mapaOrdenes", arguments: Orden);
                      Navigator.pushNamed(context,"/cuentasOrden",arguments:Orden);
                    },
                    child:  Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          child:
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "  Orden: "+ Orden.secuencial_orden,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                          ),
                        ),
                        Row(
                            children: <Widget>[
                              Column(
                                  children: <Widget>[

                                    Container(
                                      width: 250,
                                      child:
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child:
                                        StyledText(
                                          text: '<b>  Sistema: </b> <t>'+ Orden.sistema+'<t/>',
                                          tags: {
                                            'b': StyledTextTag(
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                                            't': StyledTextTag(
                                                style: const TextStyle(fontSize: 14.0)),
                                          },
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 250,
                                      child:
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child:
                                        StyledText(
                                          text: '<b>  Fecha: </b> <t>'+ Orden.fechaOrden +'<t/>',
                                          tags: {
                                            'b': StyledTextTag(
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                                            't': StyledTextTag(
                                                style: const TextStyle(fontSize: 14.0)),
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 250,
                                      child:
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child:
                                        StyledText(
                                          text: '<b>  Número de Cuentas: </b> <t>'+ Orden.cuentasHechas.toString() + " / " + Orden.numero_cuentas.toString()+'<t/>',
                                          tags: {
                                            'b': StyledTextTag(
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                                            't': StyledTextTag(
                                                style: const TextStyle(fontSize: 14.0)),
                                          },
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.blue,
                                  width: 50,
                                ),
                              ),
                              Column(
                                  children: <Widget>[
                                    CircularPercentIndicator(
                                      radius: 50.0,
                                      lineWidth: 8.0,
                                      animation: true,
                                      percent: percent_indicator,
                                      center: Text(
                                        porcentaje,
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold, fontSize: 8.0),
                                      ),
                                      /* footer: const Text(
                                    "% Cumplimiento",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                                  ), */
                                      circularStrokeCap: CircularStrokeCap.round,
                                      progressColor: Colors.blue,
                                    ),
                                  ]
                              ),

                              Column(
                                  children: const <Widget>[
                                    Text("   "),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]
                              )
                            ]
                        ),
                        const SizedBox(
                          width: 100,
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              })
    ]
    )
    );
  }
  
}