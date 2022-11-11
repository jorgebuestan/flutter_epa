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

class MapsPage extends StatefulWidget {
  ServerController serverController;
  BuildContext context;

  MapsPage(this.serverController, this.context, {Key? key, required this.title}) : super(key: key);

  final String title;



  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {

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

    return ChangeNotifierProvider(
        create: (_) => DirectionProvider(),
    child: Scaffold(
      appBar: AppBar(
          title: Text("EpaMovil"),
          actions: [
            Image.asset(
              "assets/images/logo_epa.png",
              fit: BoxFit.contain,
              height: 15,
            ),
          ]
      ),
      drawer: MenuDesplegable(
        serverController: widget.serverController,
      ),
      body:  Center(
        child: SingleChildScrollView(
          child: Column(
            children:const <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                "Seleccionar una Orden de Trabajo para ver las Rutas",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
              SizedBox(
                height: 10,
              ),
              ListaUsuarios()
            ],
          ),
        ) ,
      ),
      bottomNavigationBar: FooterEpa(serverController: widget.serverController,),
    ),);
  }

}

class ListaUsuarios extends StatefulWidget {
  const ListaUsuarios({Key? key}) : super(key: key);


  @override
  _MiLista createState() => _MiLista();

}

class _MiLista extends State<ListaUsuarios> {

  List<Medicion> listaMediciones = [];
  List listaItems = [];
  List listaUsuarios = [];
  String _mensaje="";

  @override
  void initState() {

    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return   ListView.builder(
        key: PageStorageKey<String>('pageTwo'),
        shrinkWrap:true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: ordenes.length,
        itemBuilder: (context,index){
          final Orden = ordenes[index];

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
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
            ),
            child: InkWell(
              onTap: () {
                print("Numero de Cuentas");
                print(Orden.numero_cuentas);
                print("Progreso");
                print(Orden.progreso);
                if(Orden.progreso!=100.0){
                  Navigator.pushNamed(context,"/mapaOrdenes", arguments: Orden);
                }else{
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text("La Orden ya no tiene Cuentas pendientes por Registrar"),
                        actions: [
                          TextButton(child: Text('Aceptar'),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ));
                }

              },
              child:  Column(
              children: <Widget>[
                //Text(Orden.secuencial_orden,style: TextStyle(fontSize: 16),),
                Text(
                  "Orden: "+ Orden.secuencial_orden,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                ListTile(
                  title:
                  Text(
                      "Sistema: "+ Orden.sistema,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            ),
          );
        });
  }
}