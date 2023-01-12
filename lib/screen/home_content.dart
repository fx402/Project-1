
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gatherash/data/provider/auth_provider.dart';
import 'package:gatherash/models/transaction_model.dart';
import 'package:gatherash/screen/login.dart';
import 'package:gatherash/screen/trash_list.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeContent extends StatelessWidget {
  Future<List> getTransactions(int? id) async {
    final response;
    if (id == null) {
      response = await http.get(Uri.parse(
          "https://rest-api-waste-bank-production.up.railway.app/api/v1/transaction"));
    } else {
      response = await http.get(Uri.parse(
          "https://rest-api-waste-bank-production.up.railway.app/api/v1/transaction/user/$id"));
    }
    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      List<dynamic> transactions =
      data.map((e) => TransactionModel.fromJson(e)).toList();
      print(transactions);
      return transactions;
    } else {
      List<TransactionModel> transactions =
      data.map((e) => TransactionModel.fromJson(e)).toList();
      print("error");
      return transactions;
    }
  }
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<AuthProvider>(builder: (_, provider, child) {
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
                        'Hi, ${provider.user?.userName ?? ""}',
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
                  GestureDetector(
                      onTap: () {
                        provider.deleteUSer();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                                (route) => false);
                      },
                      child: Icon(Icons.logout))
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
                                        child: Text('${provider.user?.poin}',
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
                              onTap: () {
                                Navigator.pushNamed(
                                    context, TrashListPage.routeName);
                              },
                              child: Card(
                                child: Container(
                                  height: 80,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Image.asset(
                                              'assets/wallet.png')),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        flex: 1,
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
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    FutureBuilder(
                        future: getTransactions(provider.user?.id),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          var state = snapshot.connectionState;
                          switch (state) {
                            case ConnectionState.none:
                            case ConnectionState.active:
                            case ConnectionState.waiting:
                              return Center(
                                  child: CircularProgressIndicator());
                            case ConnectionState.done:
                              if (snapshot.data.length == null) {
                                return Center(child: Text('Data Empty'));
                              }
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(8),
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                      ),
                                      //listtile adalah widget yang disediakan flutter berisi 3 properti yang kita pakai
                                      //properti: leading, title, dan subtitle. di dalam setiap properti kalian bebas melakukan customisasi
                                      child: ListTile(
                                        title: Text(
                                          //menampilkan data judul
                                          "Pemesan: ${snapshot.data[index].user.name} | ${snapshot.data[index].typeSend}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        leading:
                                        Icon(Icons.restore_from_trash),
                                        subtitle: Text(
                                          //menampilkan deskripsi berita
                                          "Total: ${snapshot.data[index].total} seharga ${snapshot.data[index].price} Alamat ${snapshot.data[index].address}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  });
                            default:
                              return Text('Data Empty');
                          }
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
