import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_alfin/screen/home.dart';
import 'package:project_alfin/screen/login.dart';

import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  static var routeName = '/register_page';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

Future<UserModel> registerUsers(String username, String email, String password, BuildContext context)async {
  // var url  =Uri. "http://127.0.0.1:8000/api/v1/user/create";
  var response = await http.post(Uri.parse('http://10.0.2.2:8000/api/v1/user/create'),
  headers:<String, String>{"Content-Type": "application/json"},
  body: jsonEncode(<String, String>{
    "name": username,
    "email": email,
    "password": password
  }));

  String responseString = response.body;
  if (response.statusCode == 200) {
    return UserModel.fromJson(jsonDecode(responseString));
  }else {
    throw Exception('Failed created User');
  }
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  late UserModel userModels;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    TextStyle? textStyle = Theme.of(context).textTheme.subtitle2;
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
              Text("Fill your data for join to community", style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16, fontFamily: 'Montserrat'),),
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
                      style: textStyle,
                      controller: email,
                      // validator: (String value){},
                      decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your Email',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green.shade300,minimumSize: Size(size.width /1.3, 50)),
                          onPressed: () async {
                          String usernameText = username.text;
                          String emailText = email.text;
                          String passwordText = password.text;
                          UserModel userModel = await registerUsers(usernameText, emailText, passwordText, context);
                          usernameText = '';
                          emailText = '';
                          passwordText = '';
                          Navigator.pushNamed(context, LoginPage.routeName);
                          setState(() {
                            userModels = userModel;
                          });
                          },
                          child: Text(
                            'Register',
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
                  Text('Already Have account?', style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Montserrat'),),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, LoginPage.routeName);
                    },
                      child: Text(' Login', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.blue),)),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}


class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  MyAlertDialog({
    required this.title,
    required this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: this.actions,
      content: Text(
        this.content,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}