import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gatherash/data/provider/auth_provider.dart';
import 'package:gatherash/main.dart';
import 'package:gatherash/models/NotificationModel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  static var routeName = "/notification";

  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}
Future<List> getAllNotification(int? id)async{
  var data = await http.get(Uri.parse('https://rest-api-waste-bank-production.up.railway.app/api/v1/notification/user/$id'));

  var jsonData = json.decode(data.body);
  if (data.statusCode == 200) {
    print(jsonData);
    List<dynamic> notifications = jsonData.map((e) => NotificationModel.fromJson(e)).toList();
    return notifications;
  }else {
    print(jsonData);
    List<dynamic> notifications = jsonData.map((e) => NotificationModel.fromJson(e)).toList();
    return notifications;
  }
}
class _NotificationPageState extends State<NotificationPage> {
  @override
  initState() {
    initial();
    super.initState();
  }

  void initial() async {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    userProvider.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(builder: (_, provider, child) {
       return SafeArea(
         child: Container(
             child: FutureBuilder(
                 future: getAllNotification(provider.user?.id),
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
                       return Column(
                         children: [
                           Text("Notification",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                           ListView.builder(
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
                                       "Title: ${snapshot.data[index].title}",
                                       maxLines: 1,
                                       overflow: TextOverflow.ellipsis,
                                     ),
                                     leading:
                                     Icon(Icons.notifications),
                                     subtitle: Text(
                                       //menampilkan deskripsi berita
                                       "Description: ${snapshot.data[index].description}",
                                       maxLines: 2,
                                       overflow: TextOverflow.ellipsis,
                                     ),
                                   ),
                                 );
                                 //     return Text("data");
                               }),
                         ],
                       );
                     default:
                       return Text('Data Empty');
                   }
                 })
         ),
       );
      }
      ),
    );
  }
}
