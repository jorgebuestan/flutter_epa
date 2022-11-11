import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:epa_movil/src/advanced/asset_file.dart';
import 'package:epa_movil/src/backend/medicion.dart';
import 'package:epa_movil/src/backend/user.dart';
import 'package:epa_movil/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:epa_movil/src/connection/db.dart';
import 'package:flutter/services.dart';
import 'package:image_compression/image_compression.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';

import '../backend/cuenta.dart';
import 'dart:developer' as developer;
import 'package:styled_text/styled_text.dart';

import '../components/footer.dart';
import '../components/image_picker_widget.dart';

import 'package:utm/utm.dart';

import 'package:image/image.dart' as img;

class EditarPage extends StatefulWidget {

  ServerController serverController;
  final Cuenta cuenta;
  EditarPage(this.serverController, this.cuenta, {Key? key}) : super(key: key);

  @override
  State<EditarPage> createState() => _EditarPageState();
}

class _EditarPageState extends State<EditarPage> {

  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final latitudController = TextEditingController();
  final longitudController = TextEditingController();
  final altitudController = TextEditingController();
  final lecturaUTController = TextEditingController();
  final lecturaAnteriorController = TextEditingController();
  final lecturaActualController = TextEditingController();
  final observacionController = TextEditingController();
  final ImagenController = TextEditingController();
  final ramalController = TextEditingController();
  final tomaController = TextEditingController();
  bool _switchCurrentValue = false;
  bool _switchUnidadMedida = false;

  //Para Controlar que el TextField sea solo cuando haya Medicion

  bool _isReadonlyLecturaUTM = false;
  bool _isDisabledLecturaUTM = false;
  bool _isReadonlyMedicion = false;
  bool _isDisabledMedicion = false;

  Color fillColor = Colors.grey.shade300;



  File? imageExample;
  String imageData="";
  final pickerExample = ImagePicker();
  TextEditingController controllerImageExample = TextEditingController();

  Future choiceImage() async{
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(pickedImage !=null){

      imageExample = File(pickedImage.path);
      imageData = base64Encode(imageExample!.readAsBytesSync());
      //return imageData;
    }else{
      imageData = "";
    }
    setState(() {
    });
    print (imageData);
  }

  Location location = Location();
  late File imageFile=File('');
  final picker = ImagePicker();
  // late File imageFile;

