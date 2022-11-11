import 'package:epa_movil/src/backend/medicion.dart';
import 'package:epa_movil/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:epa_movil/src/screens/home_page.dart';
import '../backend/data_init.dart';
import '../backend/sincronizar_cuentas.dart';
import 'package:http/http.dart' as http;

import '../connection/db.dart';

class MenuDesplegable extends StatelessWidget {

  final ServerController serverController;
  const MenuDesplegable({required this.serverController, Key? key}) : super(key: key);

  get accountName => Text(serverController.loggedUser!.codigo!, style: TextStyle(color: Colors.white),);
  get accountEmail => null;


  @override

  Widget build (BuildContext context) {
    return Drawer(
       child: Column(
         children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: accountName,
                accountEmail: accountEmail,
                currentAccountPicture: const CircleAvatar(
                  backgroundImage:AssetImage( "assets/images/guest.png"),
                   //backgroundImage: FileImage('')
                ),
            ),
           ListTile(
             title: const Text(
               "Inicio",
               style: TextStyle(fontSize:18),
             ),
             leading: const Icon(
               Icons.home,
               color: Colors.blue,
             ),
             onTap: () {
               Navigator.pop(context);
               ///Navigator.pushReplacementNamed(context, "/maps");
               //Navigator.pushNamed(context,"/home");
               Navigator.pushNamed(context,"/home",arguments: serverController.loggedUser);
             },
           ),
          /* ListTile(
             title: const Text(
               "Cargar Ordenes",
               style: TextStyle(fontSize:18),
             ),
             leading: const Icon(
               Icons.wifi_protected_setup,
               color: Colors.blue,
             ),
             onTap: () async {

               try{
                 final respuesta = await http.post(
                   Uri.parse('http://192.168.10.85:88/epaapp/ordenes-de-trabajo/'+serverController.loggedUser!.usuario_id.toString()),
                   headers: <String, String>{
                     'X-Authorization': 'hquiiwm@jjsosksk%7mkkklss-jhjskd_haadd%sdassfdsf*ad!',
                   },
                 ).timeout(const Duration(seconds: 3));
                 await generateOrdenesCuentas(context, serverController.loggedUser!);
                 Navigator.pop(context);
                 Navigator.pushNamed(context,"/home",arguments: serverController.loggedUser);

               }catch(e){
                 print ("Excepcion: "+e.toString());
                 mostrarSinConexion(context);
               }

             },
           ), */
           ListTile(
             title: const Text(
               "Registrar Inspección",
               style: TextStyle(fontSize:18),
             ),
             leading: const Icon(
               Icons.input,
               color: Colors.blue,
             ),
             onTap: () {
               Navigator.pop(context);
             },
           ),
           ListTile(
             title: const Text(
               "Ver Ruta por Orden de  Trabajo",
               style: TextStyle(fontSize:18),
             ),
             leading: const Icon(
               Icons.location_on,
               color: Colors.blue,
             ),
             onTap: () {
               Navigator.pop(context);
               Navigator.pushReplacementNamed(context, "/maps"); //searchCta
               //Navigator.pushNamed(context,"/maps");
             },
           ),
           ListTile(
             title: const Text(
               "Buscar Cuenta",
               style: TextStyle(fontSize:18),
             ),
             leading: const Icon(
               Icons.search,
               color: Colors.blue,
             ),
             onTap: () {
               Navigator.pop(context);
               //Navigator.pushNamed(context,"/searchCta");
               Navigator.pushReplacementNamed(context, "/searchCta"); //searchCta
             },
           ),
           ListTile(
             title: const Text(
               "Sincronizar registros",
               style: TextStyle(fontSize:18),
             ),
             leading: const Icon(
               Icons.wifi_protected_setup,
               color: Colors.blue,
             ),
             onTap: () async {

               try{
                 final respuesta = await http.post(
                   Uri.parse('http://192.168.10.85:88/epaapp/sync/usuarios'),
                   headers: <String, String>{
                     'X-Authorization': 'hquiiwm@jjsosksk%7mkkklss-jhjskd_haadd%sdassfdsf*ad!',
                   },
                 ).timeout(const Duration(seconds: 3));

                 //SHOW dialog enviando cuenta

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
                                   "Sincronizando Cuentas con el Sistema Epacom...",
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

                 //Navigator.pop(context);
                 //await SincronizarCuentas(context, serverController.loggedUser!);
                 await enviarCuentas(context, serverController.loggedUser!);
                 //Navigator.pop(context);

                 await DB.truncate_ordenes_epa();
                 await DB.truncate_cuentas_epa();
                 await DB.truncate_cultivos_epa();
                 ordenes = [];
                 cuentas = [];
                 cultivos = [];

                 await blanquearOrdenesCuentas(context, serverController.loggedUser!);
                 await generateOrdenesCuentas(context, serverController.loggedUser!);
                 //await generateOrdenesCuentas(context, serverController.loggedUser!);
                 //Navigator.pushNamed(context,"/home",arguments: serverController.loggedUser);

               }catch(e){
                 print ("Excepcion: "+e.toString());
                 mostrarSinConexion(context);
               }

             },
           ),
           Expanded(
             child: Container(

             ),
           ),
           ListTile(
             title: const Text(
               "Cerrar Sesión",
               style: TextStyle(fontSize:18),
             ),
             leading: const Icon(
               Icons.power_settings_new,
               color: Colors.blue,
             ),
             onTap: () {
               Navigator.pop(context);
               Navigator.pushReplacementNamed(context, "/");
             },
           )
         ],
       ),
    );
  }
}