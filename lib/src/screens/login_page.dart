import 'package:bcrypt/bcrypt.dart';
import 'package:epa_movil/src/backend/data_init.dart';
import 'package:epa_movil/src/backend/medicion.dart';
import 'package:epa_movil/src/backend/user.dart';
import 'package:epa_movil/src/backend/usuario_epa.dart';
import 'package:epa_movil/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:epa_movil/src/connection/db.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../backend/sincronizar_cuentas.dart';

class LoginPage extends StatefulWidget {
  ServerController serverController;
  BuildContext context;

  LoginPage(this.serverController, this.context, {Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _counter = 0;
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userName="", password="";
  String _errorMessage = "";
  bool showPassword = false;


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    //Style para el ElevatedButton
    final elevatedButtonStyle = ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        onPrimary: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
    );

    //Style para el TextButton
    final textButtonButtonStyle = TextButton.styleFrom(
      primary: Theme.of(context).primaryColor
    );



    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.account_circle_rounded, color: Colors.blue),
        onPressed: () async {

          try{
            final respuesta = await http.post(
              Uri.parse('http://192.168.10.85:88/epaapp/sync/usuarios'),
              headers: <String, String>{
                'X-Authorization': 'hquiiwm@jjsosksk%7mkkklss-jhjskd_haadd%sdassfdsf*ad!',
              },
            ).timeout(const Duration(seconds: 3));
            cargarLogin(context);
            //await DB.truncate_ordenes_epa();
            //await DB.truncate_cuentas_epa();
            //generateOrdenesCuentas(context);

          }catch(e){
            print ("Excepcion: "+e.toString());
            mostrarSinConexion(context);
          }
        },
      ),
        body: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical:60),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade300,
                        Colors.blue.shade900,
                      ]
                  ),
                ),
                child: Image.asset(
                  "assets/images/logo_epa.png",
                  height: 200,
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -20),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              margin: const EdgeInsets.only(left:20, right:20, top:260, bottom:20),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal:35, vertical:20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextFormField(decoration: const InputDecoration(
                                        labelText: "Usuario:"
                                    ),
                                      onSaved: (value){
                                        userName = value!;
                                      },
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return "Este Campo es Obligatorio";
                                        }
                                      },
                                    ),
                                    const SizedBox(height:10),
                                    TextFormField(
                                      initialValue: password,
                                      decoration: InputDecoration(
                                          labelText: "Contraseña:",
                                          suffixIcon: IconButton(
                                            icon: Icon(showPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                showPassword = !showPassword;
                                              });
                                            },
                                          )),
                                      obscureText: !showPassword,
                                      onSaved: (value) {
                                        password = value!;
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Este campo es obligatorio";
                                        }
                                      },
                                    ),
                                    const SizedBox(height:40),
                                    ElevatedButton(
                                      style: elevatedButtonStyle,
                                      onPressed: ()=> _login(context),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Text("Iniciar sesión"),
                                          if (_loading)
                                            Container(
                                              height: 20,
                                              width: 20,
                                              margin: const EdgeInsets.only(left:20),
                                              child: const CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if(_errorMessage.isNotEmpty)
                                      Text(
                                        _errorMessage,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    const SizedBox(height:20),
                                    /*Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'No estas registrado?',
                                  ),
                                  TextButton(
                                    style: textButtonButtonStyle,
                                    child: Text("Registrarse"),
                                    onPressed: (){
                                      _showRegister(context);
                                    },
                                  ),
                                ],
                              ),*/
                                  ],
                                ),
                              )
                          ),
                          Image.asset(
                            "assets/images/gobierno/GobiernoDelEncuentro.png",
                            fit: BoxFit.contain,
                            height: 100,
                            alignment: Alignment.center,
                          ),
                        ]
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }

  void _login(BuildContext context) async{
      if(!_loading){
          if(_formKey.currentState!.validate()){
            _formKey.currentState!.save();
            setState((){
              _loading = true;
              _errorMessage = "";
            });

            //Para pedir permisos de Geolocalizacion al Inicio del Login
            Location location = Location();
            LocationData _locationData = LocationData.fromMap({});

            //Cargar los Usuarios antes del Login Si es que se tiene coneccion
            try{
              final respuesta = await http.post(
                Uri.parse('http://192.168.10.85:88/epaapp/sync/usuarios'),
                headers: <String, String>{
                  'X-Authorization': 'hquiiwm@jjsosksk%7mkkklss-jhjskd_haadd%sdassfdsf*ad!',
                },
              ).timeout(const Duration(seconds: 3));
              cargarLogin(context);
              //await DB.truncate_ordenes_epa();
              //await DB.truncate_cuentas_epa();
              //generateOrdenesCuentas(context);

            }catch(e){
              print ("Excepcion: "+e.toString());
              mostrarSinConexion(context);
            }

            _locationData = await location.getLocation();
            UsuarioEpa? user = await widget.serverController.login_epa(userName.trim().toLowerCase());

            if(userName.trim().toLowerCase()=="guest" && password.trim()=="3p4.4dm1n"){

              UsuarioEpa admin;
              admin = UsuarioEpa(
                  usuario_id: 1,
                  codigo: "guest",
                  nombre: "guest",
                  apellidos:"guest",
                  email:"guest@guest.com",
                  pws:"guest",
                  usuario:"guest");

              Navigator.pop(context);
              Navigator.pushNamed(context,"/home",arguments: admin);
            }

            if(user!=null){

              print("prueba2 "+user.toString());
              print("prueba3 "+user.pws.toString());

              final bool checkPassword = BCrypt.checkpw(
                password.trim(),
                user.pws.toString(),
              );

              if(checkPassword){
                print("Password Valido "); // Navigator.pushNamed(context,"/editar",arguments: Cuenta);
                //Navigator.of(context).pushReplacementNamed("/home", arguments: user);

                //Cargar las Ordenes antes de Entrar al Home

                try{
                  final respuesta = await http.post(
                    Uri.parse('http://192.168.10.85:88/epaapp/ordenes-de-trabajo/'+user.usuario_id.toString()),
                    headers: <String, String>{
                      'X-Authorization': 'hquiiwm@jjsosksk%7mkkklss-jhjskd_haadd%sdassfdsf*ad!',
                    },
                  ).timeout(const Duration(seconds: 3));

                  //await SincronizarCuentas(context, user);
                  await enviarCuentas(context, user);
                  ordenes = [];
                  await generateOrdenesCuentas(context, user);
                  //await generateOrdenesCuentas(context, user);
                  Navigator.pop(context);
                  Navigator.pushNamed(context,"/home",arguments: user);

                }catch(e){
                  //print ("Excepcion: "+e.toString());
                  //mostrarSinConexion2(context);
                  //

                  //Cargar Ordenes sin Conexión
                  print("Numero de Ordenes");
                  print(ordenes.length);

                  ordenes = await DB.ordenes_epa();
                  cuentas = await DB.cuentas_epa();

                  for (int i = 0; i < ordenes.length; i++) {
                    ordenes[i].cuentasOrdenes = [];
                    ordenes[i].cuentasOrdenes = await DB.cuentas_epa_por_orden(ordenes[i].secuencial_orden);

                    for (int j = 0; j < ordenes[i].cuentasOrdenes.length; j++) {
                      ordenes[i].cuentasOrdenes[j].cultivosCuenta = await DB.cultivos_epa_por_cuenta(ordenes[i].cuentasOrdenes[j].numero_cuenta);
                    }
                  }
                  for (int k = 0; k < cuentas.length; k++) {
                    cuentas[k].cultivosCuenta = [];
                    cuentas[k].cultivosCuenta = await DB.cultivos_epa_por_cuenta(cuentas[k].numero_cuenta);
                  }
                }
                //await generateOrdenesCuentas(context, user);
                Navigator.pushReplacementNamed(widget.context,"/home",arguments: user);
              }else{
                print("Password No Valido ");
                setState(() {
                  _errorMessage = "Usuario o Password Incorrectos";
                  _loading =  false;
                });
              }

              //Navigator.of(context).pushReplacementNamed("/home", arguments: user);
            }else{
              setState(() {
                _errorMessage = "Usuario o Password Incorrectos";
                _loading =  false;
              });
            }
          }
      }
  }

  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/register',
    );
  }

  @override
  void initState(){
    super.initState();
    widget.serverController.init(widget.context);

    // Create anonymous function:
    /*    () async {
      await generateOrdenesCuentas();
      setState(() {
        ordenes;
      });
    } (); */
  }
}
