import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gatherash/data/provider/auth_provider.dart';
import 'package:gatherash/models/payment_method.dart';
import 'package:gatherash/screen/detail_change.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ChangePoinPage extends StatefulWidget {
  static const routeName = "/change_poin";
  const ChangePoinPage({Key? key}) : super(key: key);

  @override
  State<ChangePoinPage> createState() => _ChangePoinPageState();
}

Future<List> getAllPayment() async {
  final response = await http.get(Uri.parse(
      "https://rest-api-waste-bank-production.up.railway.app/api/v1/payment-method"));
  var data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    List<dynamic> payments =
        data.map((e) => PaymentMethod.fromJson(e)).toList();
    print(payments);
    return payments;
  } else {
    List<dynamic> payments =
        data.map((e) => PaymentMethod.fromJson(e)).toList();
    print(payments);
    return payments;
  }
}

class _ChangePoinPageState extends State<ChangePoinPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (_, provider, child) {
      return SafeArea(
        child: FutureBuilder(
            future: getAllPayment(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var state = snapshot.connectionState;
              switch (state) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  snapshot.data.length;
                  return Column(
                    children: [
                      Text("Change Poin", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            //listtile adalah widget yang disediakan flutter berisi 3 properti yang kita pakai
                            //properti: leading, title, dan subtitle. di dalam setiap properti kalian bebas melakukan customisasi
                            child: GestureDetector(
                              onTap: (){
                                PaymentMethod paymentMethod = new PaymentMethod(id: 0, paymentMethod: "");
                                paymentMethod.id = snapshot.data[index].id;
                                paymentMethod.paymentMethod = snapshot.data[index].paymentMethod;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailChangePoin(paymentMethod: paymentMethod),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(
                                  //menampilkan data judul
                                  "Saldo Tukar: ${snapshot.data[index].paymentMethod}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: Icon(Icons.credit_card),
                              ),
                            ),
                          );
                        })],
                  );
                default:
                  return Text("GAgagl");
                  // print(snapshot.data.length);

                  return Text("data");
              }
            }),
      );
    });
  }
}
