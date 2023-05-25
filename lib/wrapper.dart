import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'components/Homepage/homepage.dart';
import 'components/Login/login.dart';
import 'models/user.dart';

















class Wrapper extends StatelessWidget {

  var id=Login.id;


  @override
  Widget build(BuildContext context) {

    final user=Provider.of<UserObj?>(context);

    if(user==null)
    {
      return Login();
    }
    else{
      return Homepage(isAdmin: true);
    }
  }
}