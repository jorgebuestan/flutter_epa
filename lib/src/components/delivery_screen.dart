import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../connection/server_controller.dart';
import 'direction_provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'footer.dart';


class DeliveryScreen extends StatefulWidget {

  ServerController serverController;
  BuildContext context;

  final LatLng fromPoint = LatLng(-2.150423, -79.864413);
  final LatLng toPoint = LatLng(-2.1443138,-79.8631419);


  final LatLng middlePoint = LatLng(-2.1468171,-79.8655008);

  var title;

  DeliveryScreen(this.serverController, this.context, {Key? key, required this.title}) : super(key: key);

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  //final Completer<GoogleMapController> _mapController = Completer();
  //final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _mapController;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ordenes'),
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

  Set<Marker> _createMarkers() {
    var tmp = Set<Marker>();

    tmp.add( //-2.1468171,-79.8655008
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
    );
    return tmp;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    _centerView();
  }
  _centerView() async {
    var api = Provider.of<DirectionProvider>(context, listen: false);

    await _mapController.getVisibleRegion();

    print("buscando direcciones");
    await api.findDirections(widget.fromPoint, widget.toPoint);

    var left = min(widget.fromPoint.latitude, widget.toPoint.latitude);
    var right = max(widget.fromPoint.latitude, widget.toPoint.latitude);
    var top = max(widget.fromPoint.longitude, widget.toPoint.longitude);
    var bottom = min(widget.fromPoint.longitude, widget.toPoint.longitude);

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