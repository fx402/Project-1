
import 'dart:convert';

UserModel userModelJson(String str) =>
    UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());
class UserModel {
  int id;
  String name;
  String email;
  String password;
  int poin;

  UserModel({required this.id, required this.name, required this.email, required this.password, required this.poin});
  // UserModel({});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id : json['id'],
    name : json['name'],
    email : json['email'],
    password : json['password'],
    poin : json['poin']
  );


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'poin': poin,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map)=> UserModel(
    id : map['id'],
    name : map['name'],
    email : map['email'],
    password : map['password'],
      poin : map['poin']
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['poin'] = this.poin;
    return data;
  }
}