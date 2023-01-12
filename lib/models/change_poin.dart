import 'package:gatherash/models/payment_method.dart';
import 'package:gatherash/models/user_model.dart';

class ChangePoin {
  int id;
  UserModel user;
  int numberPhone;
  PaymentMethod paymentMethod;

  ChangePoin(
      {required this.id, required this.user, required this.paymentMethod,
      required this.numberPhone});

  factory ChangePoin.fromJson(Map<String, dynamic> json)=>  ChangePoin(
    id : json['id'],
    user : json['user'] != null ?
    UserModel.fromJson(json['user']) :
    UserModel(id: 0, name: "", email: "", password: "",poin: 0),
    paymentMethod : json['paymentMethod'] != null ?
    PaymentMethod.fromJson(json['paymentMethod']) :
    PaymentMethod(id: 0, paymentMethod: ""),
    numberPhone: json['noTelephone']
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['noTelephone'] = this.numberPhone;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.paymentMethod != null) {
      data['paymentMethod'] = this.paymentMethod.toJson();
    }
    return data;
  }
}