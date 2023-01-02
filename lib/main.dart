import 'package:flutter/material.dart';
import 'package:project_alfin/data/provider/auth_provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
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

  @override
  void initState() {
    initial();
    super.initState();
  }


  void initial() async {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLogin = await userProvider.isLogin;
    if (isLogin) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
                (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "Clean your waste"),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    style: TextStyle(fontStyle: FontStyle.normal, fontSize: 16),
                      textAlign: TextAlign.center,
                      "Manage the waste become to clean \nThe clean environment can make you happy"),
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
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                                  (route) => false);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen, minimumSize: Size(150, 40)),
                        child: const Text('Login'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                                  (route) => false);
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
