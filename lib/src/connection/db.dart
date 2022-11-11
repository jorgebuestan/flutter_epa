import 'package:epa_movil/src/backend/medicion.dart';
import 'package:epa_movil/src/backend/user.dart';
import 'package:epa_movil/src/backend/usuario_epa.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../backend/cuenta.dart';
import '../backend/cultivo.dart';
import '../backend/orden.dart';


class DB {
  static Future<Database> _openDB() async {

    return openDatabase(join(await getDatabasesPath(), 'epa_user.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE epa_user ("
                "id INTEGER PRIMARY KEY Autoincrement, "
                "nickname TEXT, "
                "password TEXT"
                ")",
          );
        },  version:1 );

  }

  static Future<Database> _openDB2() async {

    return openDatabase(join(await getDatabasesPath(), 'epa_medicion.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE epa_medicion ("
                "id INTEGER PRIMARY KEY Autoincrement, "
                "nombre TEXT, "
                "descripcion TEXT, "
                "latitud double, "
                "longitud double, "
                "altitud double"
                ")",
          );
        },  version:1 );

  }

  static Future<Database> _openDB3() async {

    return openDatabase(join(await getDatabasesPath(), 'user_epacom.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE user_epacom ("
                "usuario_id INTEGER PRIMARY KEY Autoincrement,"
                "codigo TEXT,"
                "nombre TEXT,"
                "apellidos TEXT,"
                "email TEXT,"
                "pws TEXT,"
                "usuario TEXT"
                ")",
          );
        },  version:1 );
  }

  static Future<Database> _openDB4() async {

    return openDatabase(join(await getDatabasesPath(), 'epa_ordenes.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE epa_ordenes ("
                "orden_id INTEGER PRIMARY KEY Autoincrement,"
                "secuencial_orden TEXT,"
                "numero_cuentas integer,"
                "progreso double,"
                "cuentasHechas integer,"
                "sistema TEXT,"
                "fechaOrden TEXT"
                ")",
          );
        },  version:1 );
  }

  static Future<Database> _openDB5() async {

    return openDatabase(join(await getDatabasesPath(), 'epa_cuentas.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE epa_cuentas ("
                "cuenta_id INTEGER PRIMARY KEY Autoincrement,"
                "secuencial_orden TEXT,"
                "numero_cuenta TEXT,"
                "nombre_cliente TEXT,"
                "direccion TEXT,"
                "ramal TEXT,"
                "toma TEXT,"
                "latitud TEXT,"
                "longitud TEXT,"
                "altitud TEXT,"
                "lecturaUT TEXT,"
                "lecturaUTBack TEXT,"
                "lectura_anterior TEXT,"
                "lectura_actual TEXT,"
                "observacion TEXT,"
                "fechaRegistro TEXT,"
                "imagen BLOB,"
                "completado INTEGER,"
                "sincronizado INTEGER,"
                "isExpanded INTEGER,"
                "tieneNovedad INTEGER,"
                "unidad_medida TEXT,"
                "sin_lectura INTEGER"
                ")",
          );
        },  version:1 );
  }

  static Future<Database> _openDB6() async {

    return openDatabase(join(await getDatabasesPath(), 'epa_cultivos.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE epa_cultivos ("
                "cultivo_id INTEGER PRIMARY KEY Autoincrement,"
                "numero_cuenta TEXT,"
                "descripcion TEXT,"
                "numero_hectareas TEXT,"
                "tipo_riego TEXT"
                ")",
          );
        },  version:1 );
  }

  static Future<Future<int>> insert(User user) async{

    Database  database = await _openDB();

    return database.insert("epa_user", user.toMap());
  }

  static Future<Future<int>> delete(User user) async {

    Database database = await _openDB();

    return database.delete("epa_user", where: "id = ?", whereArgs: [user.id]);
  }

  static Future<Future<int>> update(User user) async {

    Database database = await _openDB();

    return database.update("epa_user", user.toMap(),  where: "id = ?", whereArgs: [user.id]);
  }

  static Future<List<User>> usuarios() async {

    Database database = await _openDB();
    final List<Map<String, dynamic>> usuariosMap = await database.query("epa_user");

    return List.generate(usuariosMap.length,
            (i) => User(
            id: usuariosMap[i]['id'],
            nickname: usuariosMap[i]['nickname'],
            password: usuariosMap[i]['password'],
            genrer: usuariosMap[i]['genrer'],
            photo: usuariosMap[i]['photo']

        ));
  }

  static Future<void> insertar2(User usuario) async {
    Database database = await _openDB();

    //var result = database.rawQuery(" SELECT max(id) FROM epa_user ", null);
    //Future<List<Map<String, Object?>>>
    /*List<Map<String,dynamic>> s = result as List<Map<String, dynamic>>;
    var int;
    for(var x in s){
      int = x;
    }
    int++;*/

    var resultado = await database.execute("INSERT INTO epa_user (nickname, password)"
        " VALUES ('${usuario.nickname}', '${usuario.password}')");
  }

  static Future<void> create_epa_user() async {
    Database database = await _openDB();
    var resultado = await database.execute("CREATE TABLE epa_user (id INTEGER PRIMARY KEY Autoincrement, nickname TEXT, password TEXT)");
  }

  static Future<void> truncate_epa_user() async {
    Database database = await _openDB();
    var resultado3 = await database.execute("drop table epa_user");
    var resultado = await database.execute("delete from epa_user");
    var resultado2 = await database.execute("update sqlite_sequence set seq=0 where name=`epa_user`;");
  }

  static Future<void> create_epa_medicion() async {
    Database database = await _openDB2();
    var resultado = await database.execute("CREATE TABLE epa_medicion (id INTEGER PRIMARY KEY Autoincrement, nombre TEXT, descripcion TEXT, latitud double, longitud double, altitud double)");
  }

  static Future<void> truncate_epa_medicion() async {
    Database database = await _openDB2();
    var resultado3 = await database.execute("drop table epa_medicion");
    var resultado2 = await database.execute("update sqlite_sequence set seq=0 where name=`epa_medicion`;");
  }

  static Future<void> insertar(User usuario) async {
    Database database = await _openDB2();

    var resultado = await database.execute("INSERT INTO epa_usuence set seq=0 where name=`epa_medicion`;");
  }

  static Future<void> insertar_medicion(Medicion medicion) async {
    Database database = await _openDB2();

    var resultado = await database.execute("INSERT INTO epa_medicion (nombre, descripcion, latitud, longitud, altitud)"
        " VALUES ('${medicion.nombre}', '${medicion.descripcion}', ${medicion.latitud}, ${medicion.longitud}, ${medicion.altitud})");
  }

  static Future<List<Medicion>> mediciones() async {

    Database database = await _openDB2();
    final List<Map<String, dynamic>> medicionesMap = await database.query("epa_medicion");

    return List.generate(medicionesMap.length,
            (i) => Medicion(
            id: medicionesMap[i]['id'],
            nombre: medicionesMap[i]['nombre'],
            descripcion: medicionesMap[i]['descripcion'],
            latitud: medicionesMap[i]['latitud'],
            longitud: medicionesMap[i]['longitud'],
            altitud: medicionesMap[i]['altitud']
        ));
  }

  static Future<Future<int>> delete_mediciones(Medicion medicion) async {

    Database database = await _openDB2();

    return database.delete("epa_medicion", where: "id = ?", whereArgs: [medicion.id]);
  }

  static Future<Future<int>> update_medicion(Medicion medicion) async {

    Database database = await _openDB2();
    return database.update("epa_medicion", medicion.toMap(),  where: "id = ?", whereArgs: [medicion.id]);
  }

  static Future<void> create_usuario_epa() async {
    Database database = await _openDB3();
    var resultado = await database.execute(
      "CREATE TABLE user_epacom ("
          "usuario_id INTEGER PRIMARY KEY Autoincrement,"
          "codigo TEXT,"
          "nombre TEXT,"
          "apellidos TEXT,"
          "email TEXT,"
          "pws TEXT,"
          "usuario TEXT"
          ")",
    );
  }

  static Future<void> truncate_usuario_epa() async {
    Database database = await _openDB3();
    var resultado3 = await database.execute("drop table user_epacom");
    var resultado2 = await database.execute("update sqlite_sequence set seq=0 where name=`user_epacom`;");
  }

  static Future<void> insertar_user_epa(UsuarioEpa usuario) async {
    Database database = await _openDB3();

    var resultado = await database.execute("INSERT INTO user_epacom (usuario_id, codigo, nombre, apellidos, email, pws, usuario)"
        " VALUES (${usuario.usuario_id}, '${usuario.codigo}', '${usuario.nombre}', '${usuario.apellidos}', '${usuario.email}', '${usuario.pws}', '${usuario.usuario}')");
  }

  static Future<List<UsuarioEpa>> usuarios_epa() async {

    Database database = await _openDB3();
    final List<Map<String, dynamic>> usuariosMap = await database.query("user_epacom");

    return List.generate(usuariosMap.length,
            (i) => UsuarioEpa(
            usuario_id: usuariosMap[i]['usuario_id'],
            codigo: usuariosMap[i]['codigo'],
            nombre: usuariosMap[i]['nombre'],
            apellidos: usuariosMap[i]['apellidos'],
            email: usuariosMap[i]['email'],
            pws: usuariosMap[i]['pws'],
            usuario: usuariosMap[i]['usuario']
        ));
  }

  Future<UsuarioEpa?> getUsuarioEpa(String user) async {
    var dbClient =await _openDB3();
    var res = await dbClient.rawQuery("SELECT * FROM user_epacom WHERE codigo = '$user'");

    print("Leng "+res.length.toString());
    if (res.length > 0) {
      return new UsuarioEpa.fromMap(res.first);
    }
    return null;
  }

  /*
  *
  * Para el Manejo de las Ordenes
  *
   */

  static Future<void> create_ordenes_epa() async {
    Database database = await _openDB4();
    var resultado = await database.execute(
      "CREATE TABLE epa_ordenes ("
          "orden_id INTEGER PRIMARY KEY Autoincrement,"
          "secuencial_orden TEXT,"
          "numero_cuentas integer,"
          "progreso double,"
          "cuentasHechas integer,"
          "sistema TEXT,"
          "fechaOrden TEXT"
          ")",
    );
  }

  static Future<void> truncate_ordenes_epa() async {
    print("Ingresando Tabla Orden");
    Database database = await _openDB4();
    var resultado3 = await database.execute("drop table epa_ordenes");
    //var resultado2 = await database.execute("update sqlite_sequence set seq=0 where name=`epa_ordenes`;");
    var resultado = await database.execute(
      "CREATE TABLE epa_ordenes ("
          "orden_id INTEGER PRIMARY KEY Autoincrement,"
          "secuencial_orden TEXT,"
          "numero_cuentas integer,"
          "progreso double,"
          "cuentasHechas integer,"
          "sistema TEXT,"
          "fechaOrden TEXT"
          ")",
    );
  }

  static Future<void> insertar_ordenes_epa(Orden orden) async {
    Database database = await _openDB4();

    var resultado = await database.execute("INSERT INTO epa_ordenes (secuencial_orden, numero_cuentas, progreso, cuentasHechas,  sistema, fechaOrden)"
        " VALUES ('${orden.secuencial_orden}', ${orden.numero_cuentas}, ${orden.progreso}, ${orden.cuentasHechas}, '${orden.sistema}', '${orden.fechaOrden}')");
  }

  static Future<List<Orden>> ordenes_epa() async {

    Database database = await _openDB4();
    final List<Map<String, dynamic>> ordenesMap = await database.query("epa_ordenes");

    return List.generate(ordenesMap.length,
            (i) => Orden(
            orden_id: ordenesMap[i]['orden_id'],
            secuencial_orden: ordenesMap[i]['secuencial_orden'],
            numero_cuentas: ordenesMap[i]['numero_cuentas'],
            progreso: ordenesMap[i]['progreso'],
            cuentasHechas: ordenesMap[i]['cuentasHechas'],
            sistema: ordenesMap[i]['sistema'],
            fechaOrden: ordenesMap[i]['fechaOrden'],
            isExpanded: false,
            cuentasOrdenes: []
        ));
  }


  /*
  *
  *  Para el Manejo de Cuentas
  *
  *
   */

  static Future<void> create_cuentas_epa() async {
    Database database = await _openDB5();
    var resultado = await database.execute(
      "CREATE TABLE epa_cuentas ("
          "cuenta_id INTEGER PRIMARY KEY Autoincrement,"
          "secuencial_orden TEXT,"
          "numero_cuenta TEXT,"
          "nombre_cliente TEXT,"
          "direccion TEXT,"
          "ramal TEXT,"
          "toma TEXT,"
          "tipo_cultivo TEXT,"
          "numero_hectareas TEXT,"
          "latitud TEXT,"
          "longitud TEXT,"
          "altitud TEXT,"
          "lecturaUT TEXT,"
          "lecturaUTBack TEXT,"
          "lectura_anterior TEXT,"
          "lectura_actual TEXT,"
          "observacion TEXT,"
          "fechaRegistro TEXT,"
          "imagen BLOB,"
          "completado INTEGER,"
          "sincronizado INTEGER,"
          "isExpanded INTEGER,"
          "tieneNovedad INTEGER,"
          "unidad_medida TEXT,"
          "sin_lectura INTEGER"
          ")",
    );
  }

  static Future<void> truncate_cuentas_epa() async {
    Database database = await _openDB5();
    var resultado3 = await database.execute("drop table epa_cuentas");
    //var resultado2 = await database.execute("update sqlite_sequence set seq=0 where name=`epa_cuentas`;");
    var resultado = await database.execute(
      "CREATE TABLE epa_cuentas ("
          "cuenta_id INTEGER PRIMARY KEY Autoincrement,"
          "secuencial_orden TEXT,"
          "numero_cuenta TEXT,"
          "nombre_cliente TEXT,"
          "direccion TEXT,"
          "ramal TEXT,"
          "toma TEXT,"
          "tipo_cultivo TEXT,"
          "numero_hectareas TEXT,"
          "latitud TEXT,"
          "longitud TEXT,"
          "altitud TEXT,"
          "lecturaUT TEXT,"
          "lecturaUTBack TEXT,"
          "lectura_anterior TEXT,"
          "lectura_actual TEXT,"
          "observacion TEXT,"
          "fechaRegistro TEXT,"
          "imagen BLOB,"
          "completado INTEGER,"
          "sincronizado INTEGER,"
          "isExpanded INTEGER,"
          "tieneNovedad INTEGER,"
          "unidad_medida TEXT,"
          "sin_lectura INTEGER"
          ")",
    );
  }

  static Future<void> insertar_cuentas_epa(Cuenta cuenta) async {
    Database database = await _openDB5();

    var resultado = await database.execute("INSERT INTO epa_cuentas (secuencial_orden, numero_cuenta, nombre_cliente, direccion, ramal, toma, tipo_cultivo, numero_hectareas, latitud, longitud, altitud, lecturaUT, lecturaUTBack, lectura_anterior, lectura_actual, observacion, fechaRegistro,  imagen, completado, sincronizado, isExpanded, tieneNovedad, unidad_medida, sin_lectura)"
        " VALUES ('${cuenta.secuencial_orden}', '${cuenta.numero_cuenta}', '${cuenta.nombre_cliente}', '${cuenta.direccion}', '${cuenta.ramal}', '${cuenta.toma}', '${cuenta.tipo_cultivo}', '${cuenta.numero_hectareas}', '${cuenta.latitud}', '${cuenta.longitud}', '${cuenta.altitud}', '${cuenta.lecturaUT}', '${cuenta.lecturaUTBack}', '${cuenta.lectura_anterior}', '${cuenta.lectura_actual}', '${cuenta.observacion}', '${cuenta.fechaRegistro}', '${cuenta.imagen}', ${cuenta.completado}, ${cuenta.sincronizado}, ${cuenta.isExpanded}, ${cuenta.tieneNovedad}, '${cuenta.unidad_medida}', ${cuenta.sin_lectura})");
  }

  static Future<void> update_cuentas_epa(Cuenta cuenta) async {
    Database database = await _openDB5();

    /* var resultado = await database.execute("UPDATE epa_cuentas  SET "
        "latitud = '${cuenta.latitud}' "
        "and longitud = '${cuenta.longitud}' "
        "and altitud = '${cuenta.altitud}' "
        "and lecturaUT = '${cuenta.lecturaUT}' "
        "and lecturaUTBack = '${cuenta.lecturaUTBack}' "
        "and lectura_actual = '${cuenta.lectura_actual}' "
        "and observacion = '${cuenta.observacion}' "
        "and fechaRegistro = '${cuenta.fechaRegistro}' "
        "and imagen = '${cuenta.imagen}' "
        "and completado = ${cuenta.completado} "
        "and sincronizado = ${cuenta.sincronizado} where secuencial_orden = '${cuenta.secuencial_orden}' and numero_cuenta= '${cuenta.numero_cuenta}'");*/
    await database.update(
      'epa_cuentas',
      cuenta.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'secuencial_orden = ? and numero_cuenta = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [cuenta.secuencial_orden, cuenta.numero_cuenta],
    );
    print("Resultado update");
    // print(resultado);
  }


  static Future<List<Cuenta>> cuentas_epa() async {

    Database database = await _openDB5();
    final List<Map<String, dynamic>> cuentasMap = await database.query("epa_cuentas");

    return List.generate(cuentasMap.length,
            (i) => Cuenta(
            cuenta_id: cuentasMap[i]['cuenta_id'],
            secuencial_orden: cuentasMap[i]['secuencial_orden'],
            numero_cuenta: cuentasMap[i]['numero_cuenta'],
            nombre_cliente: cuentasMap[i]['nombre_cliente'],
            direccion: cuentasMap[i]['direccion'],
            ramal: cuentasMap[i]['ramal'],
            toma: cuentasMap[i]['toma'],
            tipo_cultivo: cuentasMap[i]['tipo_cultivo'],
            numero_hectareas: cuentasMap[i]['numero_hectareas'],
            latitud: cuentasMap[i]['latitud'],
            longitud: cuentasMap[i]['longitud'],
            altitud: cuentasMap[i]['altitud'],
            lecturaUT: cuentasMap[i]['lecturaUT'],
            lecturaUTBack: cuentasMap[i]['lecturaUTBack'],
            lectura_anterior: cuentasMap[i]['lectura_anterior'],
            lectura_actual: cuentasMap[i]['lectura_actual'],
            observacion: cuentasMap[i]['observacion'],
            fechaRegistro: cuentasMap[i]['fechaRegistro'],
            cultivosCuenta: [],
            imagen: cuentasMap[i]['imagen'],
            completado: cuentasMap[i]['completado'],
            sincronizado: cuentasMap[i]['sincronizado'],
            isExpanded: 0,
            tieneNovedad: 0,
            unidad_medida: "m3",
            sin_lectura: 0
        ));
  }

  static Future<List<Cuenta>> cuentas_epa_por_orden(String secuencial) async {

    Database database = await _openDB5();
    final List<Map<String, dynamic>> cuentasMap = await database.rawQuery("Select * from epa_cuentas where secuencial_orden = '${secuencial}'");

    return List.generate(cuentasMap.length,
            (i) => Cuenta(
            cuenta_id: cuentasMap[i]['cuenta_id'],
            secuencial_orden: cuentasMap[i]['secuencial_orden'],
            numero_cuenta: cuentasMap[i]['numero_cuenta'],
            nombre_cliente: cuentasMap[i]['nombre_cliente'],
            direccion: cuentasMap[i]['direccion'],
            ramal: cuentasMap[i]['ramal'],
            toma: cuentasMap[i]['toma'],
            tipo_cultivo: cuentasMap[i]['tipo_cultivo'],
            numero_hectareas: cuentasMap[i]['numero_hectareas'],
            latitud: cuentasMap[i]['latitud'],
            longitud: cuentasMap[i]['longitud'],
            altitud: cuentasMap[i]['altitud'],
            lecturaUT: cuentasMap[i]['lecturaUT'],
            lecturaUTBack: cuentasMap[i]['lecturaUTBack'],
            lectura_anterior: cuentasMap[i]['lectura_anterior'],
            lectura_actual: cuentasMap[i]['lectura_actual'],
            observacion: cuentasMap[i]['observacion'],
            fechaRegistro: cuentasMap[i]['fechaRegistro'],
            cultivosCuenta: [],
            imagen: cuentasMap[i]['imagen'],
            completado: cuentasMap[i]['completado'],
            sincronizado: cuentasMap[i]['sincronizado'],
            isExpanded: 0,
            tieneNovedad: 0,
            unidad_medida: cuentasMap[i]['unidad_medida'],
            sin_lectura: cuentasMap[i]['sin_lectura'],
        ));
  }


  /*
  *
  * Para el Manejo de los Cultivos
  *
   */

  static Future<void> create_cultivos_epa() async {
    Database database = await _openDB6();
    var resultado = await database.execute(
      "CREATE TABLE epa_cultivos ("
          "cultivo_id INTEGER PRIMARY KEY Autoincrement,"
          "numero_cuenta TEXT,"
          "descripcion TEXT,"
          "numero_hectareas TEXT,"
          "tipo_riego TEXT"
          ")",
    );
  }

  static Future<void> truncate_cultivos_epa() async {
    print("Ingresando Tabla Cultivos");
    Database database = await _openDB6();
    var resultado3 = await database.execute("drop table epa_cultivos");
    //var resultado2 = await database.execute("update sqlite_sequence set seq=0 where name=`epa_ordenes`;");
    var resultado = await database.execute(
      "CREATE TABLE epa_cultivos ("
          "cultivo_id INTEGER PRIMARY KEY Autoincrement,"
          "numero_cuenta TEXT,"
          "descripcion TEXT,"
          "numero_hectareas TEXT,"
          "tipo_riego TEXT"
          ")",
    );
  }

  static Future<void> insertar_cultivos_epa(Cultivo cultivo) async {
    Database database = await _openDB6();

    var resultado = await database.execute("INSERT INTO epa_cultivos (numero_cuenta, descripcion, numero_hectareas, tipo_riego)"
        " VALUES ('${cultivo.numero_cuenta}', '${cultivo.descripcion}', '${cultivo.numero_hectareas}', '${cultivo.tipo_riego}')");
  }

  static Future<List<Cultivo>> cultivos_epa_por_cuenta(String numero_cuenta) async {

    Database database = await _openDB6();
    final List<Map<String, dynamic>> cultivosMap = await database.rawQuery("Select * from epa_cultivos where numero_cuenta = '${numero_cuenta}'");

    return List.generate(cultivosMap.length,
            (i) => Cultivo(
            cultivo_id: cultivosMap[i]['cultivo_id'],
            numero_cuenta: cultivosMap[i]['numero_cuenta'],
            descripcion: cultivosMap[i]['descripcion'],
            numero_hectareas: cultivosMap[i]['numero_hectareas'],
            tipo_riego: cultivosMap[i]['tipo_riego']
        ));
  }

}