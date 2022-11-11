import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:epa_movil/src/backend/usuario_epa.dart';
import 'package:epa_movil/src/connection/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:epa_movil/src/advanced/asset_file.dart';
import 'cuenta.dart';
import 'cultivo.dart';
import 'orden.dart';
import 'recipe.dart';
import 'user.dart';
import 'package:http/http.dart' as http;

List<User> users = [];
List<Recipe> recipes = [];
List<Recipe> favorites = [];
List<UsuarioEpa> users_epa = [];
List<Orden> ordenes = [];
List<Cuenta> cuentas = [];
List<Cultivo> cultivos = [];

//Funcion para Cargar las Ordenes y las Cuentas Correspondientes
Future<void> blanquearOrdenesCuentas(context, UsuarioEpa user) async{
  final respuesta = await http.post(
    Uri.parse('http://192.168.10.85:88/epaapp/ordenes-de-trabajo/'+user.usuario_id.toString()),
    headers: <String, String>{
      'X-Authorization': 'hquiiwm@jjsosksk%7mkkklss-jhjskd_haadd%sdassfdsf*ad!',
    },
  );
  print("UsuarioID");
  print(user.usuario_id);

  if(respuesta.statusCode==200){
    ordenes = [];
    cuentas = [];
    cultivos = [];
    await DB.truncate_ordenes_epa();
    await DB.truncate_cuentas_epa();
    await DB.truncate_cultivos_epa();
    ordenes = [];
    cuentas = [];
    cultivos = [];
  }else{
    showDialog(context: context, builder: (context){
      return Center(
          child: SizedBox(
              height: 50,
              width: 350,
              child: Stack(
                fit: StackFit.expand,
                children: const [
                  LinearProgressIndicator(),
                  Center(
                    child: Text(
                      "No se pudieron cargar las Ordenes...",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
          )
      );
    },
    );

    await Future.delayed(Duration(seconds: 6));
    Navigator.of(context).pop();
  }
}

Future<void> generateOrdenesCuentas(context, UsuarioEpa user) async{
  //final AssetBundle assetBundle = DefaultAssetBundle.of(context);

  final respuesta = await http.post(
    Uri.parse('http://192.168.10.85:88/epaapp/ordenes-de-trabajo/'+user.usuario_id.toString()),
    headers: <String, String>{
      'X-Authorization': 'hquiiwm@jjsosksk%7mkkklss-jhjskd_haadd%sdassfdsf*ad!',
    },
  );
  print("UsuarioID");
  print(user.usuario_id);

  if(respuesta.statusCode==200){
    await DB.truncate_ordenes_epa();
    await DB.truncate_cuentas_epa();
    await DB.truncate_cultivos_epa();
    ordenes = [];
    cuentas = [];
    cultivos = [];

    var parsedJson = json.decode(respuesta.body);

    showDialog(context: context, builder: (context){
      return Center(
          child: SizedBox(
              height: 50,
              width: 350,
              child: Stack(
                fit: StackFit.expand,
                children: const [
                  LinearProgressIndicator(),
                  Center(
                    child: Text(
                      "Cargando Ordenes...",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
          )
      );
    },
    );

    if(parsedJson["estado"]==200) {

      ordenes = [];
      print("Ordenes Json");
      print(parsedJson["ordenes"]);
      for (final ordenesJson in parsedJson["ordenes"])
      {
        ordenes.add(new Orden.fromJson(ordenesJson));
        //print(parsedJson["ordenes"]["contratos"]);
      }

      for (int i = 0; i < ordenes.length; i++) {
        DB.insertar_ordenes_epa(ordenes[i]);
        print("Orden : "+ ordenes[i].secuencial_orden);

        print("ListaNuevaOrdenes");
        print(ordenes[i].cuentasOrdenes);

        for (int j = 0; j < ordenes[i].cuentasOrdenes.length; j++) {
          print("Cuenta Impresa");
          print(ordenes[i].cuentasOrdenes[j]);
          print(ordenes[i].cuentasOrdenes[j].secuencial_orden);
          print(ordenes[i].cuentasOrdenes[j].nombre_cliente);
          cuentas.add(ordenes[i].cuentasOrdenes[j]);
          DB.insertar_cuentas_epa(ordenes[i].cuentasOrdenes[j]);
          print("Cuenta : "+ cuentas[i].nombre_cliente);

          /* for (int k = 0; j < ordenes[i].cuentasOrdenes[j].cultivosCuenta.length; k++) {
              DB.insertar_cultivos_epa(ordenes[i].cuentasOrdenes[j].cultivosCuenta[k]);
          }*/

          //ordenes[i].cuentasOrdenes = [];
          //ordenes[i].cuentasOrdenes = await DB.cuentas_epa_por_orden(ordenes[i].secuencial_orden);
        }
        //ordenes[0].cuentasOrdenes = await DB.cuentas_epa_por_orden(ordenes[0].secuencial_orden);
        //ordenes[0].cuentasOrdenes = await DB.cuentas_epa_por_orden(ordenes[0].secuencial_orden);
      }

      for (int i = 0; i < ordenes.length; i++) {
        ordenes[i].cuentasOrdenes = [];
        ordenes[i].cuentasOrdenes = await DB.cuentas_epa_por_orden(ordenes[i].secuencial_orden);

        for (int j = 0; j < ordenes[i].cuentasOrdenes.length; j++) {
          ordenes[i].cuentasOrdenes[j].cultivosCuenta = await DB.cultivos_epa_por_cuenta(ordenes[i].cuentasOrdenes[j].numero_cuenta);
        }
      }

      print("Cuentas Cargadas");
      print(cuentas.length);

      print("Cuentas Orden 1");
      print(ordenes[0].cuentasOrdenes.length);



      /* for (final cuentasJson in parsedJson["contratos"])
      {
        cuentas.add(new Cuenta.fromJson(cuentasJson));
      }

      for (int i = 0; i < 6; i++) {
        //DB.insertar_user_epa(UsuarioEpa(usuario_id:0, codigo: users_epa[i].codigo, nombre: users_epa[i].nombre, apellidos: users_epa[i].apellidos, email: users_epa[i].email, pws: users_epa[i].pws, usuario: users_epa[i].usuario));
        //print("Usuario : "+ users_epa[i].codigo!);
        DB.insertar_cuentas_epa(cuentas[i]);
        print("Cuenta : "+ cuentas[i].nombre_cliente);
      } */
      print("Suceso : Cuentas Cargadas");
    }

    //ordenes = await DB.ordenes_epa();
    //ordenes[0].cuentasOrdenes = await DB.cuentas_epa_por_orden(ordenes[0].secuencial_orden);


    showDialog(context: context, builder: (context){
      return Center(
          child: SizedBox(
              height: 50,
              width: 350,
              child: Stack(
                fit: StackFit.expand,
                children: const [
                  LinearProgressIndicator(),
                  Center(
                    child: Text(
                      "Cargando Ordenes...",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
          )
      );
    },
    );

    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pop();
    Navigator.pushNamed(context,"/home",arguments: user);
  }
  else{
    showDialog(context: context, builder: (context){
      return Center(
          child: SizedBox(
              height: 50,
              width: 350,
              child: Stack(
                fit: StackFit.expand,
                children: const [
                  LinearProgressIndicator(),
                  Center(
                    child: Text(
                      "No se pudieron cargar las Ordenes...",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
          )
      );
    },
    );

    await Future.delayed(Duration(seconds: 6));
    Navigator.of(context).pop();
  }
  //Truncate la Tabla
  //await DB.create_ordenes_epa();

  /*
  await DB.insertar_ordenes_epa(Orden(
      orden_id: 1,
      secuencial_orden: "ORDEN000001",
      numero_cuentas: 5,
      progreso: 0.0,
      cuentasHechas: 0,
      sistema: "Chongon Santa Elena",
      fechaOrden: "19-08-2022",
      isExpanded: false,
      cuentasOrdenes: []
  ));

  await DB.insertar_ordenes_epa(Orden(
      orden_id: 2,
      secuencial_orden: "ORDEN000002",
      numero_cuentas: 5,
      progreso: 0.0,
      cuentasHechas: 0,
      sistema: "Chongon Santa Elena",
      fechaOrden: "19-08-2022",
      isExpanded: false,
      cuentasOrdenes: []
  ));

  await DB.insertar_ordenes_epa(Orden(
      orden_id: 3,
      secuencial_orden: "ORDEN000003",
      numero_cuentas: 5,
      progreso: 0.0,
      cuentasHechas: 0,
      sistema: "Daular",
      fechaOrden: "19-08-2022",
      isExpanded: false,
      cuentasOrdenes: []
  ));

  await DB.insertar_ordenes_epa(Orden(
      orden_id: 4,
      secuencial_orden: "ORDEN000004",
      numero_cuentas: 5,
      progreso: 0.0,
      cuentasHechas: 0,
      sistema: "Daular",
      fechaOrden: "19-08-2022",
      isExpanded: false,
      cuentasOrdenes: []
  ));

  ordenes = await DB.ordenes_epa();

  //Insersion de Cuentas
  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:1,
      secuencial_orden: "ORDEN000001",
      numero_cuenta: "CTA000001",
      nombre_cliente: "Cliente Cuenta 1",
      direccion: "Direccion Cliente 1",
      ramal: "2.4",
      toma: " 1 ADC",
      latitud: "-2.150421", //,
      longitud: "-79.864414",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "110.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:2,
      secuencial_orden: "ORDEN000001",
      numero_cuenta: "CTA000002",
      nombre_cliente: "Cliente Cuenta 2",
      direccion: "Direccion Cliente 2",
      ramal: "3",
      toma: "1",
      latitud: "-2.150388", //,
      longitud: "-79.865696",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "120.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:3,
      secuencial_orden: "ORDEN000001",
      numero_cuenta: "CTA000003",
      nombre_cliente: "Cliente Cuenta 3",
      direccion: "Direccion Cliente 3",
      ramal: "3",
      toma: "2",
      latitud: "-2.148333", //,
      longitud: "-79.866418",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "130.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:4,
      secuencial_orden: "ORDEN000001",
      numero_cuenta: "CTA000004",
      nombre_cliente: "Cliente Cuenta 4",
      direccion: "Direccion Cliente 4",
      ramal: "3",
      toma: "3",
      latitud: "-2.149507", //,
      longitud: "-79.861408",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "140.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:5,
      secuencial_orden: "ORDEN000001",
      numero_cuenta: "CTA000005",
      nombre_cliente: "Cliente Cuenta 5",
      direccion: "Direccion Cliente 5",
      ramal: "3",
      toma: "17 ADC",
      latitud: "-2.147620", //
      longitud: "-79.864026",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "150.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:6,
      secuencial_orden: "ORDEN000002",
      numero_cuenta: "CTA000006",
      nombre_cliente: "Cliente Cuenta 6",
      direccion: "Direccion Cliente 6",
      ramal: "1,3",
      toma: "2",
      latitud: "-2.147620", //,
      longitud: "-79.864026",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "160.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:7,
      secuencial_orden: "ORDEN000002",
      numero_cuenta: "CTA000007",
      nombre_cliente: "Cliente Cuenta 7",
      direccion: "Direccion Cliente 7",
      ramal: "1,3",
      toma: "2A",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "170.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:8,
      secuencial_orden: "ORDEN000002",
      numero_cuenta: "CTA000008",
      nombre_cliente: "Cliente Cuenta 8",
      direccion: "Direccion Cliente 8",
      ramal: "2,2",
      toma: "5 Adc",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lectura_anterior: "180.0",
      lecturaUTBack: "",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:9,
      secuencial_orden: "ORDEN000002",
      numero_cuenta: "CTA000009",
      nombre_cliente: "Cliente Cuenta 9",
      direccion: "Direccion Cliente 9",
      ramal: "2,2",
      toma: "6",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "190.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:10,
      secuencial_orden: "ORDEN000002",
      numero_cuenta: "CTA000010",
      nombre_cliente: "Cliente Cuenta 10",
      direccion: "Direccion Cliente 10",
      ramal: "2,2,3",
      toma: "1",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "200.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:11,
      secuencial_orden: "ORDEN000003",
      numero_cuenta: "CTA000011",
      nombre_cliente: "Cliente Cuenta 11",
      direccion: "Direccion Cliente 11",
      ramal: "2,2",
      toma: "6 Adc",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "210.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:12,
      secuencial_orden: "ORDEN000003",
      numero_cuenta: "CTA000012",
      nombre_cliente: "Cliente Cuenta 12",
      direccion: "Direccion Cliente 12",
      ramal: "2",
      toma: "14",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "220.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:13,
      secuencial_orden: "ORDEN000003",
      numero_cuenta: "CTA000013",
      nombre_cliente: "Cliente Cuenta 13",
      direccion: "Direccion Cliente 13",
      ramal: "1",
      toma: "2",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "230.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:14,
      secuencial_orden: "ORDEN000003",
      numero_cuenta: "CTA000014",
      nombre_cliente: "Cliente Cuenta 14",
      direccion: "Direccion Cliente 14",
      ramal: "1",
      toma: "16",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "240.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:15,
      secuencial_orden: "ORDEN000003",
      numero_cuenta: "CTA000015",
      nombre_cliente: "Cliente Cuenta 15",
      direccion: "Direccion Cliente 15",
      ramal: "1",
      toma: "28 B",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "250.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:16,
      secuencial_orden: "ORDEN000004",
      numero_cuenta: "CTA000016",
      nombre_cliente: "Cliente Cuenta 16",
      direccion: "Direccion Cliente 16",
      ramal: "1,4",
      toma: "4",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "260.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:17,
      secuencial_orden: "ORDEN000004",
      numero_cuenta: "CTA000017",
      nombre_cliente: "Cliente Cuenta 17",
      direccion: "Direccion Cliente 17",
      ramal: "1,3",
      toma: "3",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "270.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:18,
      secuencial_orden: "ORDEN000004",
      numero_cuenta: "CTA000018",
      nombre_cliente: "Cliente Cuenta 18",
      direccion: "Direccion Cliente 18",
      ramal: "1,4",
      toma: "1",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "280.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:19,
      secuencial_orden: "ORDEN000004",
      numero_cuenta: "CTA000019",
      nombre_cliente: "Cliente Cuenta 19",
      direccion: "Direccion Cliente 19",
      ramal: "1,5,1",
      toma: "4",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "290.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  await DB.insertar_cuentas_epa(Cuenta(
      cuenta_id:20,
      secuencial_orden: "ORDEN000004",
      numero_cuenta: "CTA000020",
      nombre_cliente: "Cliente Cuenta 20",
      direccion: "Direccion Cliente 20",
      ramal: "1",
      toma: "22",
      latitud: "0.0",
      longitud: "0.0",
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: "300.0",
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      isExpanded: false,
      completado: 0,
      sincronizado: 0
  ));

  ordenes[0].cuentasOrdenes = await DB.cuentas_epa_por_orden(ordenes[0].secuencial_orden);
  ordenes[1].cuentasOrdenes = await DB.cuentas_epa_por_orden(ordenes[1].secuencial_orden);
  ordenes[2].cuentasOrdenes = await DB.cuentas_epa_por_orden(ordenes[2].secuencial_orden);
  ordenes[3].cuentasOrdenes = await DB.cuentas_epa_por_orden(ordenes[3].secuencial_orden);
  */
  /*Navigator.of(context).pushNamed(
    '/home',
  );*/
  return;
}

Future<void> enviarCuentas(context, UsuarioEpa user) async{
  print("prueba0");
  var numero_ordenes = ordenes.length;
  int cuentas_por_sincronizar = 0;

  for (var Orden in ordenes) {

    for (var Cuenta in Orden.cuentasOrdenes){
      if (Cuenta.sincronizado == 0 && Cuenta.completado==1){
        cuentas_por_sincronizar++;
      }
    }
  }

  if(cuentas_por_sincronizar==0){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("No tienes Cuentas Pendientes de Sincronización"),
          actions: [
            TextButton(child: Text('Aceptar'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }else{


    for (var Orden in ordenes) {

      for (var Cuenta in Orden.cuentasOrdenes){

        print("Completado");
        print(Cuenta.completado);
        if (Cuenta.completado == 1 && Cuenta.sincronizado == 0){

          //cuentas_por_sincronizar++;
          await cargarCuentasCero(context, Cuenta, user);
          print("Cuenta Enviada");
          //print(this.cuenta_enviada);
          //if(this.cuenta_enviada ==1){
          Cuenta.sincronizado  = 1;
          //}
        }
      }
    }



    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Se han sincronizado "+cuentas_por_sincronizar.toString()+ " Cuentas..."),
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

Future<void> cargarCuentasCero(context, Cuenta cuenta, UsuarioEpa user) async {

  try{
    final respuesta = await http.post(
      Uri.parse('http://192.168.10.85:88/epaapp/sync/usuarios'),
      headers: <String, String>{
        'X-Authorization': 'hquiiwm@jjsosksk%7mkkklss-jhjskd_haadd%sdassfdsf*ad!',
      },
    ).timeout(const Duration(seconds: 3));
    ///cargarLogin(context);
    ///
    List<String> imagenes = [];
    imagenes.add(cuenta.imagen);

    print("fecha");
    print(cuenta.fechaRegistro);

    print ("Sin Lectura");
    print(cuenta.sin_lectura);
    Map data = {
      'orden_trabajo_id':cuenta.secuencial_orden,
      "usuario_id": user.usuario_id,
      "cuenta_id":cuenta.numero_cuenta,
      "sin_lectura":cuenta.sin_lectura,
      "tipo_incidencia_id":1,
      "unidad_medida":cuenta.unidad_medida,
      "latitud":cuenta.latitud,
      "longitud":cuenta.longitud,
      "lectura_ut":cuenta.lecturaUT,
      "lectura_ut_back":cuenta.lecturaUTBack,
      "lectura_actual":cuenta.lectura_actual,
      "fecha_lectura":cuenta.fechaRegistro,
      "archivo_lectura": [cuenta.imagen],
      "ramal":cuenta.ramal,
      "toma":cuenta.toma,
      "observacion":cuenta.observacion
    };
    print ("Json");
    print(json.encode(data));
    String body2 = json.encode(data);
    final respuesta2 = await http.post(
      Uri.parse('http://192.168.10.85:88/epaapp/lectura/nueva-lectura'),
      headers: <String, String>{
        'X-Authorization': 'hquiiwm@jjsosksk%7mkkklss-jhjskd_haadd%sdassfdsf*ad!',
        'Content-Type' : 'application/json',
        'Accept' : 'application/json',
      },
      body: body2,
    );



    //this.cuenta_enviada = 1;
    cuenta.sincronizado == 1;
    print("Estatus");
    print (respuesta2.statusCode);
    print (respuesta2.statusCode);
    print (respuesta2.body);

  }catch(e){
    print ("Excepcion: "+e.toString());
    print("No se envio");
    //this.cuenta_enviada = 0;

    //mostrarSinConexion(context);
    /* showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("Hay un error de Conexion..."),
            actions: [
              TextButton(child: Text('Aceptar'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          )); */
  }


}
/*
Future<List<Orden>> ordenes_epa() async{
  return DB.ordenes_epa();
}
 */

void generateData(BuildContext context) {
  final AssetBundle assetBundle = DefaultAssetBundle.of(context);
  users = [
    User(
        id: 1,
        nickname: "Adriana20",
        password: "adriana",
        genrer: Genrer.FEMALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img1.jpg")),
    User(
        id: 2,
        nickname: "jorge",
        password: "jorge",
        genrer: Genrer.MALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img2.jpg")),
    User(
        id: 3,
        nickname: "Steven2019",
        password: "steven",
        genrer: Genrer.MALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img3.jpg")),
    User(
        id: 4,
        nickname: "Leopoldo500",
        password: "leopoldo",
        genrer: Genrer.MALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img4.jpg")),
    User(
        id: 5,
        nickname: "Julia38",
        password: "julia",
        genrer: Genrer.FEMALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img6.jpg")),
    User(
        id: 6,
        nickname: "KatyPerez",
        password: "katy",
        genrer: Genrer.FEMALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img7.jpg")),
    User(
        id: 7,
        nickname: "EnrryLirico",
        password: "enrry",
        genrer: Genrer.MALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img8.jpg")),
    User(
        id: 8,
        nickname: "RosaFuentes",
        password: "rosa",
        genrer: Genrer.FEMALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img9.jpg")),
    User(
        id: 9,
        nickname: "MarlonMartinez",
        password: "marlon",
        genrer: Genrer.MALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img10.jpg")),
    User(
        id: 10,
        nickname: "EsperanzaJoya",
        password: "esperanza",
        genrer: Genrer.FEMALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img11.jpg")),
    User(
        id: 10,
        nickname: "Gumercinda",
        password: "gumercinda",
        genrer: Genrer.FEMALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img12.jpg")),
    User(
        id: 11,
        nickname: "EnriquetaValle",
        password: "enriqueta",
        genrer: Genrer.MALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img13.jpg")),
    User(
        id: 12,
        nickname: "LuzAlf",
        password: "luz",
        genrer: Genrer.FEMALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img14.jpg")),
    User(
        id: 13,
        nickname: "SorayaCastaneda",
        password: "soraya",
        genrer: Genrer.FEMALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img15.jpg")),
    User(
        id: 14,
        nickname: "SuyinHu",
        password: "suyin",
        genrer: Genrer.FEMALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img16.jpg")),
    User(
        id: 15,
        nickname: "EstelaMartinez",
        password: "estela",
        genrer: Genrer.FEMALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img17.jpg")),
    User(
        id: 16,
        nickname: "LuisaMagañ",
        password: "luisa",
        genrer: Genrer.FEMALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img18.jpg")),
    User(
        id: 17,
        nickname: "Yakinawa",
        password: "yakinawa",
        genrer: Genrer.FEMALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img19.jpg")),
    User(
        id: 18,
        nickname: "LuisEnrique",
        password: "luis",
        genrer: Genrer.MALE,
        photo: AssetFile(assetBundle, "assets/images/usuarios/img20.jpg")),
  ];

  recipes = <Recipe>[
    Recipe(
        description:
        "Es una receta muy sencilla, su nivel de dificultad es de casi cero "
            "ya que no requiere de gran experiencia para poder realizarla, "
            "los ingredientes son accesibles y fáciles de conseguir es una "
            "comida ideal para acompañar con cualquier otro platillo, "
            "su sabor y textura despiertan el paladar de cualquier comensal "
            "y es que los salvadoreños sin duda alguna saben llegar al "
            "corazón de sus allegados a través de la comida.",
        date: DateTime.now(),
        id: 1,
        ingredients: <String>[
          "4 pechugas de pollo",
          "Cilantro (una cucharada )",
          "Sal",
          "Ajo",
          "2 tazas de Pan rallado",
          "Mostaza",
          "Pimienta",
          "Aceite para freír",
          "2 huevos",
          "2 tazas de harina de trigo"
        ],
        name: "Pollo empanizado",
        steps: <String>[
          "Mezclar en una taza las 2 tazas de harina, 2 tazas de pan rallado, sal y pimienta al gusto a esto se le añadirán los 2 huevos previamente batidos hasta conseguir una mezcla homogénea.",
          "En una taza a parte sazonar las pechugas de pollo con ajo finamente picado, sal, pimienta, mostaza y cilantro, dejar reposar por 15 minutos en la nevera para que todos los ingredientes se concentren y se adhieran a las pechugas de pollo.",
          "En un sartén se debe colocar aceite para freír, pasar las pechugas de pollo por la mezcla homogénea y cubrir perfectamente todas las pechugas para luego incorporarlas en aceite caliente hasta que se cocinen y queden completamente doradas y crujientes, sacar y dejar secar el aceite en toallas absorbentes.",
          "Estas piezas de pollos pueden acompañarse perfectamente con una ensalada de tomates, lechuga y cebolla o simplemente con lo que usted guste y tenga a su alcance.",
        ],
        user: users[0],
        photo: AssetFile(
            assetBundle, "assets/images/platillos/pollo-empanizado.jpg")),
    Recipe(
        name: "Sopa de tortillas",
        description:
        "La sopa de tortillas es uno de los platos favoritos de los salvadoreños por ser relativamente fácil a la hora de preparar, rinde lo suficiente y es ideal para compartir con gran parte de la familia, los ingredientes son accesibles  y es súper deliciosa.",
        date: DateTime.now(),
        id: 2,
        ingredients: <String>[
          "6 tortillas cortadas en tiras pequeñas previamente fritas.",
          "3 tomates.",
          "2 cebollas medianas.",
          "3 dientes de ajo.",
          "2 aguacates.",
          "2 pechugas de pollo previamente cocidas.",
          "Ramitos de cilantro al gusto.",
          "Crema de queso.",
          "Queso rallado al gusto.",
          "1 litro de consomé o sal al gusto."
        ],
        steps: <String>[
          "En 1 litro de consomé colocar el pollo cortado en trocitos, de manera opcional puede sofreír los trozos del pollo para añadir un poco más de sabor a la preparación, agregar los ramitos de cilantro, la sal, el tomate, la cebolla y los dientes de ajos cortados en cuadros pequeños y sofritos previamente en aceite, dejar que hierva por 5 minutos, retirar y dejar reposar.",
          "Cortar el aguacate en trocitos colocar encima de la sopa a manera de presentación todo esto junto a las tiras de tortillas, queso rallado, queso crema, decorar el platillo con ramitos de cilantro al gusto y a degustar se ha dicho.",
          "Lo que sí es seguro y no se puede negar es que los salvadoreños tienen estilo y sazón a la hora de preparar este delicioso plato, aprecian y reconocen el intercambio de saberes cuando de cocina se trata y le agregan su “toque mágico” a la hora de realizar esta rica receta.",
        ],
        user: users[6],
        photo: AssetFile(
            assetBundle, "assets/images/platillos/sopa-de-tortillas.jpg")),
    Recipe(
        name: "Pupusas de pollo",
        description:
        "Las pupusas de pollo son un plato típico que deleita al paladar de los salvadoreños. Te enseñamos como hacerlas en unos simples pasos. De esta manera podrás disfrutar estas ricas pupusas de pollo.",
        date: DateTime.now(),
        id: 3,
        ingredients: <String>[
          "Una cebolla mediana",
          "La mitad de un pimentón mediano, de preferencia rojo",
          "300 gramos de queso mozzarella",
          "¼ de kilo de muslos de pollo",
          "50 gramos de tomate, licuado o triturado",
          "Aceite comestible, lo usaremos para freír",
          "Una o dos cucharadas de sal"
        ],
        steps: <String>[
          "Lo recomendable es freír las piezas de pollo durante aproximadamente 5 minutos por un lado y luego cinco adicionales por el otro. Posteriormente colocarlos en una olla donde verteremos agua hasta cubrir los muslos. Luego se debe cocinarlos.",
          "Tenemos que esperar que hierva, se tapa y se cocina a fuego lento durante una hora. En otro lugar, en un recipiente vaciamos la harina y la levadura. Añadimos la sal y revolvemos. Se agrega el agua y un poco de aceite. Luego se amasa hasta que no queden residuos en nuestras manos y se deja reposar por una hora aproximadamente.",
          "Al terminar la preparación del pollo, retiramos la carne de los huesos y trituramos bien. Luego se pican los pimentones y las cebollas para luego sofreír. Cuando estén dorados se le añada el pollo.",
          "Para continuar, se hacen bolitas de masa y se forma la tortilla. El tamaño de la tortilla dependerá del gusto. Lo recomendable es dejar medio centímetro de grosor y cocinar a fuego lento.",
          "Una vez lista la tortilla, picamos el queso mozarela y lo añadimos a la mezcla del pollo. Todos estos ingredientes se ponen en el centro de la tortilla. Se cubre la mezcla al doblar la tortilla y se vuelve a dar forma de circulo.",
          "Finalmente, se debe colocar en la plancha o comal y esperar de 5 a 8 a minutos."
        ],
        user: users[3],
        photo: AssetFile(
            assetBundle, "assets/images/platillos/pupusas-de-pollo.jpg")),
    Recipe(
        name: "Coctel de camarón",
        description:
        "El coctel de camarón es una increíble receta salvadoreña propicia para consumir en momentos de calor por las propiedades refrescantes que genera y el sabor exquisito que presenta, si no eres alérgico a los camarones esta será una comida que definitivamente deberás probar.",
        date: DateTime.now(),
        id: 4,
        ingredients: <String>[
          "1 tomate.",
          "1 cebolla.",
          "Cilantro al gusto.",
          "Camarones (pelados y limpios).",
          "Sal",
          "4 limones.",
          "Ajo",
          "2 aguacates.",
          "Orégano.",
          "Salsa de soya.",
          "Pimienta",
          "Galletas de soda."
        ],
        steps: <String>[
          "Cortar el tomate, el cilantro, el aguacate y la cebolla en trocitos pequeños y guardar en un tazón, a parte poner a hervir los camarones con ajo picadito, orégano, pimienta y sal al gusto, una vez estén cocidos se dejan enfriar",
          "Mezclar el tomate, el cilantro, el aguacate y la cebolla junto a los camarones ya cocidos, exprimir el jugo de 4 limones, añadir salsa de soya, el clamato, sal, pimienta y un toque de orégano al gusto.",
          "Verter toda esa mezcla en un recipiente (copa grande preferiblemente) y acompañar con galletas de soda.",
          "Cabe destacar que el coctel de camarón además de ser exquisito es un plato considerado afrodisiaco a nivel mundial, disfrutarlo será una grata sensación culinaria."
        ],
        user: users[7],
        photo: AssetFile(assetBundle,
            "assets/images/platillos/hacer-coctel-de-camaron.jpg")),
    Recipe(
        name: "Escabeche salvadoreño",
        description:
        "El escabeche salvadoreño es un acompañante típico en la región para casi cualquier plato principal, aunque tradicionalmente tomados como el complemento especial para los sándwiches de pollo o pavo, su base por lo general es repollo o coliflor, y acompañado por zanahorias, ejotes, chiles, cebollas y especias al gusto que se fusionan en una excelente combinación de sabores para degustar al paladar de las familias salvadoreñas.",
        date: DateTime.now(),
        id: 5,
        ingredients: <String>[
          "1 Repollo o coliflor (de aproximadamente 200 gramos).",
          "1 Zanahoria.",
          "Ejotes",
          "Ají picante verde.",
          "1 Cebolla.",
          "30gr de mostaza.",
          "50gr de mayonesa.",
          "Orégano y pimienta al gusto.",
          "100 gr de margarina.",
          "Opcionalmente consomé de pollo o pavo."
        ],
        steps: <String>[
          "Hacer tiras finas con el repollo o coliflor, zanahoria, cebolla y ají, derretir la margarina en baño maría y agregarle pimienta y orégano al gusto.",
          "Luego sofreír los vegetales ya hechos tiras en la margarina por 5 minutos, el siguiente paso es agregar la mayonesa y la mostaza, y en caso de desearlo el consomé de pollo o pavo, dejando cocinar a fuego lento por 8 minutos aproximadamente.",
          "En definitiva, el escabeche salvadoreño es uno de los platos que no puedes dejar de probar si algún día visitas el salvador.",
        ],
        user: users[6],
        photo: AssetFile(
            assetBundle, "assets/images/platillos/escabeche-salvadoreno.jpg")),
    Recipe(
        name: "Empanadas Salvadoreñas",
        description:
        "Esta versión del Salvador es única en su región; es un bollo elaborado con plátano maduro y relleno con frijoles refritos o “poleada”; una mezcla dulce a base de maicena y leche con la espesura de un atol.\n"
            "En la gastronomía Salvadoreña se prepara desde tiempos antiguos y se puede acompañar con chocolate caliente, café o alguna bebida nacional.",
        date: DateTime.now(),
        id: 6,
        ingredients: <String>[
          "Plátanos maduros",
          "Maicena",
          "Leche",
          "Ramas de canela",
          "Frijoles refritos",
          "Azúcar",
          "Aceite"
        ],
        steps: <String>[
          "Se le cortan las puntas a los plátanos, se pican por la mitad y se meten en agua caliente hasta que se cocinen. Retirarlos del agua y quitarles la piel.",
          "En una sartén calentar a fuego bajo la leche con la canela.",
          "Diluir la maicena y el azúcar en un poquito de leche fría y agregarlo a la cacerola cuando la leche esté a punto de hervir",
          "Seguir cocinando a fuego bajo y moviendo con cuchara de madera para que no se peque a la cacerola. Cuando haya espesado bastante, bajar del fuego y reservar.",
          "Hacer un puré uniforme con los plátanos.",
          "Cada empanada se forma tomando una bolita del puré de plátano, la aplastamos con las manos y ponemos en el centro la poleada o frijoles fritos. Luego cerramos bien hasta que quede bien envuelto el relleno",
          "Ponemos a freír en aceite caliente a fuego bajo hasta que doren.",
          "Espolvorear con azúcar."
        ],
        user: users[9],
        photo: AssetFile(
            assetBundle, "assets/images/platillos/empanadas-salvadorenas.jpg")),
    Recipe(
        name: "Sopa de tortillas",
        description:
        "La sopa de tortillas es uno de los platos favoritos de los salvadoreños por ser relativamente fácil a la hora de preparar, rinde lo suficiente y es ideal para compartir con gran parte de la familia, los ingredientes son accesibles  y es súper deliciosa.",
        date: DateTime.now(),
        id: 7,
        ingredients: <String>[
          "500 gr nalga o bola de lomo cortada para milanesas",
          "50 gr (o un poco más si te gusta) grasa de pella",
          "1 morrón",
          "2-3 cebollas grandes",
          "4-5 cebollitas de verdeo",
          "2 cdas pimentón dulce",
          "sal y pimienta recién molida a gusto",
          "1 pizca comino (ojo no mucho es bastante invasivo)",
          "1 cdas ají molido",
          "1 cda o 2 de condimento para rellenos y empanadas",
          "3 huevos duros",
          "150 gr aceitunas",
          "50 gr pasas de uvas (opcional)",
          "24 tapas de empanadas hojaldre o criollas tipo rotiseras"
        ],
        steps: <String>[
          "Saltear en un fondito de grasa (o aceite si las preferís más livianas) las cebollas y el morrón. Salar",
          "Una vez bien hecho el sofrito.",
          "Agregar la carne en cortada en cubitos pequeños. Hay quienes previamente pasan la carne por agua hirviendo pero yo prefiero que todos los jugos queden acá. Cocinar unos minutos y condimentar con ají molido, pimienta, rectificar sal, bastante pimentón dulce del bueno y comino si te gusta. También suelo utilizar la mezcla de especies de la marca Alicante especial para rellenos de empanadas.",
          "Dejar enfriar el relleno, lo ideal es de un día para otro para que esté más sabroso. Ponemos el huevo duro picadito (no muy chiquito) si te gusta se pueden agregar pasas y aceitunas.",
          "Armar las empanadas.",
          "Hacer el repulgue, acomodar en placa y pintar con huevo batido. Llevar a cocinar en horno pre-calentado FUERTE 220º durante 12 a 15 minutos.",
          "Ahora si...listas para llevar a la mesa !!! Bien sabrosas y jugosas nuestras empanadas."
        ],
        user: users[9],
        photo: AssetFile(
            assetBundle, "assets/images/platillos/empanadas-argentinas.jpg")),
  ];
}

//Funcion para Cargar los Usuarios mediante peticion al Api de Epacom
Future<void> cargarLogin(BuildContext context) async {

  final respuesta = await http.post(
    Uri.parse('http://192.168.10.85:88/epaapp/sync/usuarios'),
    headers: <String, String>{
      'X-Authorization': 'hquiiwm@jjsosksk%7mkkklss-jhjskd_haadd%sdassfdsf*ad!',
    },
  );
  /*final String password = BCrypt.hashpw(
    'jorge.buestan',
    BCrypt.gensalt(),
  );*/

  if(respuesta.statusCode==200){

    DB.truncate_usuario_epa();
    DB.create_usuario_epa();
    var parsedJson = json.decode(respuesta.body);

    showDialog(context: context, builder: (context){
      return Center(
          child: SizedBox(
              height: 50,
              width: 350,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(),
                  Center(
                    child: Text(
                      "Cargando Usuarios...",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
          )
      );
    },
    );

    if(parsedJson["estado"]==200) {
      for (final usuario in parsedJson["usuarios"])
      {
        users_epa.add(new UsuarioEpa.fromJson(usuario));
      }

      for (int i = 0; i < users_epa.length; i++) {
        DB.insertar_user_epa(UsuarioEpa(usuario_id:users_epa[i].usuario_id, codigo: users_epa[i].codigo, nombre: users_epa[i].nombre, apellidos: users_epa[i].apellidos, email: users_epa[i].email, pws: users_epa[i].pws, usuario: users_epa[i].usuario));
        print("Usuario : "+ users_epa[i].codigo!);
      }
      print("Suceso : Usuarios Cargados");
    }
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pop();
  }
  else{

    showDialog(context: context, builder: (context){
      return Center(
          child: SizedBox(
              height: 50,
              width: 350,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(),
                  Center(
                    child: Text(
                      "Error, Status:"+ respuesta.statusCode.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
          )
      );
    },
    );
    print("Suceso : No se pudo sincronizar los usuarios");
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pop();
  }
}

Future<void> mostrarSinConexion(BuildContext context) async {


  showDialog(context: context, builder: (context){
    return Center(
        child: SizedBox(
            height: 50,
            width: 350,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  color: Colors.yellow,
                  backgroundColor: Colors.yellow.shade300,
                ),
                Center(
                  child: Text(
                    "No hay conexión con el servidor para la sincronización...",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
        )
    );

  },
  );

  await Future.delayed(Duration(seconds: 3));
  Navigator.of(context).pop();
}

Future<void> mostrarSinConexion2(BuildContext context) async {


  /* showDialog(context: context, builder: (context){
    return Center(
        child: SizedBox(
            height: 50,
            width: 350,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  color: Colors.yellow,
                  backgroundColor: Colors.yellow.shade300,
                ),
                Center(
                  child: Text(
                    "No hay conexión con el servidor para la sincronización...",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
        )
    );

  },
  ); */

  showDialog(context: context, builder: (context){
    return Center(
        child: SizedBox(
            height: 50,
            width: 350,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  color: Colors.yellow,
                  backgroundColor: Colors.yellow.shade300,
                ),
                Center(
                  child: Text(
                    "No hay conexión con el servidor para la sincronización...",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
        )
    );
  },
  );


  await Future.delayed(Duration(seconds: 3));
}