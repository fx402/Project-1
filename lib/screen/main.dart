import 'package:flutter/material.dart';
import 'package:project_alfin/data/database/db_provider.dart';
import 'package:project_alfin/screen/home.dart';
import 'package:project_alfin/screen/login.dart';
import 'package:project_alfin/screen/register.dart';
import 'package:project_alfin/screen/transaksi.dart';
import 'package:project_alfin/screen/trash_list.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DbProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          LoginPage.routeName: (context) => LoginPage(),
          RegisterPage.routeName: (context) => RegisterPage(),
          HomePage.routeName: (context) => HomePage(),
          TrashListPage.routeName: (context) => TrashListPage(),
          TransaksiPage.routeName: (context) => TransaksiPage()
        },
        home: const LandingPage(),
      ),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late bool _isLogin;

  @override
  void initState() {
    super.initState();
    getState();
    setState(() {
      _isLogin = Provider.of<DbProvider>(context, listen: false).users.isNotEmpty;
    });
  }

  Future getState() async{
    return _isLogin = Provider.of<DbProvider>(context, listen: false).users.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    print('$_isLogin');
    return _isLogin ? HomePage() :  Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/landing page.png'),
                Text(
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    textAlign: TextAlign.center,
                    "Get  Your  Story"),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    style: TextStyle(fontStyle: FontStyle.normal, fontSize: 16),
                      textAlign: TextAlign.center,
                      "Show your expression with this app and find \nthe right moment on another person"),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green, minimumSize: Size(150, 40)),
                        child: const Text('Register'),
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterPage.routeName);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen, minimumSize: Size(150, 40)),
                        child: const Text('Login'),
                        onPressed: () {
                          Navigator.pushNamed(context, LoginPage.routeName);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
