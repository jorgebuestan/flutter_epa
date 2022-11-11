import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef OnImageSelected = Function(File imageFile);

class ImagePickerWidget extends StatelessWidget {
  late final File imageFile;
  final OnImageSelected onImageSelected;
  final ImagePicker _picker = ImagePicker();
  late final String string;
  ImagePickerWidget({required this.imageFile, required this.onImageSelected, required this.string});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
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
        icon: Icon(Icons.camera_alt),
        onPressed: () {
          _showPickerOptions(context);
        },
        iconSize: 90,
        color: Colors.white,
      ),
    );
  }

  void _showPickerOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Camara"),
              onTap: () {
                Navigator.pop(context);
                //_showPickImage(context, ImageSource.camera);
                _getFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Galería"),
              onTap: () {
                Navigator.pop(context);
                //_showPickImage(context, ImageSource.gallery);
                _getFromGallery();
              },
            ),
          ],
        );
      },
    );
  }

  /*void _showPickImage(BuildContext context, source) async {
    var image = await  ImagePicker().pickImage(source: source);
    this.onImageSelected(image);
  }*/
  /// Get from gallery
  /*Future _getFromGallery() async {
    /*var pickedFile;
    pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    this.onImageSelected(pickedFile);*/
    var pickedFile;
    pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    this.onImageSelected(pickedFile);

    //this.imageFile = File(pickedFile.path);
  }*/

  /// Get from Camera
 /* Future _getFromCamera() async {
    var pickedFile;
    pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    this.onImageSelected(pickedFile);
    //this.imageFile = File(pickedFile.path);
  } */

  Future _getFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    final File? file = File(image!.path);

    this.onImageSelected(file!);
    this.string = base64Encode(file.readAsBytesSync());
  }

  Future _getFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    final File? file = File(image!.path);
    this.onImageSelected(file!);
    this.string = base64Encode(file.readAsBytesSync());
  }

}
