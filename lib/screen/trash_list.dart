import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_alfin/data/database/database_helper.dart';
import 'package:project_alfin/data/database/db_provider.dart';
import 'package:project_alfin/models/item_categories.dart';
import 'package:http/http.dart' as http;
import 'package:project_alfin/models/item_categories_model.dart';
import 'package:project_alfin/models/transaction_model.dart';
import 'package:provider/provider.dart';

class TrashListPage extends StatefulWidget {
  static var routeName = '/trash-list';

  const TrashListPage({Key? key}) : super(key: key);

  @override
  State<TrashListPage> createState() => _TrashListPageState();
}

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

Future<TransactionModel> createData(
  List<ItemCategoriesModel> itemCategoriesModel,
    Map<String, dynamic> jsonObjectUser) async {
  // var data =
  // await http.post(Uri.parse('http://10.0.2.2:8000/api/v1/transaction/create'),
  //     headers:<String, String>{"Content-Type": "application/json"},
  //     body: jsonEncode(<String, dynamic>{
  //       "user": jsonObjectUser,
  //       "itemCategories": jsonEncode(itemCategoriesModel),
  //       "price":
  //     }));

  var jsonData = json.decode(data.body);
  // List<TransactionModel> transactionModels = [];
  // for (var i in jsonData) {
  //   ItemCategories itemCategories = new ItemCategories(
  //       id: i["id"],
  //       nameItem: i["nameItem"],
  //       prices: i["prices"],
  //       img: i["img"]);
  //   transactionModels.add(itemCategories);
  // }
  String responseString = data.body;
  if (data.statusCode == 200) {
    return itemCategoriess;
  } else {
    print('${data.statusCode}');
    throw Exception('Failed created User');
  }
}

class _TrashListPageState extends State<TrashListPage> {
  late List<ItemCategoriesModel> listItem;
  late ItemCategoriesModel itemCategoriesModel;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jsonObjectUser = {
      "id": Provider.of<DbProvider>(context, listen: false).users.last.id,
      "name": Provider.of<DbProvider>(context, listen: false).users.last.name,
      "password": Provider.of<DbProvider>(context, listen: false).users.last.password
    };
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Jenis Sampah"),
        backgroundColor: Colors.green.shade300,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: getData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  var state = snapshot.connectionState;
                  switch (state) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    case ConnectionState.done:
                      print('${snapshot.data.length}');
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) => Container(
                          child: GestureDetector(
                            onTap: (){
                              itemCategoriesModel.id = snapshot.data[index].id;
                              itemCategoriesModel.nameItem = snapshot.data[index].nameItem;
                              itemCategoriesModel.prices = snapshot.data[index].prices;
                              itemCategoriesModel.img = snapshot.data[index].img;
                              listItem.add(itemCategoriesModel);
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Image(
                                          image: NetworkImage(
                                              snapshot.data[index].img))),
                                          Text(snapshot.data[index].nameItem),
                                          Text(snapshot.data[index].prices.toString() ??
                                      "")
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    default:
                      return Text('DEFAULT');
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreen,
                      minimumSize: Size(size.width / 1.2, 40)),
                  child: const Text('Tukar Sampah'),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
