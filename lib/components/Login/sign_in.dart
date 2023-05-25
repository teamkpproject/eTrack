import 'package:flutter/material.dart';

import '../../Authentication/auth_data.dart';
import '../../constants/constants.dart';
import '../../constants/loading.dart';
















class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {



  final AuthService _auth=AuthService();

  //to get values currently in form state
  final _formKey=GlobalKey<FormState>();

  bool loading=false;

  //text field state
  String email='';
  String password='';
  String error="";


  @override
  Widget build(BuildContext context) {
    return loading? Loading() :Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Login'),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(icon:Icon(Icons.person),onPressed: (){
              widget.toggleView();
            }),
          ],
        ),
        body:Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
          child: Center(
            child:Form(
              key: _formKey,
              child:Column(
                children: <Widget>[
                  SizedBox(height:20.0),
                  TextFormField(
                      decoration:textInputDecoration.copyWith(hintText: 'Email'),
                      validator:(val)=>val!.isEmpty?"Please enter a valid email":null,
                      onChanged: (val){
                        setState(() {
                          email=val;
                        });
                      }),
                  SizedBox(height:20.0),
                  TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val)=>val!.length<6?"Please enter a password 6+ long":null,
                      obscureText: true,
                      onChanged:(val){
                        setState(() {
                          password=val;
                        });
                      } ),
                  SizedBox(height:20.0),
                  ElevatedButton(
                      child:Text('Sign In',
                          style: TextStyle(color: Colors.brown)),
                      onPressed:() async {
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            loading=true;
                          });
                          dynamic result=await _auth.signInWithEmailAndPassword(email, password);
                          if(result==null){
                            setState(() {
                              loading=false;
                              error="Couldn't Log In with those credentials";

                            });
                          }
                        }
                      } ),
                  SizedBox(height:12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red,fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}




//sign In anonymously

class signInAnon extends StatefulWidget {
  const signInAnon({Key? key}) : super(key: key);

  @override
  State<signInAnon> createState() => _signInAnonState();
}

class _signInAnonState extends State<signInAnon> {
  final AuthService _auth=AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0,horizontal:100.0),
      child:ElevatedButton(
        child:Text("Sign In"),
        onPressed: () async {

          dynamic resultUser=await _auth.signInAnon();
          if(resultUser == null){
            print('Error not signed in');
          }
          else{
            print('signed in');
            print(resultUser.uid);
          }
        },
      ),
    );
  }
}
