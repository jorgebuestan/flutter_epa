import 'dart:developer';

import 'package:epa_movil/src/advanced/asset_file.dart';
import 'package:epa_movil/src/backend/medicion.dart';
import 'package:epa_movil/src/backend/user.dart';
import 'package:flutter/material.dart';
import 'package:epa_movil/src/connection/db.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {

  final User loggedUser;
  const HomePage(this.loggedUser, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    final AssetBundle assetBundle = DefaultAssetBundle.of(context);
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.blue),
        onPressed: () {
          Navigator.pushNamed(context,"/editar",arguments: Medicion(id:0,nombre:"",descripcion:"", latitud: 0.0, longitud: 0.0, altitud: 0.0));
        },
      ),
      body: Center(
          child: ListaUsuarios()
      ),
    );
  }
}

class ListaUsuarios extends StatefulWidget {

  @override
  _MiLista createState() => _MiLista();

}

class _MiLista extends State<ListaUsuarios> {

  List<Medicion> mediciones = [];
  String _mensaje="";

  @override
  void initState() {
    cargaUsuarios();
    recibirString();
    super.initState();
  }

  cargaUsuarios() async {
    List<Medicion> auxMediciones = await DB.mediciones();

    setState(() {
      mediciones = auxMediciones;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Column(
              children: <Widget>[
                Text("Recibiendo String"),
                SizedBox(height:40),
              ]
          ),
          SizedBox(height:40),
          Column(
              children: <Widget>[
                Text(_mensaje),
                SizedBox(height:40),
              ]
          )   ,
          //Center(child: Text(_mensaje),),
          Column(
              children: <Widget>[
                ListView.builder(
                    itemCount: mediciones.length,
                    itemBuilder:
                        (context, i) =>
                        Dismissible(key: Key(i.toString()),
                          direction: DismissDirection.startToEnd,
                          background: Container (
                              color: Colors.red,
                              padding: EdgeInsets.only(left: 5),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(Icons.delete, color: Colors.white)
                              )
                          ),
                          onDismissed: (direction) {
                            DB.delete_mediciones(mediciones[i]);
                          },
                          child: Stack(
                            children: <Widget>[
                              ListTile(
                                  title: Text(mediciones[i].nombre+ ' Valores: ' + _mensaje) ,
                                  subtitle:  ListTile(
                                    title: Text('Descripcion: '+mediciones[i].descripcion),
                                    subtitle: Text('Coordenadas: '+ mediciones[i].latitud.toString() + " , " +mediciones[i].longitud.toString() + " : " + mediciones[i].altitud.toString() ),
                                  ),
                                  trailing: MaterialButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context,"/editar",arguments: mediciones[i]);
                                      },
                                      child: Icon(Icons.edit)
                                  )
                              )
                            ],
                          ),
                        )
                )
              ]
          )

        ]);


  }


  Future<String?> recibirString() async {
    final respuesta = await http.get(Uri.parse("http://192.168.90.40:90/dart/ejemplo_json.php"));
    if(respuesta.statusCode==200){
      log( respuesta.body.toString());
      setState(() {
        _mensaje = respuesta.body.toString();
      });


    }else{
      throw Exception("Fallo");
    }
  }

}
