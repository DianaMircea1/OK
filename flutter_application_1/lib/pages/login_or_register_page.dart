import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/register_page.dart';

class LoginorRegisterPage extends StatefulWidget{
  const LoginorRegisterPage({super.key});

  @override
  State<LoginorRegisterPage> createState() => _LoginorRegisterPageState();
}

class _LoginorRegisterPageState extends State<LoginorRegisterPage>{
  // initialize show login page
  bool showLoginPage = true;

  // toggle between login and register page
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context){
    if (showLoginPage){
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
  