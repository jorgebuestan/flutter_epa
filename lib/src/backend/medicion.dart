import 'dart:io';


class Medicion {
  int id;
  String nombre;
  String descripcion;
  double latitud;
  double longitud;
  double altitud;
  bool isExpanded;

  Medicion({ required this.id,  required this.nombre,  required this.descripcion,  required this.latitud,  required this.longitud,  required this.altitud, this.isExpanded = false});

  Map<String, dynamic> toMap(){
    return {'id':id, 'nombre':nombre, 'descripcion':descripcion, 'latitud':latitud, 'longitud':longitud, 'altitud':altitud};
  }
}