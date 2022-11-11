import 'dart:io';

import 'package:epa_movil/src/backend/user.dart';
import 'package:epa_movil/src/components/image_picker_widget.dart';
import 'package:epa_movil/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:epa_movil/src/connection/db.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  ServerController serverController;
  BuildContext context;

  RegisterPage(this.serverController, this.context, {Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;



  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _counter = 0;
  final bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();

  String userName="", password="";
  final String _errorMessage = "";
  Genrer genrer = Genrer.MALE;
  bool showPassword = false;

  late File imageFile=File('');
  final picker = ImagePicker();
 // late File imageFile;


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

  Future selImagen(op) async{
    var pickedFile;
    if(op==1){
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    }else{
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      if(pickedFile!=null){
        imageFile = File(pickedFile.path);
      }else{
        print('No seleccionaste una foto');
      }
    });

    Navigator.of(context).pop();
  }
  opciones(context){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap:(){
                      selImagen(1);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width:1, color: Colors.grey))
                        ),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text('Tomar una Foto', style: TextStyle(
                               fontSize: 16
                            ),),
                          ),
                          Icon(Icons.camera_alt, color: Colors.blue)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap:(){
                        selImagen(2);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text('Seleccionar una Foto', style: TextStyle(
                                fontSize: 16
                            ),),
                          ),
                          Icon(Icons.image, color: Colors.blue)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap:(){
                        Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.red
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text('Cancelar', style: TextStyle(
                                fontSize: 16,
                              color: Colors.white
                            ), textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
        ImagePickerWidget(
        imageFile: imageFile,
          onImageSelected: (File file) {
            setState(() {
              imageFile = file;
            });
          },
          string: ""
        ),
            SizedBox(
              child: AppBar(
                elevation:0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              height: kToolbarHeight + 25,
            ),
           Center(
                child: Transform.translate(
                  offset: Offset(0, -20),
                  child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      margin: const EdgeInsets.only(left:20, right:20, top:260, bottom:20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:35, vertical:20),
                        child: ListView(
                          //mainAxisSize: MainAxisSize.min,
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
                            const SizedBox(height:20),
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
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Género",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700]),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      RadioListTile(
                                        title: const Text(
                                          "Masculino",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        value: Genrer.MALE,
                                        groupValue: genrer,
                                        onChanged: (value) {
                                          setState(
                                                () {
                                              genrer = value as Genrer;
                                            },
                                          );
                                        },
                                      ),
                                      RadioListTile(
                                        title: const Text(
                                          "Femenino",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        value: Genrer.FEMALE,
                                        groupValue: genrer,
                                        onChanged: (value) {
                                          setState(
                                                () {
                                              genrer = value as Genrer;
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height:20),
                            RaisedButton(
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              textColor: Colors.white,
                              onPressed: ()=> _register(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text("Registrar"),
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
                          ],
                        ),
                      )
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }


  _register(BuildContext context) async {

    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if(imageFile == null) {
        showSnackbar(context, "Seleccione una imagen por favor", Colors.orange);
        return;
      }
      User user = User(
        id: 0,
          genrer: this.genrer,
          nickname: this.userName,
          password: this.password,
          photo: this.imageFile);
      final state = await widget.serverController.addUser(user);

      if(state == false){
        showSnackbar(context, "No se puedo guardar", Colors.orange);
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Informacion"),
              content: const Text("Su usuario ha sido registrado exitosamente"),
              actions: <Widget>[
                FlatButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  void showSnackbar(BuildContext context, String title, Color backColor) {
    _scaffKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
        ),
        backgroundColor: backColor,
      ),
    );
  }
}
