import 'dart:io';

enum Genrer { MALE, FEMALE }

class User {
  int id;
  final String nickname;
  final String password;
  final Genrer genrer;
  final File photo;

  User({required this.id, required this.nickname, required this.password, required this.genrer, required this.photo});

  bool login(String nickname, String password) {
    return (this.nickname == nickname) && (this.password == password);
  }

  Map<String, dynamic> toMap(){
    return {'id':id, 'nickname':nickname, 'password':password, 'genrer':genrer, 'photo':photo};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}