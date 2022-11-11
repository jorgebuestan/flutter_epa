import 'dart:convert';
import 'dart:io';

import 'package:epa_movil/src/advanced/asset_file.dart';
import 'package:epa_movil/src/backend/medicion.dart';
import 'package:epa_movil/src/backend/user.dart';
import 'package:epa_movil/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:epa_movil/src/connection/db.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../backend/cuenta.dart';
import 'dart:developer' as developer;
import 'package:styled_text/styled_text.dart';

import '../backend/data_init.dart';
import '../backend/orden.dart';
import '../components/delivery_screen.dart';
import '../components/direction_provider.dart';
import '../components/footer.dart';
import '../components/image_picker_widget.dart';
import '../components/menu_desplegable.dart';
import '../components/search_ordenes_delegate.dart';

class SearchCuentasDelegate extends SearchDelegate{

  List<Cuenta> _filtroCuentas = [];

  //@override
  //String get searchFieldLabel => 'Ingrese Cuenta de Usuario - Nombre de Usuario...';

  @override
  TextStyle? get searchFieldStyle => TextStyle(fontSize: 12,);

  @override
  String? get searchFieldLabel => 'Ingrese Cuenta de Usuario - Nombre de Usuario';

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
                  key: const PageStorageKey<String>('pageTwo'),
                  shrinkWrap:true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cuentas.length,
                  itemBuilder: (context,index){
                    final Cuenta = cuentas[index];
                    Color? colores;
                    print("Valor cuenta");
                    print(Cuenta.completado );
                    Cuenta.completado == 0 ? colores = Colors.white: colores = Colors.cyan[300];
                    /* if (widget.orden.cuentasOrdenes[index].completado == 0){
                colores = Colors.transparent;
              }else{
                colores = Colors.blue[200];
              } */ // color: Colors.grey[200],
                    return Card(
                      color: colores,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                              children: <Widget>[
                                const SizedBox(
                                  height: 10,
                                ),
                              ]),
                          Align(
                            alignment: Alignment.center,
                            child: StyledText(
                              text: '<b>Cuenta: </b> <t>'+Cuenta.numero_cuenta+' </t>',
                              tags: {
                                'b': StyledTextTag(
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                                't': StyledTextTag(
                                    style: const TextStyle(fontSize: 18.0)),
                              },
                            ),
                          ),
                          ListTile(
                            title: Text("Cliente: "+Cuenta.nombre_cliente.toString()),
                            subtitle: Text("Direccion: "+Cuenta.direccion.toString()),
                            trailing: MaterialButton(
                                onPressed: () {
                                  if(Cuenta.sincronizado == 0){
                                    Navigator.pushNamed(context,"/editar",arguments: Cuenta);
                                  }
                                },
                                child: Cuenta.sincronizado == 0 ? Column(
                                  children: <Widget>[
                                    Icon(Icons.edit),
                                    Container(
                                      width: 100,
                                      child:
                                      Row(
                                          children: <Widget>[
                                            Text("Sinc: "),
                                            Cuenta.sincronizado == 1
                                                ?  Text("Si"):  Text("No"),
                                          ]),
                                    ),
                                  ],
                                ) : Text("Sincronizado")
                            ),
                            //  tileColor: Colors.blue,
                          ),
                        ],
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
    _filtroCuentas = cuentas.where((cuenta) {
      return (cuenta.nombre_cliente.toLowerCase().contains(query.trim().toLowerCase())||cuenta.numero_cuenta.toLowerCase().contains(query.trim().toLowerCase()));
    }).toList();
    return SingleChildScrollView(
        child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                  key: const PageStorageKey<String>('pageTwo'),
                  shrinkWrap:true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filtroCuentas.length,
                  itemBuilder: (context,index){
                    final Cuenta = _filtroCuentas[index];
                    Color? colores;
                    print("Valor cuenta");
                    print(Cuenta.completado );
                    Cuenta.completado == 0 ? colores = Colors.white: colores = Colors.cyan[300];
                    /* if (widget.orden.cuentasOrdenes[index].completado == 0){
                colores = Colors.transparent;
              }else{
                colores = Colors.blue[200];
              } */ // color: Colors.grey[200],
                    return Card(
                      color: colores,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                              children: <Widget>[
                                const SizedBox(
                                  height: 10,
                                ),
                              ]),
                          Align(
                            alignment: Alignment.center,
                            child: StyledText(
                              text: '<b>Cuenta: </b> <t>'+Cuenta.numero_cuenta+' </t>',
                              tags: {
                                'b': StyledTextTag(
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                                't': StyledTextTag(
                                    style: const TextStyle(fontSize: 18.0)),
                              },
                            ),
                          ),
                          ListTile(
                            title: Text("Cliente: "+Cuenta.nombre_cliente.toString()),
                            subtitle: Text("Direccion: "+Cuenta.direccion.toString()),
                            trailing: MaterialButton(
                                onPressed: () {
                                  if(Cuenta.sincronizado == 0){
                                    Navigator.pushNamed(context,"/editar",arguments: Cuenta);
                                  }
                                },
                                child: Cuenta.sincronizado == 0 ? Column(
                                  children: <Widget>[
                                    Icon(Icons.edit),
                                    Container(
                                      width: 100,
                                      child:
                                      Row(
                                          children: <Widget>[
                                            Text("Sinc: "),
                                            Cuenta.sincronizado == 1
                                                ?  Text("Si"):  Text("No"),
                                          ]),
                                    ),
                                  ],
                                ) : Text("Sincronizado")
                            ),
                            //  tileColor: Colors.blue,
                          ),
                        ],
                      ),
                    );
                  })
            ]
        )
    );
  }

}