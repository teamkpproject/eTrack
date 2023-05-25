import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../models/building_user.dart';
import '../models/user.dart';
import 'databaseManager.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;








  //create a user obj based on FirebaseUser
  UserObj? _userFromFirebaseUser(User? user){

    return user!=null ?UserObj(uid: user.uid,adminName: user.email!.split("@")[0]):null;
  }

  //auth change user stream- ensures we get some info when user signs in or out
  Stream<UserObj?> get user{
    return _auth.authStateChanges()
    //.map((User? user)=> _userFromFirebaseUser(user));
        .map((User? user) =>_userFromFirebaseUser(user));
  }



  //sign in anonymous
  Future signInAnon() async{
    try{
      UserCredential  result= await _auth.signInAnonymously();
      //result has user
      User user=result.user!;
      return _userFromFirebaseUser(user);

    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in email and password
  Future signInWithEmailAndPassword(String email,String password) async{

    try{
      UserCredential result= await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user=result.user;


      String buildingName=await getUserBuilding(email.split("@")[0]);
      print("admin_building ${buildingName}");

      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }

  }

  Future getUserBuilding(String adminName) async{
    try {
      return await FirebaseFirestore.instance.collection("admin_building").doc(
          adminName).get().then((value) => value.data()!["building"]);
    }
    catch(e){
      print(e);
    }
  }

  Future setUserBuilding(String adminName,String building_name) async{
    print("the building is ${building_name}");
    return await FirebaseFirestore.instance.collection("admin_building").doc(adminName).set({"building":building_name});
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email,String password,String building_name) async{

    try{

      UserCredential authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user=authResult.user;

      //create a document for the new user
       await setUserBuilding(email.split("@")[0],building_name);



      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }

  }

  //sign out
  Future userSignOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

}