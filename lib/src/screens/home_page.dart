import 'dart:convert';
import 'dart:developer';

import 'package:epa_movil/src/advanced/asset_file.dart';
import 'package:epa_movil/src/backend/medicion.dart';
import 'package:epa_movil/src/backend/user.dart';
import 'package:epa_movil/src/backend/usuario_epa.dart';
import 'package:epa_movil/src/components/menu_desplegable.dart';
import 'package:epa_movil/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:epa_movil/src/connection/db.dart';
import 'package:http/http.dart' as http;
import 'package:bcrypt/bcrypt.dart';
import 'package:styled_text/styled_text.dart';

import '../backend/data_init.dart';
import '../backend/orden.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../components/search_cuentas_delegate.dart';
import '../components/search_ordenes_delegate.dart';


class HomePage extends StatefulWidget {

  ServerController serverController;
  BuildContext context;
  HomePage(this.serverController,this.context, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final AssetBundle assetBundle = DefaultAssetBundle.of(context);

    for (int i = 0; i < ordenes.length; i++) {
      print("Numero de cuentas en orden: "+ordenes[i].secuencial_orden);
      print(ordenes[i].cuentasOrdenes.length);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("EpaMovil"),
        /*title:  Image.asset(
          "assets/images/logo_epa.png",
          height: 30,
        ),*/
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
       /* floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.blue),
          onPressed: () {
            Navigator.pushNamed(context,"/editar",arguments: Medicion(id:0,nombre:"",descripcion:"", latitud: 0.0, longitud: 0.0, altitud: 0.0));
          },
        ),*/
      /*body: SingleChildScrollView(
        child: SingleChildScrollView(
            child: ListaUsuarios()
        ),
      ),*/
      body: SingleChildScrollView(
        child: Column(
        children: <Widget>[
          /* ListTile(
            tileColor:  Colors.blue.shade100 ,
            title: Text("Buscar Orden..."),
            onTap: () {
              showSearch(context: context, delegate: SearchOrdenesDelegate());
            },
          ), */
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
          Text(
            "Órdenes de Trabajo Pendientes",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
          ),
          const SizedBox(
            height: 10,
          ),
          //ListaUsuarios(),
          ListaOrdenes(),
        ],
        ),
        ) ,
      bottomNavigationBar: BottomAppBar(
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/gobierno/GobiernoDelEncuentro.png",
                    fit: BoxFit.contain,
                    height: 50,
                    alignment: Alignment.center,
                  ),
                ],
              )))

      /*Center(
          child: ListaUsuarios()
      ),*/
    );
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
    cargaMediciones();

    //recibirString();
    //recibirObjeto();
    //recibirUserEpa();
    //usarBcrypt();
    super.initState();


    //generateOrdenesCuentas();



  }

  cargaMediciones() async {
    List<Medicion> auxMediciones = await DB.mediciones();

    setState(() {
      listaMediciones = auxMediciones;
    });

  }

  @override
  Widget build(BuildContext context) {
    return  ExpansionPanelList(
      expansionCallback: ( int index, bool isExpanded ){
        setState(() {
          ordenes[index].isExpanded = !isExpanded;
        });
      },
      dividerColor: Colors.blue,
      elevation: 4,
      children: ordenes.map<ExpansionPanel>((Orden orden){

        int numero_cuentas=0;
        int cuentas_hechas=0;
        double percent_indicator=0.0;
        String porcentaje="";
        int percent_indicatorInt=0;
        for (var cuenta in orden.cuentasOrdenes) {
          //print(age);
          numero_cuentas++;
          if(cuenta.completado == 1){
            cuentas_hechas++;
          }
        }
        print("Numero Cuentas");
        print(numero_cuentas);
        print("Cuentas hechas");
        print(cuentas_hechas);

        if(orden.cuentasOrdenes.length>0){
          if(cuentas_hechas>0){
            percent_indicator = cuentas_hechas/numero_cuentas;
            percent_indicatorInt = (percent_indicator*100).toInt();
          }
        }
        porcentaje = (percent_indicatorInt).toString()+" %";
        print("Porcentaje");
        print(percent_indicator);
        print("Porcentaje Int");
        print(percent_indicatorInt);

        return  ExpansionPanel(

            headerBuilder: (BuildContext context, bool isExpanded){
              return
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context,"/cuentasOrden",arguments:orden);
                    //Navigator.pushNamed(context,"/home",arguments: serverController.loggedUser);
                  },
                  child:
                Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Orden: "+ orden.secuencial_orden,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      Row(
                        children: <Widget>[
                            Column(
                            children: <Widget>[
                                  StyledText(
                                    text: '<b>  Sistema: </b> <t>'+ orden.sistema+'<t/>',
                                    tags: {
                                      'b': StyledTextTag(
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                                      't': StyledTextTag(
                                          style: const TextStyle(fontSize: 14.0)),
                                    },
                                    textAlign: TextAlign.left,
                                  ) ,
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                  StyledText(
                                    text: '<b>  Número de Cuentas: </b> <t>'+ orden.numero_cuentas.toString()+'<t/>',
                                    tags: {
                                      'b': StyledTextTag(
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                                      't': StyledTextTag(
                                          style: const TextStyle(fontSize: 14.0)),
                                    },
                                  )
                              ),
                            ]
                            ),
                          Expanded(
                            child: Container(
                              color: Colors.amber,
                              width: 170,
                            ),
                          ),
                            Column(
                                children: <Widget>[
                                  CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 5.0,
                                    animation: true,
                                    percent: percent_indicator,
                                    center: Text(
                                      porcentaje,
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold, fontSize: 8.0),
                                    ),
                                    footer: const Text(
                                      "% Cumplimiento",
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.blue,
                                  ),
                                ]
                            )
                        ]
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]
                ),
              );
                /*ListTile(
                title: Text(orden.secuencial_orden + " - " + orden.sistema),
                subtitle: Text("Numero de Cuentas: "+orden.numero_cuentas.toString()),
              );*/
            },
            body:
                  ListView.builder(
                      key: PageStorageKey<String>('pageTwo'),
                      shrinkWrap:true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: orden.cuentasOrdenes.length,
                      itemBuilder: (context,index){
                        final Cuenta = orden.cuentasOrdenes[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(Cuenta.numero_cuenta,style: TextStyle(fontSize: 20),),
                              ListTile(
                                  title: Text("Cliente: "+Cuenta.nombre_cliente.toString()),
                                  subtitle: Text("Direccion: "+Cuenta.direccion.toString()),
                                  trailing: MaterialButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context,"/editar",arguments: Cuenta);
                                    },
                                    child: Column(
                                      children: const <Widget>[
                                        Icon(Icons.edit)
                                      ],
                                    ),
                                  ),
                              ),
                            ],
                          ),
                        );
                      }),
            isExpanded: orden.isExpanded,

        );
      }).toList(),
    ) ;
  }
}



