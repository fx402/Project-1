import 'package:project_alfin/models/item_categories.dart';
import 'package:project_alfin/models/user_model.dart';

class TransactionModel {
  int id;
  UserModel user;
  List<ItemCategories> itemCategories;
  int price;
  int total;

  TransactionModel({required this.id, required this.user, required this.itemCategories, required this.price, required this.total});

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    id : json['id'],
    user : json['user'] != null ?
      UserModel.fromJson(json['user']) :
      UserModel(id: 0, name: "", email: "", password: "",poin: 0),
    itemCategories: List<ItemCategories>.from((json['itemCategories'] as List).map((element) =>
        ItemCategories.fromJson(element)).where((element) => element.id != null
        && element.nameItem != null
        && element.prices != null
        && element.img != null)
    ),
    price : json['prices'],
    total : json['total'],
  );

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'user' : this.user.toJson(),
    'itemCategories' : this.itemCategories.map((v) => v.toJson()).toList(),
    'prices' :this.price,
    'total': this.total
  };
}