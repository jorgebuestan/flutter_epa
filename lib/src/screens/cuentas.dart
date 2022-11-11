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
import '../components/search_cuentas_delegate.dart';
import '../components/search_ordenes_delegate.dart';

class CuentasOrden extends StatefulWidget {
  ServerController serverController;
  BuildContext context;
  Orden orden;
  final String title;

  CuentasOrden(this.serverController, this.context, {Key? key, required this.orden, required this.title}) : super(key: key);

  @override
  State<CuentasOrden> createState() => _CuentasOrdenState();
}

class _CuentasOrdenState extends State<CuentasOrden> {

  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  final _initialCameraPosition = const CameraPosition(
    target: LatLng(-2.1516057,-79.8645686),
    zoom: 16,
  );



  void _onItemTapped(int index) {

    if(index==0){
      Navigator.pop(context);
      //Navigator.pushReplacementNamed(context, "/home");
    }
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {

    //getLocation();
    widget.orden.cuentasOrdenes;
    widget.orden.cuentasOrdenes.sort((a, b) => a.completado.compareTo(b.completado));

    return ChangeNotifierProvider(
      create: (_) => DirectionProvider(),
      child: Scaffold(
        appBar: AppBar(
            title: //Text("Orden: "+widget.orden.secuencial_orden),
            StyledText(
              text: '<b>ORDEN: '+widget.orden.secuencial_orden+'</b>',
              tags: {
                'b': StyledTextTag(
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              },
            ),
            actions: [
              Image.asset(
                "assets/images/logo_epa.png",
                fit: BoxFit.contain,
                height: 15,
              ),
            ]
        ),
        body: SingleChildScrollView(
      child: Column(
            children: <Widget>[

              const SizedBox(
                height: 10,
              ),
              ListTile(
                tileColor:  Colors.blue.shade100 ,
                title: Text("Buscar Cuenta..."),
                onTap: () {
                  showSearch(context: context, delegate: SearchCuentasDelegate());
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
            key: const PageStorageKey<String>('pageTwo'),
            shrinkWrap:true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.orden.cuentasOrdenes.length,
            itemBuilder: (context,index){
              final Cuenta = widget.orden.cuentasOrdenes[index];
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
                /*  Row(
                  children: <Widget>[
                      Column(
                      children: <Widget>[
                        Container(
                          child:
                          Align(
                            alignment: Alignment.centerLeft,
                            child: StyledText(
                              text: '<b>Cliente: </b> <t>'+Cuenta.nombre_cliente+' </t>',
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
                          child:
                          Align(
                            alignment: Alignment.centerLeft,
                            child: StyledText(
                              text: '<b>Direccion: </b> <t>'+Cuenta.direccion+' </t>',
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
                      Column(
                          children: <Widget>[
                          ]
                      ),
                    ]
                  ), */
                    // Text(Cuenta.numero_cuenta,style: TextStyle(fontSize: 20),),

                    ListTile(
                      title: Text("Cliente: "+Cuenta.nombre_cliente.toString()),
                      subtitle: Text("Direccion: "+Cuenta.direccion.toString()),
                      trailing: MaterialButton(
                        onPressed: () {
                          if(Cuenta.sincronizado == 0){

                            if(Cuenta.sin_lectura==0){
                              Navigator.pushNamed(context,"/editar",arguments: Cuenta);
                            }else{
                              Navigator.pushNamed(context,"/novedad",arguments: Cuenta);
                            }

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
        ),
        ),
        bottomNavigationBar: FooterEpa(serverController: widget.serverController,),
      ),);
  }

}