  bool _serviceEnabled=false;
  PermissionStatus _permissionGranted = PermissionStatus.granted;
  LocationData _locationData = LocationData.fromMap({});

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);



  @override
  Widget build(BuildContext context) {

    final AssetBundle assetBundle = DefaultAssetBundle.of(context);


    Color getColor(){
      if(_isReadonlyMedicion == false){
        return Colors.grey.shade300;
      }
      else{
        return Colors.grey.shade500;
      }
    }


    //Verificacion de si la Cuenta ya ha sido sincronizada, no permita entrar nuevamente al Formulario de Edicion
    if (widget.cuenta.sincronizado!=0){
      Navigator.pushNamed(context,"/home",arguments: widget.serverController.loggedUser);
    }

    showImage(String image){
      print("imagen vacía: "+ image.isNotEmpty.toString() );
      print(image);
      try{
        print("entra al try");
        print(image.toString());
        if (image.isNotEmpty || (image.isNotEmpty )){
          return Image.memory(base64Decode(image));
        }
      }catch(e){
        print("EX: "+e.toString());
      }
    }

    if (widget.cuenta.nombre_cliente.isNotEmpty){
      nombreController.text = widget.cuenta.nombre_cliente;
    }
    if (widget.cuenta.direccion.isNotEmpty){
      descripcionController.text = widget.cuenta.direccion;
    }
    if (widget.cuenta.latitud.isNotEmpty){
      latitudController.text = widget.cuenta.latitud;
    }
    if (widget.cuenta.longitud.isNotEmpty){
      longitudController.text = widget.cuenta.longitud;
    }
    if (widget.cuenta.altitud.isNotEmpty){
      altitudController.text = widget.cuenta.altitud;
    }
    if (widget.cuenta.lecturaUT.isNotEmpty){
      lecturaUTController.text = widget.cuenta.lecturaUT;
    }
    if (widget.cuenta.lectura_anterior.isNotEmpty ){
      lecturaAnteriorController.text = widget.cuenta.lectura_anterior;
    }
    if (widget.cuenta.lectura_actual.isNotEmpty){
      lecturaActualController.text = widget.cuenta.lectura_actual;
    }
    if (widget.cuenta.observacion.isNotEmpty){
      observacionController.text = widget.cuenta.observacion;
    }

    if (widget.cuenta.ramal.isNotEmpty){
      ramalController.text = widget.cuenta.ramal;
    }

    if (widget.cuenta.toma.isNotEmpty){
      tomaController.text = widget.cuenta.toma;
    }

    if (widget.cuenta.imagen.isNotEmpty){
      imageData = widget.cuenta.imagen;
      ImagenController.text = widget.cuenta.imagen;
    }
    /* if(widget.cuenta.sin_lectura == 0){
      _switchCurrentValue = false;
    }else{
      _switchCurrentValue = true;
    } */
    //getLocation();
    print("UTM: "+widget.cuenta.lecturaUTBack);
    print("Fecha: "+widget.cuenta.fechaRegistro);

    //Funcion para Seleccionar la Imagen
    void _showPickerOptions(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {

          return SimpleDialog(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Cámara"),
                onTap: () async {
                  Navigator.pop(context);
                  //_showPickImage(context, ImageSource.camera);
                  //_getFromCamera();
                  var pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

                  if(pickedImage !=null){

                    imageExample = File(pickedImage.path);
                    //imageData = base64Encode(imageExample!.readAsBytesSync());

                    final image = img.decodeImage(imageExample!.readAsBytesSync())!;
                    // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
                    final thumbnail = img.copyResize(image, width: 500);

                    // Save the thumbnail as a PNG.
                    //File comp = File('thumbnail.png').writeAsBytesSync(img.encodePng(thumbnail));
                    imageData = base64Encode(img.encodePng(thumbnail));


                    print('Output size = ${thumbnail.length}');
                    /* final input = ImageFile(
                      rawBytes: imageExample!.readAsBytesSync(),
                      filePath: imageExample!.path,
                    );
                    final output = compress(ImageFileConfiguration(input: input));

                    print('Input size = ${imageExample!.lengthSync()}');
                    print('Output size = ${output.sizeInBytes}');
                    */

                    widget.cuenta.imagen = imageData;
                    //showImage(imageData );
                    //return imageData;
                  }else{
                    imageData = "";
                  }
                  setState(() {
                    widget.cuenta.ramal = ramalController.text;
                    widget.cuenta.toma = tomaController.text;
                    widget.cuenta.lecturaUT = lecturaUTController.text;
                    widget.cuenta.lectura_actual = lecturaActualController.text;
                    widget.cuenta.observacion = observacionController.text;
                    imageData;
                  });
                  print ("Modificando Imagen desde Cámara");
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Galería"),
                onTap: () async {
                  Navigator.pop(context);
                  //_showPickImage(context, ImageSource.gallery);
                  //_getFromGallery();

                  var pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

                  if(pickedImage !=null){

                    imageExample = File(pickedImage.path);
                    imageData = base64Encode(imageExample!.readAsBytesSync());
                    widget.cuenta.imagen = imageData;
                    //showImage(imageData );
                    //return imageData;
                  }else{
                    imageData = "";
                  }
                  setState(() {
                    widget.cuenta.ramal = ramalController.text;
                    widget.cuenta.toma = tomaController.text;
                    widget.cuenta.lecturaUT = lecturaUTController.text;
                    widget.cuenta.lectura_actual = lecturaActualController.text;
                    widget.cuenta.observacion = observacionController.text;
                    imageData;
                  });
                  print ("Modificando Imagen desde Galeria");
                },
              ),
            ],
          );
        },
      );
    }

    //final utm = UTM.fromLatLon(lat: -2.150390, lon: -79.864376);
    final utm = UTM.fromLatLon(lat: -2.38161318, lon: -80.223441758);
    print('zone: ${utm.zone}');
    print('N: ${utm.northing}');
    print('E: ${utm.easting}');
    print('lat: ${utm.lat}');
    print('lat: ${utm.lon}');
    print('zone letter: ${utm.zoneLetter}');
    print('zone number: ${utm.zoneNumber}');

    final latlon = UTM.fromUtm(
      easting: utm.easting,
      northing: utm.northing,
      zoneNumber: utm.zoneNumber,
      zoneLetter: utm.zoneLetter,
    );
    print('lat: ${latlon.lat}');
    print('lon: ${latlon.lon}');

    UTM.fromLatLon(lat: -30, lon: -150, type: GeodeticSystemType.bessel);
    UTM.fromUtm(
      easting: utm.easting,
      northing: utm.northing,
      zoneNumber: utm.zoneNumber,
      zoneLetter: utm.zoneLetter,
      type: GeodeticSystemType.grs80,
    );

    print ("Numero de Cultivos");
    print (widget.cuenta.cultivosCuenta.length);

    return Scaffold(
      appBar: AppBar(
          title: const Text("EpaMovil"),
          actions: [
            Image.asset(
              "assets/images/logo_epa.png",
              fit: BoxFit.contain,
              height: 15,
            ),
          ]
      ),
      body: SingleChildScrollView(
        child: Padding(
          child: Form (
              key: _formKey,
              child: Column(
                  children: <Widget>[
                    Text(
                      "Cuenta: "+ widget.cuenta.numero_cuenta,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child:
                        StyledText(
                          text: '<b>Nombre: </b> <t>'+ widget.cuenta.nombre_cliente+'<t/>',
                          tags: {
                            'b': StyledTextTag(
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                            't': StyledTextTag(
                                style: const TextStyle(fontSize: 18.0)),
                          },
                        )
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child:
                        StyledText(
                          text: '<b>Dirección: </b> <t>'+ widget.cuenta.direccion+'<t/>',
                          tags: {
                            'b': StyledTextTag(
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                            't': StyledTextTag(
                                style: const TextStyle(fontSize: 18.0)),
                          },
                        )
                    ),
                    /* Align(
                          alignment: Alignment.center,
                          child:
                          StyledText(
                            text: '<b>Requerimiento hídrico</b>',
                            tags: {
                              'b': StyledTextTag(
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                              't': StyledTextTag(
                                  style: const TextStyle(fontSize: 18.0)),
                            },
                          )
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child:
                          StyledText(
                            text: '<b>Tipo Cultivo: </b> <t>'+ widget.cuenta.tipo_cultivo+'<t/>',
                            tags: {
                              'b': StyledTextTag(
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                              't': StyledTextTag(
                                  style: const TextStyle(fontSize: 18.0)),
                            },
                          )
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child:
                          StyledText(
                            text: '<b>Número de hectáreas: </b> <t>'+ widget.cuenta.numero_hectareas+'<t/>',
                            tags: {
                              'b': StyledTextTag(
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                              't': StyledTextTag(
                                  style: const TextStyle(fontSize: 18.0)),
                            },
                          )
                      ),*/
                    Align(
                        alignment: Alignment.centerLeft,
                        child:
                        StyledText(
                          text: '<b>Ramal: </b> <t>'+ widget.cuenta.ramal+'<t/>',
                          tags: {
                            'b': StyledTextTag(
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                            't': StyledTextTag(
                                style: const TextStyle(fontSize: 14.0)),
                          },
                        )
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child:
                        StyledText(
                          text: '<b>Toma: </b> <t>'+ widget.cuenta.toma+'<t/>',
                          tags: {
                            'b': StyledTextTag(
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                            't': StyledTextTag(
                                style: const TextStyle(fontSize: 14.0)),
                          },
                        )
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const <Widget>[
                        SizedBox(
                          width: 20,
                          child: Text(" "),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text("Cultivo"),
                        ),
                        Text("     "),
                        SizedBox(
                          width: 120,
                          child: Text("Tipo de Riego"),
                        ),
                        Text("     "),
                        SizedBox(
                          width: 100,
                          child: Text("Hectareas"),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 20,
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.cuenta.cultivosCuenta.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 20,
                              child: Text(" "),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(widget.cuenta.cultivosCuenta[index].descripcion),
                            ),
                            Text("     "),
                            SizedBox(
                              width: 120,
                              child: Text(widget.cuenta.cultivosCuenta[index].tipo_riego),
                            ),
                            Text("     "),
                            SizedBox(
                              width: 60,
                              child: Text(
                                  widget.cuenta.cultivosCuenta[index].numero_hectareas,
                                  textAlign: TextAlign.right
                              ),
                            ),
                          ],
                        );ListTile(
                          title: Text(widget.cuenta.cultivosCuenta[index].descripcion),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child:
                        StyledText(
                          text: '<b>Ubicación: </b> <t>'+ widget.cuenta.latitud+', ' + widget.cuenta.longitud + ', '+ widget.cuenta.altitud +'<t/>',
                          tags: {
                            'b': StyledTextTag(
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                            't': StyledTextTag(
                                style: const TextStyle(fontSize: 14.0)),
                          },
                        )
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child:
                        StyledText(
                          text: '<b>Ubicación Medidor: </b> <t>'+ widget.cuenta.lecturaUTBack  +'<t/>',
                          tags: {
                            'b': StyledTextTag(
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                            't': StyledTextTag(
                                style: const TextStyle(fontSize: 14.0)),
                          },
                        )
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child:
                        StyledText(
                          text: '<b>Última lectura: </b> <t>'+ widget.cuenta.lectura_anterior+'<t/>',
                          tags: {
                            'b': StyledTextTag(
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                            't': StyledTextTag(
                                style: const TextStyle(fontSize: 14.0)),
                          },
                        )
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    /*  */
                    /* TextFormField(
                        controller: ramalController,
                        validator: (value) {
                          //if (value!.isEmpty) {
                            //return "El Ramal debe ser obligatorio";
                          //}
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: "Ramal"
                        ),
                        readOnly: true,
                      ),
                      TextFormField(
                        controller: tomaController,
                        validator: (value) {
                          //if (value!.isEmpty) {
                            //return "La Toma debe ser obligatoria";
                          //}
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: "Toma"
                        ),
                        readOnly: true,
                      ), */

                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: <Widget>[
                        SizedBox( // <-- SEE HERE
                          width: 200,
                          child: TextFormField(
                            controller: lecturaUTController,
                            readOnly: _isReadonlyLecturaUTM,
                            enabled: !_isDisabledLecturaUTM,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "La Lectura UTM debe ser obligatoria";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "Lectura UTM",
                              filled: true, //<-- SEE HERE
                              fillColor: getColor(),
                            ),

                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox( // <-- SEE HEREE
                          height: 60,
                          width: 200,
                          child: TextFormField(
                            controller: lecturaActualController,
                            readOnly: _isReadonlyMedicion,
                            enabled: !_isDisabledMedicion,
                            decoration: InputDecoration(
                              labelText: "Agregar Medición",
                              filled: true, //<-- SEE HERE
                              fillColor: getColor(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "La Medición ser obligatoria";
                              }
                              if (imageData.isEmpty){
                                return "Debe seleccionar una imágen";
                              }
                              if(lecturaAnteriorController.text.isNotEmpty){
                                var anterior = double.parse(lecturaAnteriorController.text);
                                var actual = double.parse(lecturaActualController.text);
                                if(actual<anterior){
                                  return "La lectura no debe ser menor a la lectura anterior";
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('m3', textAlign: TextAlign.center),
                        Switch(
                          value: _switchUnidadMedida,
                          onChanged: (bool valueMed) {



                            setState(() {
                              _switchUnidadMedida = valueMed;
                              if(_switchUnidadMedida == false){
                                fillColor = Colors.grey.shade500;
                              }else{
                                fillColor = Colors.grey.shade300;
                              }
                              fillColor = Colors.red;

                              widget.cuenta.ramal = ramalController.text;
                              widget.cuenta.toma = tomaController.text;
                              widget.cuenta.lecturaUT = lecturaUTController.text;
                              widget.cuenta.lectura_actual = lecturaActualController.text;
                              widget.cuenta.observacion = observacionController.text;
                              imageData;

                            });
                            if(_switchUnidadMedida==true){
                              widget.cuenta.unidad_medida = "gal";
                            }else{
                              widget.cuenta.unidad_medida = "m3";
                            }
                          },
                        ),
                        Text('galones', textAlign: TextAlign.center),
                      ],
                    ),


                    Row(
                        children: <Widget>[
                          Text('No se puede realizar la Medicion', textAlign: TextAlign.center),
                          Switch(
                            value: _switchCurrentValue,
                            onChanged: (bool valueIn) {


                              setState(() {
                                _switchCurrentValue = valueIn;

                                _isReadonlyLecturaUTM = valueIn;
                                _isDisabledLecturaUTM = valueIn;
                                _isReadonlyMedicion = valueIn;
                                _isDisabledMedicion  = valueIn;
                              });
                              if(_switchCurrentValue==true){
                                //Navigator.pushNamed(context,"/home",arguments: widget.serverController.loggedUser);
                                //Navigator.pushNamed(context,"/novedad",arguments: widget.cuenta);
                              }
                            },
                          ),
                        ],
                      ),

                    TextFormField(
                      controller: observacionController,
                      maxLines: 6,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Debe escribir una Observación";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: "Observacion"
                      ),

                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        // choiceImage();
                        _showPickerOptions(context);
                      },
                    ),
                    Visibility(
                      visible: false,
                      child: TextFormField(
                        controller: ImagenController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Debe Seleccionar una Imagen";
                          }
                          return null;
                        },
                      ),
                    ),
                    imageData.isEmpty ? Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.cyan.shade300,
                              Colors.cyan.shade800,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          image: imageFile != null
                              ? DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover)
                              : null),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () {
                          _showPickerOptions(context);
                        },
                        iconSize: 90,
                        color: Colors.white,
                      ),
                    ) :InkWell(
                      child: SizedBox(child: showImage(imageData ), width: 200,),
                      onTap: () {
                        _showPickerOptions(context);
                      },
                    ) ,
                    /* ImagePickerWidget(
                        imageFile: imageFile,
                        onImageSelected: (File file) {
                          setState(() {
                            observacionController.text = "prueba";
                            widget.cuenta.observacion;
                            imageFile = file;
                          });
                        },
                        string: imageData
                      ), */
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          //getLocation();
                          _serviceEnabled = await location.serviceEnabled();
                          if (!_serviceEnabled) {
                            _serviceEnabled = await location.requestService();
                            if (!_serviceEnabled) {
                              return;
                            }
                          }
                          _permissionGranted = await location.hasPermission();
                          if (_permissionGranted == PermissionStatus.denied) {
                            _permissionGranted = await location.requestPermission();
                            if (_permissionGranted != PermissionStatus.granted) {
                              return;
                            }
                          }
                          _locationData = await location.getLocation();
                          setState(() {

                          });

                          if (_formKey.currentState!.validate()) {

                            if (widget.cuenta.cuenta_id > 0 ) {
                              print("Latitud Controller: "+latitudController.text);

                              developer.log('log me', name: 'my.app.category');
                              //developer.log(latitudController.text, name: 'my.app.category');
                              //developer.log(latitudController.text.substring(1, latitudController.text.length - 1), name: 'my.app.category');

                              widget.cuenta.nombre_cliente = nombreController.text;
                              widget.cuenta.direccion = descripcionController.text;
                              widget.cuenta.latitud =  _locationData.latitude!.toString();
                              widget.cuenta.longitud = _locationData.longitude!.toString();
                              widget.cuenta.altitud = _locationData.altitude!.toString();
                              widget.cuenta.lecturaUT = lecturaUTController.text;
                              widget.cuenta.lectura_actual = lecturaActualController.text;
                              widget.cuenta.observacion = observacionController.text;
                              widget.cuenta.ramal = ramalController.text;
                              widget.cuenta.toma = tomaController.text;
                              widget.cuenta.completado = 1;
                              widget.cuenta.sin_lectura = 0;

                              //Para calcular la Fecha
                              final DateTime now = DateTime.now();
                              widget.cuenta.fechaRegistro = now.toString();

                              final utm = UTM.fromLatLon(lat: _locationData.latitude!.toDouble(), lon: _locationData.longitude!.toDouble());
                              widget.cuenta.lecturaUTBack = utm.zone.toString() + ", " + utm.northing.toString()+ ", " + utm.easting.toString();

                              //widget.cuenta.imagen = base64Encode(imageFile.readAsBytesSync()).toString();
                              widget.cuenta.imagen = imageData;

                              //jbuestan
                              print("Update Cuenta");
                              DB.update_cuentas_epa(widget.cuenta);
                              //developer.log(base64Encode(imageFile.readAsBytesSync()).toString(), name: 'my.app.category');
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
                                                "Guardando Registro...",
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

                              DB.update_cuentas_epa(widget.cuenta);
                              Navigator.pushNamed(context,"/home",arguments: widget.serverController.loggedUser);
                            }
                            else {
                              DB.insertar_medicion(Medicion(id:0, nombre: nombreController.text, descripcion: descripcionController.text, latitud: _locationData.latitude!, longitud: _locationData.longitude!, altitud: _locationData.altitude!));
                            }
                            Navigator.pushNamed(context,"/home",arguments: widget.serverController.loggedUser);
                          }
                        },
                        child: const Text("Guardar"))
                  ]
              )
          ),
          padding: const EdgeInsets.all(15),
        ),
      ),
      bottomNavigationBar: FooterEpa(serverController: widget.serverController,),
    );
  }

  Future<void> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
    });
  }
}