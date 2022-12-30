import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_alfin/data/database/db_provider.dart';
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

// Future<ItemCategories> getData(int id) async {
//   var response = await http.get(Uri.parse('http://10.0.2.2:8000/api/v1/item-category/$id'));
//
//
//   if(response.statusCode == 200){
//     return ItemCategories.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed created User');
//   }
// }

Future<List<ItemCategories>> getData() async {
  var data =
      await http.get(Uri.parse('http://10.0.2.2:8000/api/v1/item-category'));

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
  String responseString = data.body;
  if (data.statusCode == 200) {
    return itemCategoriess;
  } else {
    print('${data.statusCode}');
    throw Exception('Failed created User');
  }
}

Future<List<TransactionModel>> createData(
    // int id, String username, String email, String password,
    // int price, int total,
    // List<ItemCategoriesModel> itemCategoriesModel,
    TransactionModel transactionModel) async {
  // for (var data in itemCategoriesModel){
  //   data.nameItem;
  // }
  var data = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/v1/transaction/create'),
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(transactionModel.toJson()));

  // String responseString = data.body;
  if (data.statusCode == 201) {
    var jsonData = json.decode(data.body);
    List<TransactionModel> transactionModels = [];

    for (var i in jsonData) {
      ItemCategories item = ItemCategories(
        id: i['itemCategories']['id'],
        nameItem: i['itemCategories']['nameItem'],
        prices: i['itemCategories']['prices'],
        img: i['itemCategories']['img'],
      );
      transactionModels.add(
        TransactionModel(
          id: jsonData['id'],
          user: jsonData['user'],
          // user: jsonObjectUser,
          itemCategories: item as List<ItemCategories>,
          price: jsonData['price'],
          total: jsonData['total'],
        ),
      );
    }
    return transactionModels;
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
  late TransactionModel transactionModel = new TransactionModel(id: 0, user: userModel, itemCategories: itemCategories, price: 0, total: 0);
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

  _showSimpleModalDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              constraints: BoxConstraints(maxHeight: 350),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                          text: "Berat Sampah",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black,
                              wordSpacing: 1)),
                    ),
                    Form(
                        child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(labelText: 'Weight'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('Submit'),
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
        });
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
      body: Consumer<DbProvider>(builder: (_, provider, child) {
        // print(total);

        return FutureBuilder(future: getData(),builder: (BuildContext context, AsyncSnapshot snapshot){
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child:  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        enabled: false,
                        // validator: (String value){},
                        decoration: InputDecoration(
                            labelText: '${provider.users.last.name}',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            )
                        ),
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
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isCheckedHp,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedHp = value!;
                              var json = snapshot.data[0];
                              itemCategories.add(json);
                              total += json.prices as int;

                              // print('${json.id}');
                              // _showSimpleModalDialog(context);
                            });
                          },
                        ),
                        Text('Hp'),
                        SizedBox(
                          width: 10,
                        ),
                        isCheckedHp
                            ? Text(
                          '$valueHp Kg',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                            : Text('')
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
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isCheckedRadio,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedRadio = value!;
                              var json = snapshot.data[1];
                              itemCategories.add(json);
                              total += json.prices as int;

                            });
                          },
                        ),
                        Text('Radio'),
                        SizedBox(
                          width: 10,
                        ),
                        isCheckedRadio
                            ? Text('$valueRadio Kg',
                            style: TextStyle(fontWeight: FontWeight.bold))
                            : Text("")
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
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isCheckedTV,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedTV = value!;
                              var json = snapshot.data[2];
                              itemCategories.add(json);

                              total += json.prices as int;
                            });
                          },
                        ),
                        Text('TV'),
                        SizedBox(
                          width: 10,
                        ),
                        isCheckedTV
                            ? Text('$valueTV kg',
                            style: TextStyle(fontWeight: FontWeight.bold))
                            : Text(''),
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
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isCheckedKulkas,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckedKulkas = value!;
                              var json = snapshot.data[3];
                              itemCategories.add(json);

                                total = total + json.prices as int;
                            });
                          },
                        ),
                        Text('Kulkas'),
                        SizedBox(
                          width: 10,
                        ),
                        isCheckedKulkas
                            ? Text('$valueKulkas Kg',
                            style: TextStyle(fontWeight: FontWeight.bold))
                            : Text(""),
                      ],
                    ),
                  ),
                ),
                Expanded(
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
                      onPressed: () {

                        print("itemCategories adalah : ${itemCategories.length}");
                        userModel.name = provider.users.last.name;
                        userModel.id = provider.users.last.id;
                        userModel.password = provider.users.last.password;
                        userModel.email = provider.users.last.email;
                        transactionModel.itemCategories = itemCategories;
                        transactionModel.total = itemCategories.length;
                        int prices = 0;
                        for(int i = 0; i < itemCategories.length; i++){
                          prices += itemCategories[i].prices;
                        }
                        transactionModel.price = prices;
                        userModel.poin = total;
                        transactionModel.user = userModel;
                        var providerUser = provider.users.last;
                        UserPref userPref = new UserPref(id: providerUser.id, name: providerUser.name, password: providerUser.password, isLogin: providerUser.isLogin, email: providerUser.email);
                        userPref.poin = total;
                        provider.updateUser(userPref);
                        print(prices);
                        print(transactionModel.itemCategories.length);
                        print(transactionModel.user.password);
                        createData(transactionModel);
                        Navigator.pushNamed(context, HomePage.routeName);
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

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<ItemCategories> values = snapshot.data;
    print(values.length);
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new ListTile(
              title: new Text("data"),
            ),
            new Divider(
              height: 2.0,
            ),
          ],
        );
      },
    );
  }
}
