import 'dart:convert';
import 'dart:io';

import 'package:epa_movil/src/advanced/asset_file.dart';
import 'package:epa_movil/src/backend/medicion.dart';
import 'package:epa_movil/src/backend/user.dart';
import 'package:epa_movil/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:epa_movil/src/connection/db.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import '../backend/cuenta.dart';
import 'dart:developer' as developer;
import 'package:styled_text/styled_text.dart';

import '../components/footer.dart';
import '../components/image_picker_widget.dart';
import '../components/menu_desplegable.dart';

class SearchCtaPage extends StatefulWidget {
  ServerController serverController;
  BuildContext context;

  SearchCtaPage(this.serverController, this.context, {Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;



  @override
  State<SearchCtaPage> createState() => _SearchCtaPageState();
}

class _SearchCtaPageState extends State<SearchCtaPage> {

  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;


  void _onItemTapped(int index) {

    if(index==0){
      Navigator.pop(context);
      //Navigator.pushReplacementNamed(context, "/home");
    }
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {

    //getLocation();

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
      body:  Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
              Row(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Icon(Icons.search),
                    Text("Ingresar Cta: "),
                  ],
              ),
            TextField(
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                )
            ),
          ],
      ),
      bottomNavigationBar: FooterEpa(serverController: widget.serverController,),
    );
  }

}