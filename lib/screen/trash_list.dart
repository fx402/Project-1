import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_alfin/models/item_categories.dart';
import 'package:http/http.dart' as http;
import 'package:project_alfin/models/item_categories_model.dart';
import 'package:project_alfin/screen/transaksi.dart';

class TrashListPage extends StatefulWidget {
  static var routeName = '/trash-list';

  const TrashListPage({Key? key}) : super(key: key);

  @override
  State<TrashListPage> createState() => _TrashListPageState();
}

Future<List<ItemCategories>> getData() async {
  var data =
      await http.get(Uri.parse('https://rest-api-waste-bank-production.up.railway.app/api/v1/item-category'));

  var jsonData = json.decode(data.body);
  List<ItemCategories> itemCategoriess = [];
  for (var i in jsonData) {
    ItemCategories itemCategories = ItemCategories(
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


class _TrashListPageState extends State<TrashListPage> {
  late List<ItemCategoriesModel> listItem;
  late ItemCategoriesModel itemCategoriesModel;
  @override
  Widget build(BuildContext context) {
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
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Image(
                                          image: NetworkImage(
                                              snapshot.data[index].img))),
                                          Text(snapshot.data[index].nameItem),
                                          Text("${snapshot.data[index].prices}")
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
                  onPressed: () {
                    Navigator.pushNamed(context, TransaksiPage.routeName);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
