import 'package:flutter/material.dart';
import 'package:project_alfin/data/database/database_helper.dart';
import 'package:project_alfin/data/database/db_provider.dart';
import 'package:project_alfin/models/user_pref.dart';
import 'package:project_alfin/screen/login.dart';
import 'package:project_alfin/screen/transaksi.dart';
import 'package:project_alfin/screen/trash_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseHelper databaseHelper;
  late Future<List<UserPref>> data;
  late bool _isLogin;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLogin = Provider.of<DbProvider>(context, listen: false).users.isNotEmpty;
    });
  }
  Future getState() async{
    return _isLogin = Provider.of<DbProvider>(context, listen: false).users.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    print('ISLOGIN ADALHA : ${_isLogin}');
    // return Container();
    var size = MediaQuery.of(context).size;
    return !_isLogin ? LoginPage() : Scaffold(
      body: Consumer<DbProvider>(
        builder: (_, provider, child) {
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
              Align(
                alignment: Alignment(0.0, -0.45),
                child: Container(
                  margin: EdgeInsets.only(top: 210),
                  child: Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Tukar Poin'),
                            Container(
                              height: 30,
                              width: 2,
                              color: Colors.black,
                            ),
                            Text('History')
                          ],
                        ),
                      ),
                    ),
                  )),
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
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, TransaksiPage.routeName);
                              },
                              child: Card(
                                child: Container(
                                  height: 70,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset('assets/wallet.png'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Tabung Sampah',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: Container(
                                height: 70,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('assets/location.png'),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Lokasi Bank Sampah',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: Container(
                                height: 70,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('assets/history.png'),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Riwayat Pesanan',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, TrashListPage.routeName);
                              },
                              child: Card(
                                child: Container(
                                  height: 70,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset('assets/bag.png'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Jenis Sampah',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Article',
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
                      Card(
                        child: Row(
                          children: [
                            Expanded(
                                child: Image.asset('assets/img1.png'), flex: 1),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Infografis',
                                          style: TextStyle(
                                            color: Colors.white,
                                              fontFamily: 'Montserrat',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              background: Paint()
                                                ..strokeWidth = 15.0
                                                ..color = Colors.green.shade200
                                                ..style = PaintingStyle.stroke
                                                ..strokeJoin = StrokeJoin.round)),
                                    )),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                          'Biodiesel: Energi Ramah Lingkungan Pengganti Minyak Bumi'),
                                    ),Row(
                                        children: [
                                          Icon(Icons.calendar_month),
                                          Text('03 Desember 2022',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),)
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: [
                            Expanded(
                                child: Image.asset('assets/img1.png'), flex: 1),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Infografis',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  background: Paint()
                                                    ..strokeWidth = 15.0
                                                    ..color = Colors.green.shade200
                                                    ..style = PaintingStyle.stroke
                                                    ..strokeJoin = StrokeJoin.round)),
                                        )),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                          'Biodiesel: Energi Ramah Lingkungan Pengganti Minyak Bumi'),
                                    ),Row(
                                      children: [
                                        Icon(Icons.calendar_month),
                                        Text('03 Desember 2022',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: [
                            Expanded(
                                child: Image.asset('assets/img1.png'), flex: 1),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Infografis',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  background: Paint()
                                                    ..strokeWidth = 15.0
                                                    ..color = Colors.green.shade200
                                                    ..style = PaintingStyle.stroke
                                                    ..strokeJoin = StrokeJoin.round)),
                                        )),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                          'Biodiesel: Energi Ramah Lingkungan Pengganti Minyak Bumi'),
                                    ),Row(
                                      children: [
                                        Icon(Icons.calendar_month),
                                        Text('03 Desember 2022',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          children: [
                            Expanded(
                                child: Image.asset('assets/img1.png'), flex: 1),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Infografis',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  background: Paint()
                                                    ..strokeWidth = 15.0
                                                    ..color = Colors.green.shade200
                                                    ..style = PaintingStyle.stroke
                                                    ..strokeJoin = StrokeJoin.round)),
                                        )),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                          'Biodiesel: Energi Ramah Lingkungan Pengganti Minyak Bumi'),
                                    ),Row(
                                      children: [
                                        Icon(Icons.calendar_month),
                                        Text('03 Desember 2022',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );}
      ),
    ) ;
  }
}
