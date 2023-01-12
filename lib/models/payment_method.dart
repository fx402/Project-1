import 'package:gatherash/models/user_model.dart';

class PaymentMethod {
  int id;
  String paymentMethod;

  PaymentMethod({required this.id, required this.paymentMethod});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id : json['id'],
    paymentMethod: json['paymentMethod']
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['paymentMethod'] = this.paymentMethod;
    return data;
  }
}