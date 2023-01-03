import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gatherash/data/provider/auth_provider.dart';
import 'package:gatherash/models/auth_model.dart';
import 'package:gatherash/screen/home.dart';
import 'package:gatherash/screen/register.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  static const routeName = '/login_page';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

Future<UserModel> loginUser(String name, String password, BuildContext context)async {
  var data = await http.get(Uri.parse('https://rest-api-waste-bank-production.up.railway.app/api/v1/user/login/$name/$password'));

  var jsonData = json.decode(data.body);
  if (data.statusCode == 200) {
    return UserModel.fromJson(jsonData);
  }else {
    print('${data.statusCode}');
    return UserModel.fromJson(jsonData);
  }
}
class _LoginPageState extends State<LoginPage> {

  bool state = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _navigateLoginToScreen()async{
    await Future.delayed(Duration(seconds: 3));

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
            (route) => false);
  }
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
  TextStyle? textStyle = Theme.of(context).textTheme.subtitle2;
  var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: Consumer<AuthProvider>(
              builder: (_, provider, child) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Icon(Icons.restore_from_trash, size: 100,),
                    Text(
                      'Hello Guys',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, fontFamily: 'Montserrat'),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 25),child: Text("Welcome to My App, you've been one way more advanced", style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16, fontFamily: 'Montserrat'),)),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey,
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            style: textStyle,
                            controller: username,
                            // validator: (String value){},
                            decoration: InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter your username',
                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)
                                )
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            style: textStyle,obscureText: true,
                            controller: password,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Tidak boleh kosong';
                              }
                              if (value.length < 4) {
                                return 'Minimal 4 karakter';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your Password',
                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)
                                )
                            ),
                          ),
                        ),
                        state ? CircularProgressIndicator(): Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(primary: Colors.lightGreen,minimumSize: Size(size.width /1.3, 50)),
                                onPressed: () async {

                                  String usernameText = username.text;
                                  String passwordText = password.text;

                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    var userModel = await loginUser(usernameText, passwordText, context);
                                    if(userModel == null){
                                      setState(() {
                                        state = false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Gagal Login"),
                                        ),
                                      );
                                    }
                                    var name = userModel.name.toString();
                                    var email = userModel.email.toString();
                                    var password = userModel.password.toString();
                                    var poin = userModel.poin.toInt();
                                    var id = userModel.id.toInt();
                                    final result = await context.read<AuthProvider>().setUser(
                                      AuthModel(
                                        userName: name,
                                        email: email,
                                        password: password,
                                        poin: poin,
                                        id: id
                                      ),
                                    );
                                    // print(result);
                                    if (result) {
                                      usernameText = '';
                                      passwordText = '';
                                      setState(() {
                                        state = false;
                                      });
                                      if (mounted) {
                                      _navigateLoginToScreen();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Berhasil Login"),
                                          ),
                                        );
                                      }else {
                                        setState(() {
                                          state = false;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Gagal Login"),
                                          ),
                                        );
                                      }
                                        // Navigator.pushNamed(context, HomePage.routeName);
                                    }else {
                                      setState(() {
                                        state = false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Gagal Login"),
                                        ),
                                      );
                                    }
                                  }

                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.white,fontSize: 20),
                                )),
                          ),
                        ),
                      ],
                    )),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Already Havent account?', style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Montserrat'),),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, RegisterPage.routeName);
                          },
                          child: Text(' Register', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.blue),),

                        ),
                      ],
                    )
                  ],
                ),
              ),
            );}
          )),
    );
  }
}
