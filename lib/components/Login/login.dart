import 'package:etrack/components/Login/register.dart';
import 'package:flutter/material.dart';
import './sign_in.dart';















class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static final String id="Login";
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool showSignedIn = true;
  void toggleView(){
    setState(() {
      showSignedIn=!showSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignedIn){
      return SignIn(toggleView:toggleView);
    }
    else{
      return Register(toggleView:toggleView);
    }

  }
}
