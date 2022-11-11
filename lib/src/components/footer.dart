import 'package:epa_movil/src/backend/medicion.dart';
import 'package:epa_movil/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:epa_movil/src/screens/home_page.dart';

class FooterEpa extends StatelessWidget {

  final ServerController serverController;
  const FooterEpa({required this.serverController, Key? key}) : super(key: key);

  @override

  Widget build (BuildContext context) {
    return  BottomAppBar(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.pushNamed(context,"/home",arguments: serverController.loggedUser);
                  },
                ),
                Image.asset(
                  "assets/images/gobierno/GobiernoDelEncuentro.png",
                  fit: BoxFit.contain,
                  height: 50,
                  alignment: Alignment.center,
                ),
                /*IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.pushNamed(context,"/home",arguments: serverController.loggedUser);
                  },
                ),*/
                Text(""),
              ],
            )));
  }
}