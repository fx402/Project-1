import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_alfin/data/provider/auth_provider.dart';
import 'package:project_alfin/models/auth_model.dart';
import 'package:project_alfin/models/item_categories.dart';
import 'package:http/http.dart' as http;
import 'package:project_alfin/models/user_model.dart';
import 'package:project_alfin/models/user_pref.dart';
import 'package:project_alfin/screen/home.dart';
import 'package:provider/provider.dart';

import '../models/item_categories_model.dart';
import '../models/transaction_model.dart';

class TransaksiPage extends StatefulWidget {
  static var routeName = "/transaksi";

  const TransaksiPage({Key? key}) : super(key: key);

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}
Future<UserModel> getUser(int? id) async{
  var data = await http.get(Uri.parse("https://rest-api-waste-bank-production.up.railway.app/api/v1/user/$id"));
  var jsonData = json.decode(data.body);
  if(data.statusCode == 200){
    return UserModel.fromJson(jsonData);
  }else {
    print('${data.statusCode}');
    throw Exception('Failed get Data');
  }
}
Future<List<ItemCategories>> getData() async {
  var data =
      await http.get(Uri.parse('https://rest-api-waste-bank-production.up.railway.app/api/v1/item-category'));

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

Future<TransactionModel> createData(
    TransactionModel transactionModel) async {
  final data = await http.post(
      Uri.parse('https://rest-api-waste-bank-production.up.railway.app/api/v1/transaction/create'),
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
  String valueHp = "";
  String valueRadio = "";
  String valueTV = "";
  String valueKulkas = "";
  List<ItemCategories> itemCategories = [];

  TextEditingController _textNoTelepon = new TextEditingController();
  UserModel userModel = new UserModel(id: 0, name: "", email: "", password: "", poin: 0);
  late TransactionModel transactionModel = new TransactionModel(
      id: 0,
      user: userModel,
      itemCategories: itemCategories,
      price: 0,
      total: 0);
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
    final getUser = Provider.of<AuthProvider>(context, listen: false);
    getUser.getUser();
  }

  int total = 0;
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
        // print(total);

        return FutureBuilder(future: getData(),builder: (BuildContext context, AsyncSnapshot snapshot){
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                    child:  Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        enabled: false,
                        // validator: (String value){},
                        decoration: InputDecoration(
                            labelText: '${provider.user?.userName}',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            )
                        ),
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
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isCheckedHp,
                          onChanged: (bool? value) {
                            if(value == false){
                              setState(() {
                                isCheckedHp = value!;
                                var json = snapshot.data[0];
                                itemCategories.remove(json);
                                total -= json.prices as int;
                              });
                            }else{
                              setState(() {
                                isCheckedHp = value!;
                                var json = snapshot.data[0];
                                itemCategories.add(json);
                                total += json.prices as int;
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
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isCheckedRadio,
                          onChanged: (bool? value) {
                            if(value == false){
                              setState(() {
                                isCheckedRadio = value!;
                                var json = snapshot.data[1];
                                itemCategories.remove(json);
                                total -= json.prices as int;
                              });
                            }else {
                              setState(() {
                                isCheckedRadio = value!;
                                var json = snapshot.data[1];
                                itemCategories.add(json);
                                total += json.prices as int;
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
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isCheckedTV,
                          onChanged: (bool? value) {
                            if(value == false){
                              setState(() {
                                isCheckedTV = value!;
                                var json = snapshot.data[2];
                                itemCategories.remove(json);
                                total -= json.prices as int;
                              });
                            }else {
                              setState(() {
                                isCheckedTV = value!;
                                var json = snapshot.data[2];
                                itemCategories.add(json);
                                total += json.prices as int;
                              });
                            }
                          },
                        ),
                        Text('TV'),
                        SizedBox(
                          width: 10,
                        ),
                        // isCheckedTV
                        //     ? Text('$valueTV kg',
                        //     style: TextStyle(fontWeight: FontWeight.bold))
                        //     : Text(''),
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
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isCheckedKulkas,
                          onChanged: (bool? value) {
                            if(value == false){
                              setState(() {
                                isCheckedKulkas = value!;
                                var json = snapshot.data[3];
                                itemCategories.remove(json);
                                total -= json.prices as int;
                              });
                            }else {
                              setState(() {
                                isCheckedKulkas = value!;
                                var json = snapshot.data[3];
                                itemCategories.add(json);
                                total += json.prices as int;
                              });
                            }
                          },
                        ),
                        Text('Kulkas'),
                        SizedBox(
                          width: 10,
                        ),
                        // isCheckedKulkas
                        //     ? Text('$valueKulkas Kg',
                        //     style: TextStyle(fontWeight: FontWeight.bold))
                        //     : Text(""),
                      ],
                    ),
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
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen,
                          minimumSize: Size(size.width / 1.2, 40)),
                      onPressed: () async {

                        //dapet poin dari idnya
                        userModel = await getUser(provider.user?.id);
                        //jumlah
                        //masukkan
                        print("itemCategories adalah : ${itemCategories.length}");
                        transactionModel.itemCategories = itemCategories;
                        transactionModel.total = itemCategories.length;
                        int prices = 0;
                        for(int i = 0; i < itemCategories.length; i++){
                          prices += itemCategories[i].prices;
                        }
                        transactionModel.price = prices;
                        //dapet poin dari model
                        var poin = await (total + userModel.poin);
                        userModel.poin = poin;
                        transactionModel.user = userModel;
                        createData(transactionModel);
                        final result = await context.read<AuthProvider>().setUser(
                          AuthModel(
                              userName: userModel.name,
                              email: userModel.email,
                              password: userModel.password,
                              poin: poin,
                              id: userModel.id
                          ),
                        );
                        if(result){
                          if (mounted) {
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                                  (route) => true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Berhasil Deliver"),
                              ),
                            );
                          }
                        }else{
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
        },);
      }),
    );
  }


}
