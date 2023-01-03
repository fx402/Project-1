import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gatherash/data/provider/auth_provider.dart';
import 'package:gatherash/models/auth_model.dart';
import 'package:gatherash/models/item_categories.dart';
import 'package:http/http.dart' as http;
import 'package:gatherash/models/user_model.dart';
import 'package:gatherash/screen/home.dart';
import 'package:gatherash/utils/SendType.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';

class TransaksiPage extends StatefulWidget {
  static var routeName = "/transaksi";

  const TransaksiPage({Key? key}) : super(key: key);

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
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

Future<UserModel> updateUser(UserModel userModel, int? id) async {
  var response = await http.put(Uri.parse('https://rest-api-waste-bank-production.up.railway.app/api/v1/user/update/$id'),
      headers:<String, String>{"Content-Type": "application/json"},
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
  }else {
    throw Exception('Failed created User');
  }
}
Future<List<ItemCategories>> getData() async {
  var data = await http.get(Uri.parse(
      'https://rest-api-waste-bank-production.up.railway.app/api/v1/item-category'));

  var jsonData = json.decode(data.body);
  List<ItemCategories> itemCategoriess = [];
  for (var i in jsonData) {
    ItemCategories itemCategories = new ItemCategories(
        id: i["id"],
        nameItem: i["nameItem"],
        prices: i["prices"],
        img: i["img"]);
    itemCategoriess.add(itemCategories);
  }
  if (data.statusCode == 200) {
    return itemCategoriess;
  } else {
    print('${data.statusCode}');
    throw Exception('Failed created User');
  }
}

Future<TransactionModel> createData(TransactionModel transactionModel) async {
  final data = await http.post(
      Uri.parse(
          'https://rest-api-waste-bank-production.up.railway.app/api/v1/transaction/create'),
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(transactionModel.toJson()));

  if (data.statusCode == 201) {
    var jsonData = json.decode(data.body);
    return TransactionModel.fromJson(jsonData);
  } else {
    print('${data.statusCode}');
    throw Exception('Failed created User');
  }
}

class _TransaksiPageState extends State<TransaksiPage> {
  bool isCheckedHp = false;
  bool isCheckedRadio = false;
  bool isCheckedTV = false;
  bool isCheckedKulkas = false;
  Color? colors = Colors.lightGreen[200];
  String valueHp = "";
  String valueRadio = "";
  String valueTV = "";
  String valueKulkas = "";
  List<ItemCategories> itemCategories = [];

  UserModel userModel =
      new UserModel(id: 0, name: "", email: "", password: "", poin: 0);
  late TransactionModel transactionModel = new TransactionModel(
      id: 0,
      user: userModel,
      itemCategories: itemCategories,
      price: 0,
      total: 0,
      typeSend: SendType.DIANTAR.toString());
  SendType? _typeSend = SendType.DIANTAR;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  initState() {
    initial();
    super.initState();
  }

  void initial() async {
    final user = Provider.of<AuthProvider>(context, listen: false);
    user.getUser();
    userModel = await getUser(user.user?.id);
  }

