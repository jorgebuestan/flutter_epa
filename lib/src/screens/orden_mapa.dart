import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../backend/cuenta.dart';
import '../backend/orden.dart';
import '../connection/server_controller.dart';
import '../components/direction_provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../components/footer.dart';


class OrdenMapa extends StatefulWidget {

  ServerController serverController;
  BuildContext context;
  Orden orden;
  int marcadores = 0;
  LocationData _locationData = LocationData.fromMap({});
  Location location = Location();

  final LatLng fromPoint = LatLng(-2.150423, -79.864413);
  final LatLng toPoint = LatLng(-2.1443138,-79.8631419);
  final LatLng middlePoint = LatLng(-2.1468171,-79.8655008);



  OrdenMapa(this.serverController, this.context, {Key? key, required this.orden}) : super(key: key);

  @override
  _OrdenMapaState createState() => _OrdenMapaState();
}

class _OrdenMapaState extends State<OrdenMapa> {
  //final Completer<GoogleMapController> _mapController = Completer();
  //final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _mapController;
  late BitmapDescriptor icon;

  List<LatLng> polylineCoordinates = [];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, // Your Google Map Key
      PointLatLng(-2.150423, -79.864413),
      PointLatLng(-2.1443138,-79.8631419),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
            (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getPolyPoints();
    getIcons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orden: '+widget.orden.secuencial_orden),
      ),
      body:   GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.fromPoint,
          zoom: 12,
        ),
        markers: _createMarkers(),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: _onMapCreated,
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            color: const Color(0xFF7B61FF),
            width: 6,
            points: polylineCoordinates,
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.zoom_out_map),
          onPressed: _centerView,
          backgroundColor: Colors.blue
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      bottomNavigationBar: FooterEpa(serverController: widget.serverController,),
    );
  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.2),
        "assets/images/icon_epa2.png");
    setState(() {
      this.icon = icon;
    });
  }

  Set<Marker> _createMarkers() {

    Orden ordenRecibida = widget.orden;
    var tmp = Set<Marker>();

    print("Numero de Cuentas: "+ordenRecibida.cuentasOrdenes.length.toString());

    for(var i=0;i<ordenRecibida.cuentasOrdenes.length;i++){
      print(ordenRecibida.cuentasOrdenes[i]);
      print (i);

      var lat, lng;
      if(ordenRecibida.cuentasOrdenes[i].latitud.isEmpty || ordenRecibida.cuentasOrdenes[i].longitud.isEmpty){
        lat = 0.0;
        lng = 0.0;
      }else{
        lat = double.parse(ordenRecibida.cuentasOrdenes[i].latitud);
        lng = double.parse(ordenRecibida.cuentasOrdenes[i].longitud);
      }


      if(ordenRecibida.cuentasOrdenes[i].completado==0){
        tmp.add( //-2.1468171,-79.8655008
          Marker(
              markerId: MarkerId(ordenRecibida.cuentasOrdenes[i].numero_cuenta),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                  title: ordenRecibida.cuentasOrdenes[i].nombre_cliente + ", " + ordenRecibida.cuentasOrdenes[i].direccion,
                  onTap:() {
                    // InfoWindow clicked
                    //Navigator.pushNamed(context,"/cuentasOrden",arguments:ordenRecibida);
                    Navigator.pushNamed(context,"/editar",arguments: ordenRecibida.cuentasOrdenes[i]);
                  }
              ),
              icon: icon
          ),
        );
        widget.marcadores ++;
      }
    }



    /* tmp.add( //-2.1468171,-79.8655008
      Marker(
        markerId: MarkerId("fromPoint"),
        position: widget.fromPoint,
        infoWindow: InfoWindow(title: "EPA"),
      ),
    );
    tmp.add( //-2.1468171,-79.8655008
      Marker(
        markerId: MarkerId("2nd Point"),
        position: widget.middlePoint,
        infoWindow: InfoWindow(title: "Middle"),
      ),
    );
    tmp.add(
      Marker(
        markerId: MarkerId("toPoint"),
        position: widget.toPoint,
        infoWindow: InfoWindow(title: "Punto 3"),
      ),
    ); */
    return tmp;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    _centerView();
  }
  _centerView() async {
    var api = Provider.of<DirectionProvider>(context, listen: false);
    var left;
    var right;
    var top;
    var bottom;

    await _mapController.getVisibleRegion();

    print("buscando direcciones");
    //await api.findDirections(widget.fromPoint, widget.toPoint);

    List<Cuenta> cuentasMapas = [];
    int arrayPos = 0;

    for(var i=0;i<widget.orden.cuentasOrdenes.length;i++){
      print("Valor Completado");
      print(widget.orden.cuentasOrdenes[i].completado);
      if(widget.orden.cuentasOrdenes[i].completado==0){
        cuentasMapas.add(widget.orden.cuentasOrdenes[i]);
      }
      /*if(widget.orden.cuentasOrdenes[i].completado==0){
        cuentasMapas[arrayPos] = widget.orden.cuentasOrdenes[i];
        arrayPos++;
      }*/
    }

    print("Cuentas Disponibles");
    print(cuentasMapas.length);

    if(cuentasMapas.length>1) {

      var lat_ini = double.parse(cuentasMapas[0].latitud);
      var lng_ini = double.parse(cuentasMapas[0].longitud);
      var lat_fin = double.parse(cuentasMapas[cuentasMapas.length-1].latitud);
      var lng_fin = double.parse(cuentasMapas[cuentasMapas.length-1].longitud);

      left = min(lat_ini, lat_fin);
      right = max(lat_ini, lat_fin);
      top = max(lng_ini, lng_fin);
      bottom = min(lng_ini,lng_fin);
    }else{

      var lat_ini = double.parse(cuentasMapas[0].latitud);
      var lng_ini = double.parse(cuentasMapas[0].longitud);
      var lat_fin = double.parse(cuentasMapas[0].latitud);
      var lng_fin = double.parse(cuentasMapas[0].longitud);

      left = min(lat_ini, lat_fin);
      right = max(lat_ini, lat_fin);
      top = max(lng_ini, lng_fin);
      bottom = min(lng_ini,lng_fin);
    }

    /* api.currentRoute.first.points.forEach((point) {
      left = min(left, point.latitude);
      right = max(right, point.latitude);
      top = max(top, point.longitude);
      bottom = min(bottom, point.longitude);
    });  */

    var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    );
    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    _mapController.animateCamera(cameraUpdate);
  }
}