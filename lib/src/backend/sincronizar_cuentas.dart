
import 'dart:convert';

import 'package:epa_movil/src/backend/usuario_epa.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cuenta.dart';
import 'data_init.dart';

class SincronizarCuentas {

  int cuentas_enviadas = 0;
  int numero_ordenes = 0;
  int cuenta_enviada = 0;



   SincronizarCuentas(context, UsuarioEpa user){

print("prueba0");
     numero_ordenes = ordenes.length;
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
             CargarCuentasEpacom(context, Cuenta, user);
             print("Cuenta Enviada");
             print(this.cuenta_enviada);
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


  CargarCuentasEpacom(context, Cuenta cuenta, UsuarioEpa user) async {

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
      Map data = {
        'orden_trabajo_id':cuenta.secuencial_orden,
        "usuario_id": user.usuario_id,
        "cuenta_id":cuenta.numero_cuenta,
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



      this.cuenta_enviada = 1;
      cuenta.sincronizado == 1;
      print("Estatus");
      print (respuesta2.statusCode);
      print (respuesta2.statusCode);
      print (respuesta2.body);

    }catch(e){
      print ("Excepcion: "+e.toString());
      print("No se envio");
      this.cuenta_enviada = 0;

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
}