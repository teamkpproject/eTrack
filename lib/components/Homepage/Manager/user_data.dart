import 'package:etrack/Authentication/databaseManager.dart';
import 'package:etrack/components/Homepage/Manager/locations.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import 'admin_map.dart';


















class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {

    List<UserName> users=Provider.of<List<UserName>>(context);
    UserBuilding building=Provider.of<UserBuilding>(context);
    return Container(
      height: MediaQuery.of(context).size.height*0.9,
      child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context,index){
            return Card(
              child: ListTile(
                onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              Scaffold(
                                appBar: AppBar(),
                                  body: StreamProvider<List<UserDate>>.value(
                                    initialData: [],
                                    value: DatabaseUser(userName: users[index].name, buildingName: building.building).getUserData(),
                                    child: LocationDates(building: building.building,userName: users[index].name,),
                                  )
                              )));
                },
                title: Text(users[index].name),
              ),
            );
          }
      ),
    );
  }
}
