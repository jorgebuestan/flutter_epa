library flutter_modulo1_fake_backend;

import 'package:epa_movil/src/backend/data_init.dart';
import 'package:epa_movil/src/backend/usuario_epa.dart';
import 'package:epa_movil/src/connection/db.dart';
import 'package:epa_movil/src/models/models.dart';
import 'package:epa_movil/src/backend/recipe.dart';
import 'package:epa_movil/src/backend/user.dart';

//Lectura de datos
Future<List<User>> getUsers() async {
  await Future.delayed(Duration(seconds: 3));
  return users;
}

Future<List<Recipe>> getRecipes() async {
  await Future.delayed(Duration(seconds: 3));
  return recipes;
}

Future<List<Recipe>> getFavorites() async {
  await Future.delayed(Duration(seconds: 3));
  return favorites;
}

Future<bool> isFavorite(Recipe recipeToCheck) async {
  await Future.delayed(Duration(milliseconds: 500));
  for (Recipe recipe in favorites) {
    if (recipe == recipeToCheck) {
      return true;
    }
  }
  return false;
}

Future<List<Recipe>> getUserRecipes(User user) async {
  await Future.delayed(Duration(seconds: 3));
  return recipes.where((recipe) {
    return recipe.user.id == user.id;
  }).toList();
}

//Creación de datos
Future<Recipe> addRecipe(Recipe nRecipe) async {
  nRecipe.id = recipes.length + 1;
  recipes.add(nRecipe);
  return nRecipe;
}

Future<Recipe> addFavorite(Recipe nFavorite) async {
  favorites.add(nFavorite);
  return nFavorite;
}

Future<bool> addUser(User nUser) async {
  nUser.id = users.length + 1;
  users.add(nUser);
  return true;
}

Future<bool> updateUser(User user) async {
  int pos = users.indexOf(user);
  if (pos >= 0) {
    users[pos] = user;
  }
  return true;
}

Future<bool> updateRecipe(Recipe receta) async {
  int pos = recipes.indexOf(receta);
  if (pos >= 0) {
    recipes[pos] = receta;
  }
  return true;
}

Future<bool> deleteFavorite(Recipe favoriteRecipe) async {
  favorites.remove(favoriteRecipe);
  return true;
}

Future<User?> backendLogin(String nickname, String password) async {
  await Future.delayed(Duration(seconds: 3));
  for (User usuario in users) {
    if (usuario.login(nickname, password)) {
      return usuario;
    }
  }
  return null;
}

Future<UsuarioEpa?> backendLoginEpa(String nickname) async {
  await Future.delayed(Duration(seconds: 3));

  DB con = new DB();
  print (nickname);
  UsuarioEpa? usuario = await con.getUsuarioEpa(nickname);
  print ("prueba "+usuario.toString());

  if(usuario!=null){

     return usuario;

  }else{

    return null;

  }


  return null;

  //return result;

  /*for (UsuarioEpa usuario in users_epa) {
    if (usuario.login_epa(nickname, password)) {
      return usuario;
    }
  }*/
  return null;
}