import 'package:flutter/material.dart';
import 'package:gatherash/data/provider/auth_provider.dart';
import 'package:gatherash/main.dart';
import 'package:gatherash/screen/change_poin.dart';
import 'package:gatherash/screen/home_content.dart';
import 'package:gatherash/screen/notification.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    initial();
    super.initState();
  }

  void initial() async {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLogin = await userProvider.isLogin;
    if (!isLogin) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LandingPage(),
            ),
            (route) => false);
      }
    } else {
      userProvider.getUser();
    }
  }



  int _indexCurrent = 0;
  List tabs = [
    HomeContent(),
    NotificationPage(),
    ChangePoinPage(),
    Center(child: Text("Sorry still development"),),
  ];

  @override
  Widget build(BuildContext context) {
    // return Container();
    print(_indexCurrent);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green[200],
        currentIndex: _indexCurrent,
        onTap: (index){
          setState(() {
            _indexCurrent = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.notifications),label: "Notification"),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded),label: "Change Poin"),
            BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
        ],
      ),
      body: tabs[_indexCurrent]
    );
  }

}

