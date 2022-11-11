import 'dart:io';

import '../connection/db.dart';


class Cultivo {
  int cultivo_id;
  String numero_cuenta;
  String descripcion;
  String numero_hectareas;
  String tipo_riego;

  Cultivo({ required this.cultivo_id, required this.numero_cuenta, required this.descripcion, required this.numero_hectareas,  required this.tipo_riego});

  factory Cultivo.fromJson(Map<String, dynamic> json){


    return Cultivo(
      cultivo_id:0,
      numero_cuenta:"",
      descripcion:json['descripcion'],
      numero_hectareas:json['numero_hectareas'],
      tipo_riego:json["tipo_riego"]
    );
  }

  /***/
  /****/
  Map<String, dynamic> toMap(){
    return {'cultivo_id':cultivo_id, 'numero_cuenta':numero_cuenta, 'descripcion':descripcion, 'numero_hectareas':numero_hectareas, 'tipo_riego':tipo_riego};
  }
}