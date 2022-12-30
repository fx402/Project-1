import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_alfin/data/database/database_helper.dart';
import 'package:project_alfin/data/database/db_provider.dart';
import 'package:project_alfin/models/item_categories.dart';
import 'package:project_alfin/models/transaction_model.dart';
import 'package:project_alfin/models/user_model.dart';
import 'package:project_alfin/models/user_pref.dart';
import 'package:project_alfin/screen/login.dart';
import 'package:project_alfin/screen/transaksi.dart';
import 'package:project_alfin/screen/trash_list.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<List<TransactionModel>> getAllTransaction(int id) async {
  var data = await http
      .get(Uri.parse('http://10.0.2.2:8000/api/v1/transaction/user/$id'));

  Iterable jsonData = json.decode(data.body);

  if (data.statusCode == 200) {
    List<TransactionModel> transactions =
        jsonData.map((e) => TransactionModel.fromJson(e)).toList();
    return transactions;
  } else {
    print('${data.statusCode}');
    throw Exception('Failed created User');
  }
}

  // List<TransactionModel> transactions= [];
  // for(var i in jsonData){
  //   print(i["itemCategories"]);
  //   print(i["user"]);
  //   print(i["id"]);
  //   print(i["itemCategories"]);
  //
  //   // TransactionModel transactionModel = TransactionModel(
  //   //     id: i["id"],
  //   //     user: i['user'],
  //   //     itemCategories: List<ItemCategories>.from((i['itemCategories'] as List).map((element) =>
  //   //         ItemCategories.fromJson(element)).where((element) => element.id != null
  //   //         && element.nameItem != null
  //   //         && element.prices != null
  //   //         && element.img != null)
  //   //     ),
  //   //     price: i["price"],
  //   //     total: i["total"]);
  //   // // print(transactionModel.price);
  //   // transactions.add(transactionModel);
  // }

class _HomePageState extends State<HomePage> {
  late DatabaseHelper databaseHelper;
  late Future<List<UserPref>> data;
  List<TransactionModel> transactions = [];
  late bool _isLogin;
  var id;

  getData() async {
    transactions = await getAllTransaction(id);
  }

  @override
  void initState() {
    super.initState();
    getAllTransaction(1);
    // getAllTransaction(Provider.of<DbProvider>(context, listen: false).users.last.id);
    setState(() {
      _isLogin =
          Provider.of<DbProvider>(context, listen: false).users.isNotEmpty;
    });
  }

  Future getState() async {
    return _isLogin =
        Provider.of<DbProvider>(context, listen: false).users.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    var size = MediaQuery.of(context).size;
    return !_isLogin
        ? LoginPage()
        : Scaffold(
            body: Consumer<DbProvider>(builder: (_, provider, child) {
              // return FutureBuilder(
              //     future: getAllTransaction(1),
              //     builder: (BuildContext context, AsyncSnapshot snapshot) {
              //       print(snapshot.data.length);
              //       var state = snapshot.connectionState;
              //       switch (state) {
              //         case ConnectionState.none:
              //         case ConnectionState.active:
              //         case ConnectionState.waiting:
              //           return CircularProgressIndicator();
              //         case ConnectionState.done:
              //           // return ListView.builder(
              //           //     itemCount: snapshot.data.length,
              //           //     itemBuilder: (_, index) => Container(
              //           //         child: GestureDetector(
              //           //           onTap: (){
              //           //             // itemCategoriesModel.id = snapshot.data[index].id;
              //           //             // itemCategoriesModel.nameItem = snapshot.data[index].nameItem;
              //           //             // itemCategoriesModel.prices = snapshot.data[index].prices;
              //           //             // itemCategoriesModel.img = snapshot.data[index].img;
              //           //             // listItem.add(itemCategoriesModel);
              //           //           },
              //           //         )
              //           //     ));
              //           // break;
              //         print(snapshot.data);
              //           return Text("data");
              //         default:
              //           return Text('DEFAULT');
              //       }
              //     });

              print('IDnya : ${id}');
                return SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: size.height * .3,
                        color: Colors.green,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hi, ${provider.users.first.name}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                  Text('Selamat Datang',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat',
                                          color: Colors.white)),
                                ],
                              ),
                                  GestureDetector(onTap: () {
                                    provider.deleteUser();
                                    Navigator.pushNamed(context, LoginPage.routeName);
                                  },
                                      child: Icon(Icons.logout)
                                  )
                            ],
                          ),
                      ),
                      Align(
                        alignment: Alignment(0.0, 0.0),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 70),
                          child: SizedBox(
                            height: size.height * .15,
                            width: size.width * .8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.green.shade200),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset("assets/usdcoin.png"),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    'Poin Anda',
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                                  child: Text('${provider.users.first.poin}',
                                                      style: TextStyle(
                                                          fontFamily: 'Montserrat',
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              width: 55,
                                              height: 55,
                                              color: Colors.green,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Image.asset('assets/money.png'),
                                                  Expanded(
                                                    child: Text(
                                                      'Tukar Poin',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 10,
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: EdgeInsets.only(top: size.height / 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    'Menu',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 60),
                                height: 100,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                                Navigator.pushNamed(context, TrashListPage.routeName);
                                        },
                                        child: Card(
                                          child: Container(
                                            height: 80,
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(flex: 2,child: Image.asset('assets/wallet.png')),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Expanded(flex: 1,
                                                  child: Text(
                                                    'Tabung Sampah',
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w600),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('History',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    Text('Lihat Semua',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400))
                                  ],
                                ),
                              ),
                              FutureBuilder(
                                future: getAllTransaction(provider.users.last.id),
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    print(provider.users.last.id);
                                    var state = snapshot.connectionState;
                                    switch (state) {
                                      case ConnectionState.none:
                                      case ConnectionState.active:
                                      case ConnectionState.waiting:
                                        return CircularProgressIndicator();
                                      case ConnectionState.done:
                                        return ListView.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (_, index) => Container(
                                            child: GestureDetector(
                                              onTap: (){
                                                // itemCategoriesModel.id = snapshot.data[index].id;
                                                // itemCategoriesModel.nameItem = snapshot.data[index].nameItem;
                                                // itemCategoriesModel.prices = snapshot.data[index].prices;
                                                // itemCategoriesModel.img = snapshot.data[index].img;
                                                // listItem.add(itemCategoriesModel);
                                              },
                                            )
                                        ));
                                        break;
                                      default:
                                        return Text('DEFAULT');
                                    }
                                  }),

                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );}
                ),
          );
  }
}
