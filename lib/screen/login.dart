import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_alfin/data/database/database_helper.dart';
import 'package:project_alfin/data/database/db_provider.dart';
import 'package:project_alfin/models/user_pref.dart';
import 'package:project_alfin/screen/home.dart';
import 'package:project_alfin/screen/register.dart';
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
  var data = await http.get(Uri.parse('http://10.0.2.2:8000/api/v1/user/login/$name/$password'));

  var jsonData = json.decode(data.body);
  String responseString = data.body;
  if (data.statusCode == 200) {
    return UserModel.fromJson(jsonDecode(responseString));
  }else {
    print('${data.statusCode}');
    throw Exception('Failed created User');
  }
}
class _LoginPageState extends State<LoginPage> {

  bool state = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  late UserModel userModels;

  @override
  Widget build(BuildContext context) {
  TextStyle? textStyle = Theme.of(context).textTheme.subtitle2;
  var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
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
                  Form(child: Column(
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
                          // validator: (String value){},
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
                                setState(() {
                                  state = true;
                                });
                                String usernameText = username.text;
                                String passwordText = password.text;
                                UserModel userModel = await loginUser(usernameText, passwordText, context);
                                UserPref userPref = new UserPref(name: usernameText,
                                    password: passwordText, isLogin: 1, poin: 0);
                                Provider.of<DbProvider>(context, listen: false).addUser(userPref);
                                usernameText = '';
                                passwordText = '';
                                setState(() {
                                  userModels = userModel;
                                  state = false;
                                });
                                Navigator.pushNamed(context, HomePage.routeName);
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
          )),
    );
  }
}