  int total = 0;
  int prices = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Transaksi"),
        backgroundColor: Colors.green.shade300,
      ),
      body: Consumer<AuthProvider>(builder: (_, provider, child) {

        return FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var state = snapshot.connectionState;
            switch(state){
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Container(child: Center(child: CircularProgressIndicator(),),);
              case ConnectionState.done:
                return  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: '${provider.user?.userName}',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isCheckedHp,
                            onChanged: (bool? value) {
                              if (value == false) {
                                setState(() {
                                  isCheckedHp = value!;
                                  var json = snapshot.data[0];
                                  itemCategories.remove(json);
                                  total -= json.prices as int;
                                  if(isCheckedHp == false && isCheckedTV == false && isCheckedRadio == false && isCheckedKulkas == false){
                                    colors = Colors.lightGreen[200];
                                  }
                                });
                              } else {
                                setState(() {
                                  isCheckedHp = value!;
                                  var json = snapshot.data[0];
                                  itemCategories.add(json);
                                  total += json.prices as int;
                                  colors = Colors.lightGreen;
                                });
                              }
                            },
                          ),
                          Text('Hp'),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isCheckedRadio,
                            onChanged: (bool? value) {
                              if (value == false) {
                                setState(() {
                                  isCheckedRadio = value!;
                                  var json = snapshot.data[1];
                                  itemCategories.remove(json);
                                  total -= json.prices as int;
                                  if(isCheckedHp == false && isCheckedTV == false && isCheckedRadio == false && isCheckedKulkas == false){
                                    colors = Colors.lightGreen[200];
                                  }
                                });
                              } else {
                                setState(() {
                                  isCheckedRadio = value!;
                                  var json = snapshot.data[1];
                                  itemCategories.add(json);
                                  total += json.prices as int;
                                  colors = Colors.lightGreen;
                                });
                              }
                            },
                          ),
                          Text('Radio'),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isCheckedTV,
                            onChanged: (bool? value) {
                              if (value == false) {
                                setState(() {
                                  isCheckedTV = value!;
                                  var json = snapshot.data[2];
                                  itemCategories.remove(json);
                                  total -= json.prices as int;
                                  if(isCheckedHp == false && isCheckedTV == false && isCheckedRadio == false && isCheckedKulkas == false){
                                    colors = Colors.lightGreen[200];
                                  }
                                });
                              } else {
                                setState(() {
                                  isCheckedTV = value!;
                                  var json = snapshot.data[2];
                                  itemCategories.add(json);
                                  total += json.prices as int;
                                  colors = Colors.lightGreen;
                                });
                              }
                            },
                          ),
                          Text('TV'),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isCheckedKulkas,
                            onChanged: (bool? value) {
                              if (value == false) {
                                setState(() {
                                  isCheckedKulkas = value!;
                                  var json = snapshot.data[3];
                                  itemCategories.remove(json);
                                  total -= json.prices as int;
                                  if(isCheckedHp == false && isCheckedTV == false && isCheckedRadio == false && isCheckedKulkas == false){
                                    colors = Colors.lightGreen[200];
                                  }
                                });
                              } else {
                                setState(() {
                                  isCheckedKulkas = value!;
                                  var json = snapshot.data[3];
                                  itemCategories.add(json);
                                  total += json.prices as int;
                                  colors = Colors.lightGreen;
                                });
                              }
                            },
                          ),
                          Text('Kulkas'),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(padding: EdgeInsets.)
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListTile(
                              title: const Text('Diantar'),
                              leading: Radio(
                                  value: SendType.DIANTAR,
                                  groupValue: _typeSend,
                                  autofocus: true,
                                  onChanged: (value) {
                                    setState(() {
                                      if(_typeSend == SendType.JEMPUT){
                                        total = total + 5000;
                                      }
                                      _typeSend = value as SendType;
                                    });
                                  })
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ListTile(
                              title: const Text('Jemput'),
                              leading: Radio(
                                  value: SendType.JEMPUT,
                                  groupValue: _typeSend,
                                  onChanged: (value) {
                                    setState(() {
                                      _typeSend = value as SendType;
                                      if(_typeSend == SendType.JEMPUT){
                                        total = total - 5000;
                                      }
                                      print("totalnya : $total");
                                    });
                                  })
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total ${total == null ? 0 : total} poin',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat',
                            fontSize: 20),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: colors,
                            minimumSize: Size(size.width / 1.2, 40)),
                        onPressed: isCheckedHp == false && isCheckedTV == false && isCheckedRadio == false && isCheckedKulkas == false ? (){
                          setState(() {
                          });
                        }: () async {
                          //dapet poin dari idnya
                          //jumlah
                          //masukkan
                          print(
                              "itemCategories adalah : ${itemCategories.length}");
                          transactionModel.itemCategories = itemCategories;
                          transactionModel.total = itemCategories.length;

                          for (int i = 0; i < itemCategories.length; i++) {
                            prices += itemCategories[i].prices;
                          }
                          var poin = await (total + userModel.poin);
                          var typeSend;
                          if(_typeSend == SendType.JEMPUT){
                            prices = await (prices - 5000);
                            typeSend = "Jemput";
                          }else {
                            typeSend = "Diantar";
                          }
                          transactionModel.price = prices;
                          print("Harganya adalah: $prices");
                          transactionModel.typeSend = typeSend;
                          //dapet poin dari model
                          userModel.poin = poin;
                          transactionModel.user = userModel;
                          updateUser(userModel, userModel.id);
                          createData(transactionModel);
                          final result =
                              await context.read<AuthProvider>().setUser(
                                    AuthModel(
                                        userName: userModel.name,
                                        email: userModel.email,
                                        password: userModel.password,
                                        poin: poin,
                                        id: userModel.id),
                                  );
                          if (result) {
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
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Gagal Deliver"),
                              ),
                            );
                          }
                        },
                        child: Text('Checkout'),
                      ),
                    ),
                  ),
                ],
              );
              default:
                return Text("Data Empty");
            }
          },
        );
      }),
    );
  }
}
