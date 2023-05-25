import 'package:cloud_firestore/cloud_firestore.dart';

class UserObj{
  final String  uid;
  final String adminName;
  UserObj({required this.uid ,required this.adminName});
}












class UserData{

  double lat;
  double long;
  bool isVisited;

  UserData({required this.lat,required this.long,required this.isVisited});

}

class UserName{
  final String name;
  UserName({required this.name});
}


class UserDate{
  String date;
  List<UserData> locations;
  UserDate({required this.date,required this.locations});
}


class UserBuilding{
  String userName;
  String building;

  UserBuilding({required this.userName,required this.building});
}

class UserDataFormat{
  GeoPoint geopoint;
  bool isVisited;
  UserDataFormat({required this.geopoint,required this.isVisited});
}

class UserLocationsFormat{
  UserDataFormat userDataFormat;
  String checkpointName;
  UserLocationsFormat({required this.userDataFormat,required this.checkpointName});
}