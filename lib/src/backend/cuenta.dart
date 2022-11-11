import 'dart:io';

import '../connection/db.dart';
import 'cultivo.dart';


class Cuenta {
  int cuenta_id;
  String secuencial_orden;
  String numero_cuenta;
  String nombre_cliente;
  String direccion;
  String ramal;
  String toma;
  String tipo_cultivo;
  String numero_hectareas;
  String latitud;
  String longitud;
  String altitud;
  String lecturaUT;
  String lecturaUTBack;
  String lectura_anterior;
  String lectura_actual;
  String observacion;
  String fechaRegistro;
  String imagen;
  List<Cultivo> cultivosCuenta=const[];
  int completado;
  int sincronizado;
  int isExpanded;
  int tieneNovedad;
  String unidad_medida;
  int sin_lectura;

  Cuenta({ required this.cuenta_id, required this.secuencial_orden, required this.nombre_cliente,  required this.numero_cuenta,  required this.direccion,  required this.ramal,  required this.toma,  required this.tipo_cultivo,  required this.numero_hectareas,  required this.latitud,  required this.longitud,  required this.altitud,  required this.lecturaUT,  required this.lecturaUTBack,  required this.lectura_anterior,  required this.lectura_actual,  required this.observacion, required this.fechaRegistro, required this.imagen, required this.cultivosCuenta, required this.completado, required this.sincronizado, this.isExpanded = 0, this.tieneNovedad = 0, this.unidad_medida = "m3", this.sin_lectura = 0});
  //Cuenta({ required this.cuenta_id, required this.secuencial_orden, required this.nombre_cliente,  required this.numero_cuenta,  required this.direccion,  required this.ramal,  required this.toma,  required this.tipo_cultivo,  required this.numero_hectareas,  required this.latitud,  required this.longitud,  required this.altitud,  required this.lecturaUT,  required this.lecturaUTBack,  required this.lectura_anterior,  required this.lectura_actual,  required this.observacion, required this.fechaRegistro, required this.imagen, required this.completado, required this.sincronizado, this.isExpanded = 0, this.tieneNovedad = 0});

  factory Cuenta.fromJson(Map<String, dynamic> json){

    String direccion =json['direccion']== null ? "" : json["direccion"];
    direccion.replaceAll("'", " ").replaceAll("\'", " ");

    List<Cultivo> cultivosCuentasNew = [];

     for (final cultivosJson in json["cultivos"])
    {
      cultivosCuentasNew.add(new Cultivo.fromJson(cultivosJson));
      //print(parsedJson["ordenes"]["contratos"]);
    }

    for(var i = 0; i < cultivosCuentasNew.length; i++){
      cultivosCuentasNew[i].numero_cuenta = json['contrato'];

      DB.insertar_cultivos_epa( cultivosCuentasNew[i] );
    }

    for(var i = 0; i < cultivosCuentasNew.length; i++){
      print ("Cuenta");
      print (cultivosCuentasNew[i].numero_cuenta);
      print (cultivosCuentasNew[i].descripcion);
    }

    print("Lista Cultivos");
    print(cultivosCuentasNew);
    print(cultivosCuentasNew.length);

    return Cuenta(
      cuenta_id:0,
      secuencial_orden:json['pivot']['orden_trabajo_id'],
      numero_cuenta:json['contrato'],
      nombre_cliente:json["cliente"],
      direccion:direccion,
      ramal:json["ramal"] == null ? "" : json["ramal"],
      toma:json['toma'] == null ? "" : json["toma"],
      tipo_cultivo:"Cultivo 1",
      numero_hectareas: "1 Hectárea",
      latitud:json['latitud']== null ? "" : json["latitud"],
      longitud:json['longitud']== null ? "" : json["longitud"],
      altitud: "0.0",
      lecturaUT: "0.0",
      lecturaUTBack: "",
      lectura_anterior: json['lectura_anterior']== null ? "" : json["lectura_anterior"],
      lectura_actual: "0.0",
      observacion: "",
      fechaRegistro: "",
      imagen: "",
      cultivosCuenta: cultivosCuentasNew,
      completado: 0,
      sincronizado: 0,
      isExpanded: 0,
      tieneNovedad: 0,
      unidad_medida: "m3",
      sin_lectura: 0,
    );
  }

  /***/
  /****/
  Map<String, dynamic> toMap(){
    return {'cuenta_id':cuenta_id, 'secuencial_orden':secuencial_orden, 'numero_cuenta':numero_cuenta, 'nombre_cliente':nombre_cliente, 'direccion':direccion, 'ramal':ramal, 'toma':toma, 'latitud':latitud, 'longitud':longitud, 'altitud':altitud, 'lecturaUT':lecturaUT, 'lecturaUTBack':lecturaUTBack, 'lectura_anterior':lectura_anterior,'lectura_actual':lectura_actual,'observacion':observacion,'fechaRegistro':fechaRegistro,'imagen':imagen,'completado':completado,'sincronizado':sincronizado, 'isExpanded':isExpanded, 'unidad_medida':unidad_medida, 'sin_lectura':sin_lectura};
  }
}