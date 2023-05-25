import 'dart:async';
import 'dart:convert';

import 'package:etrack/Authentication/auth_data.dart';
import 'package:etrack/components/Homepage/Manager/user_list.dart';
import 'package:etrack/models/building_user.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../../Authentication/databaseManager.dart';
import '../../../models/user.dart';
import 'manage_data.dart';


















class ManageUsers extends StatefulWidget {
  const ManageUsers({Key? key}) : super(key: key);

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {

  bool isWidgetVisible=true;
  AuthService auth=AuthService();

  List<PopupMenuItem> _options=[];

  Future? getUsers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _options=[
      PopupMenuItem(
        child: Text("Profile"),
        onTap: (){
          print("Profile");
        },
      ),
      PopupMenuItem(
          child: Text("Logout"),
          onTap:(){
            print("Logout");
            auth.userSignOut();
          }
      )
    ];


  }



  @override
  Widget build(BuildContext context) {
    String admin_name=Provider.of<UserObj>(context).adminName;
    return Scaffold(
      appBar: isWidgetVisible==true?AppBar(
        actions:[
          PopupMenuButton(itemBuilder: (context){
            return _options;
          })
        ]
      ):null,
      body:SingleChildScrollView(
        child: StreamProvider<UserBuilding?>.value(
          initialData: null,
          value: DatabaseBuilding(userName: admin_name).getBuildings,
          child: UserList(),
        ),
        )



    );
  }
}
