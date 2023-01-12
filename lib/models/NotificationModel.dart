import 'package:gatherash/models/user_model.dart';

class NotificationModel {
  int id;
  String title;
  String description;
  UserModel user;

  NotificationModel({required this.id, required this.title, required this.description, required this.user});

  factory NotificationModel.fromJson(Map<String, dynamic> json)=> NotificationModel(
    id : json['id'],
    title : json['title'],
    description : json['description'],
      user : json['user'] != null ?
      UserModel.fromJson(json['user']) :
      UserModel(id: 0, name: "", email: "", password: "",poin: 0)
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}