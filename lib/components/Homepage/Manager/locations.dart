import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import 'admin_map.dart';



















class LocationDates extends StatefulWidget {
  String building;
  String userName;

  LocationDates({required this.building,required this.userName});

  @override
  State<LocationDates> createState() => _LocationDatesState();
}

class _LocationDatesState extends State<LocationDates> {


  @override
  Widget build(BuildContext context) {
    List<UserDate> dates=Provider.of<List<UserDate>>(context);
    return Container(
      height: MediaQuery.of(context).size.height*0.9,
      child: ListView.builder(
          itemCount: dates.length,
          itemBuilder: (context,index){
            return Card(
              child: ListTile(
                onTap: () async{
                  List<UserData> locations=dates[index].locations;
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>MapLoc(building:widget.building,userName:widget.userName,locations: locations,)));
                },
                title: Text(dates[index].date),
              ),
            );
          }),
    );
  }
}
