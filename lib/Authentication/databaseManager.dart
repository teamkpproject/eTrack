import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etrack/models/building_user.dart';
import 'package:etrack/models/points_format.dart';

import '../models/user.dart';














// class DatabaseService{
//
//   final String uid;
//   DatabaseService({required this.uid});
//   //collection referance
//   final CollectionReference adminCollection = FirebaseFirestore.instance.collection("admins");
//
//   Future updateUserData(String sugars,String name,int strength) async{
//
//     // return await adminCollection.doc(uid).collection(collectionPath)
//
//   }
//
//   //get brews collection get snaphsot when something changes
//   Stream<QuerySnapshot> get brews{
//
//     return adminCollection.snapshots();
//
//   }
//
//
//   //userData from snapshot
//   UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
//
//     String _userDataJSON=jsonEncode(snapshot.data());
//     Map<String,dynamic> _userData=jsonDecode(_userDataJSON);
//
//     print("user data ${_userData["strength"]}");
//
//
//
//     return UserData(
//       uid:uid,
//       name:_userData["name"],
//       sugars: _userData["sugars"],
//       strength: _userData["strength"],
//     );
//
//   }
//
//   //stream to listen to chnages in brew collection and get document snapshot//not used insted used userData
//   Stream<DocumentSnapshot> get userDataDocument{
//     return adminCollection.doc(uid).snapshots();
//   }
//
//   Stream<UserData> get userData{
//     print("brew snapshots ${adminCollection.doc(uid).snapshots().map(_userDataFromSnapshot)}");
//     return adminCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
//   }
//
//
// }

class DatabaseQuery{

  final String adminName;
  final String building_name;
  DatabaseQuery({required this.adminName,required this.building_name});
  //connect to database
  final FirebaseFirestore adminCollection=FirebaseFirestore.instance;

  // List<UserData> _userListFromSnapshot(DocumentSnapshot snapshot){
  //   return snapshot.data() ?? [];
  // }

  //brewList
  List<UserName> _userListFromSnapshot(QuerySnapshot snapshot){

    print("userlist updated from list ${snapshot.docs.map((value) => value.id)}");
    // return snapshot.docs.map((documentValue){
    //   print("the value ${documentValue.data()}");
    //   String docVal=jsonEncode(documentValue.data());
    //   Map<String,dynamic> docValueJson=jsonDecode(docVal);
    //   print("values ${docVal}");
    //   return UserData(name: docValueJson["name"] ?? "");
    // }).toList();
    return snapshot.docs.map((value)=>UserName(name: value.id)).toList();
  }

  //return a Stream of Query Snapshots
  // Stream<> get users{
  //   print("data from server ${adminCollection.doc(uid).snapshots().map((value) => value.data().toString()).toList()}");
  //   return adminCollection.doc(uid).get().then((value) => value);
  //
  // }

  Stream<List<UserName>> get getUserList{
    return adminCollection.collection("admins").doc(building_name).collection("users").snapshots().map(_userListFromSnapshot);
  }

  Future registerAsAdmin() async{
    DateTime date=DateTime.now();
    String dateFormat="${date.day}-${date.month}-${date.year}";
    return await adminCollection.doc(adminName).collection("users").doc("user_01").collection(dateFormat).doc().set({"lat":0.1,"long":0.2,"isVisited":false});
  }


  // Stream<List<UserData>> get userList{
  //
  //   print("the user list ${adminName}");
  //   return adminCollection.collection("admins").doc(building_name).snapshots().map(_userListFromSnapshot);
  //
  // }






}

class DatabaseBuilding{

  String userName;

  DatabaseBuilding({required this.userName});

  UserBuilding _buildingListFromSnapshot(QuerySnapshot snapshot){

    print("userlist updated ${snapshot.docs.length }");
    dynamic buildingDocs= snapshot.docs;
    String building="";
    for(int i=0;i<buildingDocs.length;i++){

      if(buildingDocs[i].id==userName){
        building=jsonDecode(jsonEncode(buildingDocs[i].data()))["building"].toString();
      }



    }

  print("building is${building}");
    return UserBuilding(userName: userName, building: building);
  }


  Stream<UserBuilding> get getBuildings{
    return FirebaseFirestore.instance.collection("admin_building").snapshots().map(_buildingListFromSnapshot);
  }

  // Future getUserBuildings() async{
  //   try{
  //     return await
  //   }
  //   catch(e){
  //     print(e.toString());
  //     return null;
  //   }
  // }

}

class DatabaseUser{
  String userName;
  String buildingName;
  
  DatabaseUser({required this.userName,required this.buildingName});
  

  List<UserDate> _userDatesFromList(QuerySnapshot snapshot){
    List<QueryDocumentSnapshot> values=snapshot.docs;

    for(int i=0;i<values.length;i++){


      print("data is ${values[i].get("no_checkpoints")}");
    }

    return snapshot.docs.map((value) {
      int checkpoints=value.get("no_checkpoints");
      List<UserData> locations=[];
      for(int r=0;r<checkpoints;r++){
        GeoPoint location=value.get("checkpoint${r+1}")[0];
        bool isVisited=value.get("checkpoint${r+1}")[1];
        print("checkpoints is ${location.latitude} ${isVisited}");
        locations.add(UserData(lat: location.latitude, long: location.longitude, isVisited: isVisited));
      }
      return UserDate(date: value.id, locations: locations);
    }).toList();
  }

  Stream<List<UserDate>> getUserData() {
    print("data fetching...");
    return FirebaseFirestore.instance.collection("admins").doc(buildingName).collection("users").doc(userName).collection("date").snapshots().map(_userDatesFromList);
  }
  
}