class ListaOrdenes extends StatefulWidget {
  const ListaOrdenes({Key? key}) : super(key: key);


  @override
  _MiListaOrdenes createState() => _MiListaOrdenes();

}

class _MiListaOrdenes extends State<ListaOrdenes> {

  List<Medicion> listaMediciones = [];
  List listaItems = [];
  List listaUsuarios = [];
  String _mensaje="";

  @override
  void initState() {

    super.initState();

  }

  void showAlert(BuildContext context, int valor) {

    print(valor);
    if(valor>0){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("Tienes " + valor.toString() + " Cuentas Pendientes por Registrar"),
              actions: [
              TextButton(child: Text('Aceptar'),
        onPressed: (){
          Navigator.of(context).pop();
        },
      )
    ],
          ));
    }else{
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("No tienes Cuentas pendientes por Registrar"),
            actions: [
              TextButton(child: Text('Aceptar'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    }
  }


  @override
  Widget build(BuildContext context) {

    print ("Orden");
    print("Numero Ordenes: "+ ordenes.length.toString());

    int cuentasPendientes=0;

    for (var orden in ordenes) {
        double progreso=0.0;
        int cuentasHechas=0;
        print ("Orden");
        for (var cuenta in orden.cuentasOrdenes) {
          if(cuenta.completado == 1){
            cuentasHechas++;
          }else{
            cuentasPendientes++;
          }
        }
        if(cuentasHechas>0){
          progreso = (cuentasHechas*100) / orden.numero_cuentas;
        }
        orden.cuentasHechas = cuentasHechas;
        orden.progreso = progreso;
    }
    //orden.cuentasOrdenes.sort((a, b) => a.completado.compareTo(b.completado));
    ordenes.sort((a, b) => a.progreso.compareTo(b.progreso));

    for (var orden in ordenes) {
      print("Progreso");
      print(orden.progreso);
    }

    //Colocamos una Alerta si Tiene Cuentas pendientes de Registro, este mensaje se presentara cada vez que ingrese al Home

    Future.delayed(Duration.zero, () => showAlert(context, cuentasPendientes));
    /* if (cuentasPendientes>0){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Ejemplo'),
            );
          }
      );
    } */

    return  Column(
        children: <Widget>[
        ListView.builder(
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
    );

  }
}
