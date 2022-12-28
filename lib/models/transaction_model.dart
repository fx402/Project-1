import 'package:project_alfin/models/item_categories.dart';
import 'package:project_alfin/models/user_model.dart';

class TransactionModel {
  int id;
  UserModel user;
  List<ItemCategories> itemCategories;
  BigInt price;
  int total;

  TransactionModel({required this.id, required this.user, required this.itemCategories, required this.price, required this.total});

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    id : json['id'],
    user : json['user'] != null ?
      UserModel.fromJson(json['user']) :
      UserModel(id: 0, name: "", email: "", password: ""),
    itemCategories: List<ItemCategories>.from((json['itemCategories'] as List).map((element) =>
        ItemCategories.fromJson(element)).where((element) => element.id != null
        && element.nameItem != null
        && element.prices != null
        && element.img != null)
    ),
    price : json['price'],
    total : json['total'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.itemCategories != null) {
      data['itemCategories'] =
          this.itemCategories.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    data['total'] = this.total;
    return data;
  }
}