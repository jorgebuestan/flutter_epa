import 'package:bcrypt/bcrypt.dart';

class UsuarioEpa{
  int? usuario_id;
  String? codigo;
  String? nombre;
  String? apellidos;
  String? email;
  String? pws;
  String? usuario;

  UsuarioEpa({required this.usuario_id, required this.codigo, required this.nombre,required this.apellidos,required this.email,required this.pws,required this.usuario});


  bool login_epa(String nickname, String password) {
    print("Comparar "+password);
    print("Con "+this.pws!);
    final bool checkPassword = BCrypt.checkpw(
      password,
      this.pws!,
    );
    return (this.codigo == nickname) && (checkPassword);
  }

  factory UsuarioEpa.fromJson(Map<String, dynamic> json){

    String email = "";
    if(json['email'] == null){
      email = "";
    }else{
      email = json['email']!;
    }
    return UsuarioEpa(
      usuario_id:json['usuario_id'],
      codigo:json['codigo'],
      nombre:json['nombre'],
      apellidos:json['apellidos'],
      email:json['email'],
      pws:json['pws'],
      usuario:json['usuario'],
    );
  }

  UsuarioEpa.fromMap(dynamic obj) {
    this.usuario_id = obj['usuario_id'];
    this.codigo = obj['codigo'];
    this.nombre = obj['nombre'];
    this.apellidos = obj['apellidos'];
    this.email = obj['email'];
    this.pws = obj['pws'];
    this.usuario = obj['usuario'];
  }

  /*String? get username => this.codigo;
  String? get password => this.pws;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["codigo"] = codigo;
    map["pws"] = pws;
    return map;
  }*/
}