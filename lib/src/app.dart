import 'package:epa_movil/src/backend/medicion.dart';
import 'package:epa_movil/src/backend/user.dart';
import 'package:epa_movil/src/backend/usuario_epa.dart';
import 'package:epa_movil/src/connection/server_controller.dart';
import 'package:epa_movil/src/screens/cuentas.dart';
import 'package:epa_movil/src/screens/home_page.dart';
import 'package:epa_movil/src/screens/editar.dart';
import 'package:epa_movil/src/screens/login_page.dart';
import 'package:epa_movil/src/screens/maps.dart';
import 'package:epa_movil/src/screens/orden_mapa.dart';
import 'package:epa_movil/src/screens/register_page.dart';
import 'package:epa_movil/src/screens/registrar_novedad.dart';
import 'package:epa_movil/src/screens/searchCta.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'backend/cuenta.dart';
import 'package:footer/footer.dart';

import 'backend/orden.dart';
import 'components/delivery_screen.dart';
import 'components/direction_provider.dart';

ServerController _serverController = ServerController();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider (
        create: (_) => DirectionProvider(),
    child: MaterialApp(
      title: 'EpaMovil',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
      //home: LoginPage(_serverController, context, title: 'Epa Movil'),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            case "/":
              return LoginPage(_serverController, context, title: 'Epa Movil');
            case "/home":
              UsuarioEpa? loggedUser = settings.arguments as UsuarioEpa?;
              _serverController.loggedUser = loggedUser;
              return HomePage(_serverController, context);
            case "/register":
              return RegisterPage(_serverController, context, title: 'Epa Movil');
            case "/maps":
              return MapsPage(_serverController, context, title: 'Epa Movil');
            case "/cuentasOrden":
              Orden orden = settings.arguments as Orden;
              return CuentasOrden(_serverController, context, orden: orden, title: 'Epa Movil');
            case "/searchCta":
              return SearchCtaPage(_serverController, context, title: 'Epa Movil');
            case "/editar":
              Cuenta? cuenta = settings.arguments as Cuenta?;
              return EditarPage(_serverController, cuenta!);
            case "/novedad":
              Cuenta? cuenta = settings.arguments as Cuenta?;
              return NovedadPage(_serverController, cuenta!);
            case "/mapaOrdenes":
              Orden ordenMapa = settings.arguments as Orden;
              return OrdenMapa(_serverController, context, orden: ordenMapa);
            default:
              return LoginPage(_serverController, context, title: 'Epa Movil');
          }
        });
      },
    ),
    );
  }
}