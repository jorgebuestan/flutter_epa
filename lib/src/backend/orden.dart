import 'dart:io';
import 'cuenta.dart';


class Orden {
  int orden_id;
  String secuencial_orden;
  int numero_cuentas;
  double progreso;
  int cuentasHechas;
  String sistema;
  String fechaOrden;
  bool isExpanded;
  List<Cuenta> cuentasOrdenes=const[];

  Orden({ required this.orden_id,  required this.secuencial_orden,  required this.numero_cuentas,  required this.progreso,  required this.cuentasHechas,  required this.sistema,  required this.fechaOrden,  this.isExpanded = false, required this.cuentasOrdenes});

  Map<String, dynamic> toMap(){
    return {'orden_id':orden_id, 'secuencial_orden':secuencial_orden, 'numero_cuentas':numero_cuentas, 'progreso':progreso, 'cuentasHechas':cuentasHechas, 'sistema':sistema, 'fechaOrden':fechaOrden, 'isExpanded':isExpanded, 'cuentasOrdenes':cuentasOrdenes};
  }

  factory Orden.fromJson(Map<String, dynamic> json){

    //String direccion =json['direccion']== null ? "" : json["direccion"];
    //direccion.replaceAll("'", " ").replaceAll("\'", " ");
    int cuentasNumber = int.parse(json['contratos_count']);
    print("Contratos");
    print(json['contratos']);
    List<Cuenta> cuentasOrdenesNew = [];

    for (final cuentasJson in json["contratos"])
    {
      cuentasOrdenesNew.add(new Cuenta.fromJson(cuentasJson));
      //print(parsedJson["ordenes"]["contratos"]);

    }
    print("Lista Cuentas");
    print(cuentasOrdenesNew);
    print(cuentasOrdenesNew.length);

    return Orden(
        orden_id:0,
        secuencial_orden:json["orden_trabajo_id"].toString(),
        numero_cuentas:cuentasNumber,
        progreso:0,
        cuentasHechas:0,
        sistema:json["sistema"] == null ? "" : json["sistema"],
        fechaOrden:json['fecha_inicio_prevista'] == null ? "" : json["fecha_inicio_prevista"],
        isExpanded:false,
        cuentasOrdenes:cuentasOrdenesNew
    );
  }
}