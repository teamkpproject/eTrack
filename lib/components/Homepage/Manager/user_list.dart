import "package:etrack/Authentication/databaseManager.dart";
import "package:etrack/components/Homepage/Manager/user_data.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../../models/user.dart";






















class UserList extends StatefulWidget {

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {



  @override
  Widget build(BuildContext context) {

    final userName=Provider.of<UserBuilding?>(context) ;


      // print(" now the value ${userName!.building}");


    return Center(
      child: userName!=null?StreamProvider<List<UserName>>.value(
        initialData: [],
        value: DatabaseQuery(adminName: userName.userName, building_name: userName.building).getUserList,
        child: Users(),
      ):Center(

      ),
    );
  }
}
