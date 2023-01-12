import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gatherash/data/provider/auth_provider.dart';
import 'package:gatherash/models/NotificationModel.dart';
import 'package:gatherash/models/auth_model.dart';
import 'package:gatherash/models/change_poin.dart';
import 'package:gatherash/models/payment_method.dart';
import 'package:gatherash/models/user_model.dart';
import 'package:gatherash/screen/home.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class DetailChangePoin extends StatefulWidget {
  final PaymentMethod paymentMethod;
  const DetailChangePoin({Key? key, required this.paymentMethod})
      : super(key: key);

  @override
  State<DetailChangePoin> createState() => _DetailChangePoinState();
}

Future<UserModel> getUser(int? id) async {
  var data = await http.get(Uri.parse(
      "https://rest-api-waste-bank-production.up.railway.app/api/v1/user/$id"));
  var jsonData = json.decode(data.body);
  if (data.statusCode == 200) {
    return UserModel.fromJson(jsonData);
  } else {
    print('${data.statusCode}');
    throw Exception('Failed get Data');
  }
}

Future<NotificationModel> createNotifications(
    NotificationModel notification) async {
  final data = await http.post(
      Uri.parse(
          'https://rest-api-waste-bank-production.up.railway.app/api/v1/notification/create'),
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(notification.toJson()));

  if (data.statusCode == 201) {
    var jsonData = json.decode(data.body);
    return NotificationModel.fromJson(jsonData);
  } else {
    print('${data.statusCode}');
    throw Exception('Failed created Notification');
  }
}

Future<ChangePoin> changePoin(ChangePoin changePoin)async {
  var response = await http.post(Uri.parse('https://rest-api-waste-bank-production.up.railway.app/api/v1/invoice-poin/create'),
      headers:<String, String>{"Content-Type": "application/json"},
      body: jsonEncode(changePoin.toJson()));

  String responseString = response.body;
  if (response.statusCode == 200) {
    return ChangePoin.fromJson(jsonDecode(responseString));
  }else {
    throw Exception('Failed created Change Poin');
  }
}


Future<UserModel> updateUser(UserModel userModel, int? id) async {
  var response = await http.put(
      Uri.parse(
          'https://rest-api-waste-bank-production.up.railway.app/api/v1/user/update/$id'),
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, dynamic>{
        "id": userModel.id,
        "name": userModel.name,
        "email": userModel.email,
        "password": userModel.password,
        "poin": userModel.poin,
      }));

  String responseString = response.body;
  if (response.statusCode == 200) {
    return UserModel.fromJson(jsonDecode(responseString));
  } else {
    throw Exception('Failed created User');
  }
}

class _DetailChangePoinState extends State<DetailChangePoin> {
  final formKey = GlobalKey<FormState>();

  UserModel userModel =
  new UserModel(id: 0, name: "", email: "", password: "", poin: 0);

  @override
  initState() {
    initial();
    super.initState();
  }

  NotificationModel notificationModel = new NotificationModel(
      id: 0,
      title: "",
      description: "",
      user: new UserModel(id: 0, name: "", email: "", password: "", poin: 0));

  void initial() async {
    final user = Provider.of<AuthProvider>(context, listen: false);
    user.getUser();
    userModel = await getUser(user.user?.id);
  }
  TextEditingController _numberPhone = TextEditingController();
  TextEditingController _totalPoin = TextEditingController();
  ChangePoin _changePoin = ChangePoin(id: 0, user: UserModel(id: 0, poin: 0,email: "",name: "",password: ""),
      paymentMethod: PaymentMethod(id: 0, paymentMethod: ""), numberPhone: 0);
  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.subtitle2;
    var size = MediaQuery.of(context).size;
    // var i = ;
    return Consumer<AuthProvider>(builder: (_,provider, children){
      return Scaffold(
        appBar: AppBar(
          title: Text("Change Poin"),
          backgroundColor: Colors.green.shade300,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          style: textStyle,
                          controller: _numberPhone,
                          // validator: (String value){},
                          decoration: InputDecoration(
                              labelText: 'Number Phone',
                              hintText: 'Enter your number phone',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          style: textStyle,
                          controller: _totalPoin,
                          // validator: (String value){},
                          decoration: InputDecoration(
                              labelText: 'Poin',
                              hintText: 'Enter your poin to change',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightGreen,
                                minimumSize: Size(size.width / 1.3, 50)),
                            onPressed: () async {
                              _changePoin.numberPhone = int.parse(_numberPhone.text);
                              _changePoin.paymentMethod = widget.paymentMethod;
                              _changePoin.user = userModel;

                              var poin = userModel.poin;
                              var totalPoin = _totalPoin.text;
                              var result = poin - int.parse(totalPoin);
                              final resultBool =
                              await context.read<AuthProvider>().setUser(
                                AuthModel(
                                    userName: userModel.name,
                                    email: userModel.email,
                                    password: userModel.password,
                                    poin: result,
                                    id: userModel.id),
                              );
                              userModel.poin = result;
                              if(resultBool){
                                notificationModel.user = userModel;
                                notificationModel.title = "Tukar Poin";
                                notificationModel.description = "Berhasil Menukar poin sebesar $result | ${_numberPhone.text}";
                                createNotifications(notificationModel);
                                changePoin(_changePoin);
                                updateUser(userModel, userModel.id);
                                if (mounted) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomePage(),
                                      ),
                                          (route) => true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Berhasil Deliver"),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text('Submit'),
                          )),
                    ],
                  ),
                )),
          ),
        ),
      );
    });
  }
}
