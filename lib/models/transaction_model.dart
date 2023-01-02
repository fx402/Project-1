import 'package:project_alfin/models/item_categories.dart';
import 'package:project_alfin/models/user_model.dart';

class TransactionModel {
  int? id;
  UserModel? user;
  List<ItemCategories>? itemCategories;
  int? price;
  int? total;
  // DateTime? createdAt;
  // DateTime? updatedAt;

  TransactionModel(
      {required this.id,
        required this.user,
        required this.itemCategories,
        required this.price,
        // required this.createdAt,
        // required this.updatedAt,
        required this.total});

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
    price : json['price'],
    total : json['total'],
    // createdAt : json['createdAt'],
    // updatedAt : json['updatedAt'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    if (this.itemCategories != null) {
      data['itemCategories'] =
          this.itemCategories?.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    data['total'] = this.total;
    // data['createdAt'] = this.createdAt;
    // data['createdAt'] = this.createdAt;
    return data;
  }
}