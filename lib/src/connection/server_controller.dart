import 'package:epa_movil/src/backend/data_provider.dart';
import 'package:epa_movil/src/backend/usuario_epa.dart';
import 'package:epa_movil/src/connection/db.dart';
import 'package:flutter/widgets.dart';
import 'package:epa_movil/src/backend/data_init.dart';
import 'package:epa_movil/src/models/models.dart';
import '../backend/user.dart';

class ServerController {
  UsuarioEpa? loggedUser;

  void init(BuildContext context) {

    //DB.truncate_epa_medicion();
    DB.create_epa_medicion();

    //DB.truncate_usuario_epa();
    DB.create_usuario_epa();

    //generateData(context);
    //cargarLogin(context);
  }

  Future<User?> login(String userName, String password) async {
    return await backendLogin(userName, password);
  }

  Future<bool> addUser(User nUser) async {
    return await addUser(nUser);
  }

  Future<UsuarioEpa?> login_epa(String userName) async {
    UsuarioEpa? user = await backendLoginEpa(userName);
    loggedUser = user;
    return user;
  }

}